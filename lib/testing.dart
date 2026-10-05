/// Test support for the VietGara apps: a fake REST API and the provider
/// overrides that wire an app to it. Import it from tests only.
library;

import 'dart:convert';

import 'package:flutter_riverpod/misc.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/api/json.dart';
import 'src/api/token_store.dart';
import 'src/providers.dart';

export 'src/api/json.dart' show Json;

typedef Handler = Object? Function(http.Request request);

/// A fake VietGara API: handlers keyed by "METHOD /path" (the path after
/// `/api/v1`, without the query). A handler returns a JSON body (200), a
/// [FakeResponse], or throws to simulate a network failure. Unknown routes
/// answer 404 NOT_FOUND.
class FakeApi {
  final handlers = <String, Handler>{};
  final requests = <http.Request>[];

  void on(String route, Handler handler) => handlers[route] = handler;

  /// The requests made to [route] ("METHOD /path").
  List<http.Request> calls(String route) =>
      requests.where((request) => _route(request) == route).toList();

  static String _route(http.Request request) =>
      '${request.method} ${request.url.path.replaceFirst('/api/v1', '')}';

  late final client = MockClient((request) async {
    requests.add(request);
    final handler = handlers[_route(request)];
    if (handler == null) {
      return _json(404, {
        'error': {
          'code': 'NOT_FOUND',
          'message': 'no route ${_route(request)}',
        },
      });
    }
    final result = handler(request);
    if (result is FakeResponse) return _json(result.status, result.body);
    return _json(200, result ?? const {});
  });

  static http.Response _json(int status, Object? body) => http.Response.bytes(
    body == null ? const [] : utf8.encode(jsonEncode(body)),
    status,
    headers: {'content-type': 'application/json'},
  );
}

class FakeResponse {
  const FakeResponse(this.status, [this.body]);

  /// An error answer with [code].
  factory FakeResponse.error(int status, String code) => FakeResponse(status, {
    'error': {'code': code, 'message': code},
  });

  final int status;
  final Object? body;
}

Json decodeBody(http.Request request) =>
    jsonDecode(request.body) as Map<String, dynamic>;

const signedInTokens = Tokens(
  accessToken: 'access-1',
  refreshToken: 'refresh-1',
);

/// Provider overrides wiring the app to [api], [tokens] and in-memory
/// preferences (set up by [setUpPreferences]).
Future<List<Override>> overridesFor(
  FakeApi api, {
  Tokens? tokens,
  Map<String, Object> preferences = const {'vietgara.language': 'en'},
}) async {
  // This library is test support: only tests import it.
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(preferences);
  final prefs = await SharedPreferences.getInstance();
  return [
    sharedPreferencesProvider.overrideWithValue(prefs),
    httpClientProvider.overrideWithValue(api.client),
    tokenStoreProvider.overrideWithValue(MemoryTokenStore(tokens)),
  ];
}
