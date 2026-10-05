import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../providers.dart';
import 'account.dart';

/// Identity endpoints (FR-IAM-01..05).
class AuthRepository {
  const AuthRepository(this._api);

  final ApiClient _api;

  Future<Session> login(String email, String password) async =>
      Session.fromJson(
        await _api.postPublic('/auth/login', {
          'email': email,
          'password': password,
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

  Future<Account> me() async => Account.fromJson(await _api.get('/me'));

  Future<Account> updateMe({
    String? fullName,
    String? phone,
    AppLanguage? language,
  }) async => Account.fromJson(
    await _api.patch('/me', {
      'fullName': ?fullName,
      'phone': ?phone,
      'locale': ?language?.wire,
    }),
  );
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(apiClientProvider)),
);
