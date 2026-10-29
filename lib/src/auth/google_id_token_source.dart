import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Build-time Google Sign-In configuration, set with `--dart-define`.
abstract final class GoogleConfig {
  /// The OAuth client ID of the backend ("Web application" type). Google
  /// issues the ID token to this audience on both platforms; it must be in
  /// the backend's `GOOGLE_MOBILE_CLIENT_IDS`.
  static const serverClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  /// The iOS OAuth client ID (iOS only; Android finds its client by the
  /// package name and signing certificate).
  static const iosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
}

/// Why Google sign-in did not produce an ID token.
enum GoogleSignInFailure {
  /// This build has no Google client IDs (see [GoogleConfig]).
  notConfigured,

  /// Google Sign-In failed (misconfiguration, no Play services, ...).
  failed,
}

class GoogleSignInError implements Exception {
  const GoogleSignInError(this.failure, [this.detail = '']);

  final GoogleSignInFailure failure;
  final String detail;

  @override
  String toString() => 'GoogleSignInError($failure, $detail)';
}

/// Obtains a Google ID token natively, for the backend to verify
/// (`POST /api/v1/auth/google/id-token`, or `POST /api/v1/me/google-link`
/// to link the account to the signed-in user).
abstract interface class GoogleIdTokenSource {
  /// Whether this build has the Google client IDs it needs (see
  /// [GoogleConfig]); apps without them show Google as unavailable.
  bool get configured;

  /// The ID token of the account the person picked; null when they
  /// canceled. Throws [GoogleSignInError].
  Future<String?> signIn();

  /// Forgets the picked account, so the next sign-in shows the chooser.
  Future<void> signOut();
}

/// [GoogleIdTokenSource] on the google_sign_in plugin.
class PluginGoogleIdTokenSource implements GoogleIdTokenSource {
  PluginGoogleIdTokenSource({
    this.serverClientId = GoogleConfig.serverClientId,
    this.iosClientId = GoogleConfig.iosClientId,
  });

  final String serverClientId;
  final String iosClientId;
  Future<void>? _initialized;

  @override
  bool get configured => serverClientId.isNotEmpty;

  GoogleSignIn get _plugin => GoogleSignIn.instance;

  Future<void> _initialize() => _initialized ??= _plugin.initialize(
    clientId: iosClientId.isEmpty ? null : iosClientId,
    serverClientId: serverClientId,
  );

  @override
  Future<String?> signIn() async {
    if (!configured) {
      throw const GoogleSignInError(GoogleSignInFailure.notConfigured);
    }
    try {
      await _initialize();
      final account = await _plugin.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const GoogleSignInError(
          GoogleSignInFailure.failed,
          'no id token',
        );
      }
      return idToken;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      throw GoogleSignInError(
        GoogleSignInFailure.failed,
        '${error.code}: ${error.description}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    if (_initialized == null) return;
    await _plugin.signOut();
  }
}

final googleIdTokenSourceProvider = Provider<GoogleIdTokenSource>(
  (ref) => PluginGoogleIdTokenSource(),
);
