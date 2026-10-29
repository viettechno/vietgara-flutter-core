import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/json.dart';
import '../providers.dart';
import 'user.dart';

/// Identity endpoints (FR-IAM-01..05).
class AuthRepository {
  const AuthRepository(this._api);

  final ApiClient _api;

  /// Signs in with e-mail and password: the session, or [MfaRequired] when
  /// the user has two-step verification on.
  Future<SignInResult> login(String email, String password) async =>
      SignInResult.fromJson(
        await _api.postPublic('/auth/login', {
          'email': email,
          'password': password,
        }),
      );

  /// Completes a sign-in that answered [MfaRequired] with a TOTP code or a
  /// recovery code (FR-IAM-09).
  Future<Session> verifyMfaChallenge(
    String challengeToken,
    String code,
  ) async => Session.fromJson(
    await _api.postPublic('/auth/mfa/challenge', {
      'challengeToken': challengeToken,
      'code': code,
    }),
  );

  Future<Session> register({
    required String email,
    required String password,
    required String fullName,
    String phone = '',
    AppLanguage language = AppLanguage.vi,
  }) async => Session.fromJson(
    await _api.postPublic('/auth/register', {
      'email': email,
      'password': password,
      'fullName': fullName,
      if (phone.isNotEmpty) 'phone': phone,
      'locale': language.wire,
    }),
  );

  Future<void> logout(String refreshToken) =>
      _api.postPublic('/auth/logout', {'refreshToken': refreshToken});

  Future<OtpChallenge> sendVerification() async =>
      OtpChallenge.fromJson(await _api.post('/auth/email-verification/otp'));

  /// Verifies the e-mail; the session is rotated so the new one carries the
  /// verified claim.
  Future<Session> verifyEmail(String otpCode, String refreshToken) async =>
      Session.fromJson(
        await _api.post('/auth/email-verification', {
          'otpCode': otpCode,
          'refreshToken': refreshToken,
        }),
      );

  Future<OtpChallenge> requestPasswordReset(String email) async =>
      OtpChallenge.fromJson(
        await _api.postPublic('/auth/password-reset/otp', {'email': email}),
      );

  /// Exchanges the OTP for a short-lived reset token.
  Future<String> verifyPasswordReset(String email, String otpCode) async =>
      (await _api.postPublic('/auth/password-reset/otp/verification', {
            'email': email,
            'otpCode': otpCode,
          }))['resetToken']
          as String? ??
      '';

  Future<void> resetPassword(String resetToken, String newPassword) =>
      _api.postPublic('/auth/password-reset', {
        'resetToken': resetToken,
        'newPassword': newPassword,
      });

  Future<User> me() async => User.fromJson(await _api.get('/me'));

  Future<User> updateMe({
    String? fullName,
    String? phone,
    AppLanguage? language,
  }) async => User.fromJson(
    await _api.patch('/me', {
      'fullName': ?fullName,
      'phone': ?phone,
      'locale': ?language?.wire,
    }),
  );
}

/// The signed-in user's own second factor (FR-IAM-09): a TOTP authenticator
/// app and one-time recovery codes. MFA is optional and never enforced.
class MfaRepository {
  const MfaRepository(this._api);

  final ApiClient _api;

  Future<MfaStatus> status() async =>
      MfaStatus.fromJson(await _api.get('/me/mfa'));

  /// Starts an enrolment; MFA is on only once [confirm] succeeds.
  Future<MfaEnrollment> enroll() async =>
      MfaEnrollment.fromJson(await _api.post('/me/mfa/enroll'));

  /// Turns MFA on with a code from the app; returns the recovery codes,
  /// shown only once.
  Future<List<String>> confirm(String code) async => (await _api.post(
    '/me/mfa/enroll:confirm',
    {'code': code},
  )).strings('recoveryCodes');

  /// Replaces the recovery codes; needs a current TOTP code.
  Future<List<String>> regenerateRecoveryCodes(String code) async =>
      (await _api.post('/me/mfa/recovery-codes', {
        'code': code,
      })).strings('recoveryCodes');

  /// Turns MFA off; needs a TOTP code or a recovery code.
  Future<void> disable(String code) =>
      _api.post('/me/mfa:disable', {'code': code});
}

/// Linking a Google account to the signed-in user (FR-IAM-06). The password
/// confirms both calls.
class GoogleLinkRepository {
  const GoogleLinkRepository(this._api);

  final ApiClient _api;

  /// Links the Google account of [idToken]; answers the updated user.
  Future<User> link(String idToken, String password) async => User.fromJson(
    await _api.post('/me/google-link', {
      'idToken': idToken,
      'password': password,
    }),
  );

  /// Unlinks Google. Every other session is revoked, so the answer is the
  /// new session to continue with.
  Future<Session> unlink(String password) async => Session.fromJson(
    await _api.post('/me/google-link:unlink', {'password': password}),
  );
}

final googleLinkRepositoryProvider = Provider<GoogleLinkRepository>(
  (ref) => GoogleLinkRepository(ref.watch(apiClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiClientProvider)),
);

final mfaRepositoryProvider = Provider<MfaRepository>(
  (ref) => MfaRepository(ref.watch(apiClientProvider)),
);

/// The user's two-step verification status; refresh with `ref.invalidate`.
final mfaStatusProvider = FutureProvider.autoDispose<MfaStatus>(
  (ref) => ref.watch(mfaRepositoryProvider).status(),
);
