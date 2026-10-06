import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'api_exception.dart';
import 'json.dart';
import 'token_store.dart';

/// REST client of the VietGara API (API Specification): bearer auth with a
/// transparent refresh-token rotation on 401, JSON bodies, and typed errors
/// carrying the stable error code the UI translates. Mirrors the web
/// admin's `src/lib/api.ts`.
class ApiClient {
  ApiClient({
    required http.Client client,
    required TokenStore tokenStore,
    required String baseUrl,
    String Function()? language,
    this.timeout = const Duration(seconds: 20),
  }) : _client = client,
       _tokenStore = tokenStore,
       _baseUrl = baseUrl.endsWith('/')
           ? baseUrl.substring(0, baseUrl.length - 1)
           : baseUrl,
       _language = language ?? (() => 'vi');

  final http.Client _client;
  final TokenStore _tokenStore;
  final String _baseUrl;
  final String Function() _language;
  final Duration timeout;

  Tokens? _tokens;
  bool _loaded = false;
  Future<bool>? _refreshing;

  /// Called once the session can no longer be refreshed (signed out
  /// elsewhere, refresh token expired or revoked).
  void Function()? onSessionExpired;

  /// The tokens of the stored session, if any (read once from the store).
  Future<Tokens?> tokens() async {
    if (!_loaded) {
      _tokens = await _tokenStore.read();
      _loaded = true;
    }
    return _tokens;
  }

  /// Keeps the tokens of a new session (sign-in, e-mail verification).
  Future<void> saveTokens(Tokens tokens) async {
    _tokens = tokens;
    _loaded = true;
    await _tokenStore.write(tokens);
  }

  Future<void> clearSession() async {
    _tokens = null;
    _loaded = true;
    await _tokenStore.clear();
  }

  Future<Json> get(String path, {Map<String, Object?>? query}) =>
      _json('GET', path, query: query);

  Future<Json> post(String path, [Object? body = const <String, Object>{}]) =>
      _json('POST', path, body: body);

  Future<Json> patch(String path, Object body) =>
      _json('PATCH', path, body: body);

  Future<Json> put(String path, Object body) => _json('PUT', path, body: body);

  Future<Json> delete(String path) => _json('DELETE', path);

  /// A creation with financial impact: a settlement or a payment. The API
  /// requires an `Idempotency-Key` for these and answers a repeated key
  /// with the first answer, without creating anything again. Make one key
  /// per user action with [newIdempotencyKey] and send the same key when
  /// that action is retried, for example after a timeout, so the record
  /// is created at most once.
  Future<Json> postIdempotent(
    String path,
    Object body, {
    required String idempotencyKey,
  }) => _json(
    'POST',
    path,
    body: body,
    headers: {'Idempotency-Key': idempotencyKey},
  );

  /// A request outside the session (sign-in, registration, password reset):
  /// no bearer token, and no refresh on 401.
  Future<Json> postPublic(String path, Object body) =>
      _json('POST', path, body: body, authenticated: false);

  /// A raw file answer (PDF and Excel exports, FR-DOC-01/02).
  Future<Uint8List> bytes(String path) async {
    final response = await _send('GET', path, accept: '*/*');
    if (response.statusCode >= 400) {
      throw ApiException.fromBody(response.statusCode, _decode(response));
    }
    return response.bodyBytes;
  }

  Uri _uri(String path, Map<String, Object?>? query) {
    final params = <String, String>{
      for (final entry in (query ?? const <String, Object?>{}).entries)
        if (entry.value != null && entry.value.toString().isNotEmpty)
          entry.key: entry.value.toString(),
    };
    final uri = Uri.parse('$_baseUrl/v1$path');
    return params.isEmpty ? uri : uri.replace(queryParameters: params);
  }

  Future<Json> _json(
    String method,
    String path, {
    Map<String, Object?>? query,
    Object? body,
    bool authenticated = true,
    Map<String, String> headers = const {},
  }) async {
    final response = await _send(
      method,
      path,
      query: query,
      body: body,
      authenticated: authenticated,
      headers: headers,
    );
    final decoded = _decode(response);
    if (response.statusCode >= 400) {
      throw ApiException.fromBody(response.statusCode, decoded);
    }
    return decoded is Json ? decoded : const {};
  }

  Future<http.Response> _send(
    String method,
    String path, {
    Map<String, Object?>? query,
    Object? body,
    bool authenticated = true,
    String accept = 'application/json',
    bool retry = true,
    Map<String, String> headers = const {},
  }) async {
    final token = authenticated ? (await tokens())?.accessToken : null;
    final request = http.Request(method, _uri(path, query))
      ..headers.addAll({
        'Accept': accept,
        'Accept-Language': _language(),
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        if (body != null) 'Content-Type': 'application/json',
        ...headers,
      });
    if (body != null) request.body = jsonEncode(body);

    final http.Response response;
    try {
      response = await http.Response.fromStream(
        await _client.send(request).timeout(timeout),
      ).timeout(timeout);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException.network();
    }

    if (response.statusCode == 401 && token != null && retry) {
      if (await _refresh()) {
        return _send(
          method,
          path,
          query: query,
          body: body,
          accept: accept,
          retry: false,
          headers: headers,
        );
      }
      await clearSession();
      onSessionExpired?.call();
    }
    return response;
  }

  /// Rotates the refresh token once for concurrent 401s.
  Future<bool> _refresh() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<bool> _doRefresh() async {
    final refreshToken = _tokens?.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return false;
    try {
      final response = await _client
          .post(
            _uri('/auth/refresh', null),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(timeout);
      if (response.statusCode != 200) return false;
      final session = _decode(response);
      if (session is! Json) return false;
      await saveTokens(
        Tokens(
          accessToken: session.str('accessToken'),
          refreshToken: session.str('refreshToken'),
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Object? _decode(http.Response response) {
    if (response.bodyBytes.isEmpty) return null;
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      return null;
    }
  }
}
