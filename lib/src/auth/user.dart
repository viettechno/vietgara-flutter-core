import '../api/json.dart';
import '../api/token_store.dart';

/// The UI language of a user (`LOCALE_VI` / `LOCALE_EN`).
enum AppLanguage {
  vi('LOCALE_VI'),
  en('LOCALE_EN');

  const AppLanguage(this.wire);

  final String wire;

  static AppLanguage fromWire(String? value) =>
      value == en.wire ? en : AppLanguage.vi;

  static AppLanguage fromCode(String? code) => code == 'en' ? en : vi;
}

/// A person who signs in to VietGara (v1.User).
class User {
  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone = '',
    this.emailVerified = false,
    this.language = AppLanguage.vi,
    this.platformAdmin = false,
    this.mfaEnabled = false,
  });

  factory User.fromJson(Json json) => User(
    id: json.str('id'),
    email: json.str('email'),
    fullName: json.str('fullName'),
    phone: json.str('phone'),
    emailVerified: json.flag('emailVerified'),
    language: AppLanguage.fromWire(json.strOrNull('locale')),
    platformAdmin: json.flag('platformAdmin'),
    mfaEnabled: json.flag('mfaEnabled'),
  );

  final String id;
  final String email;
  final String fullName;
  final String phone;
  final bool emailVerified;
  final AppLanguage language;

  /// Listed as a VietGara platform administrator; the only users this
  /// app serves (FR-AAPP-01).
  final bool platformAdmin;

  /// The user turned on two-step verification (FR-IAM-09).
  final bool mfaEnabled;

  User copyWith({bool? mfaEnabled}) => User(
    id: id,
    email: email,
    fullName: fullName,
    phone: phone,
    emailVerified: emailVerified,
    language: language,
    platformAdmin: platformAdmin,
    mfaEnabled: mfaEnabled ?? this.mfaEnabled,
  );

  @override
  bool operator ==(Object other) =>
      other is User &&
      other.id == id &&
      other.email == email &&
      other.fullName == fullName &&
      other.phone == phone &&
      other.emailVerified == emailVerified &&
      other.language == language &&
      other.platformAdmin == platformAdmin &&
      other.mfaEnabled == mfaEnabled;

  @override
  int get hashCode => Object.hash(
    id,
    email,
    fullName,
    phone,
    emailVerified,
    language,
    platformAdmin,
    mfaEnabled,
  );
}

/// A signed-in session (v1.Session).
class Session {
  const Session({required this.tokens, required this.user});

  factory Session.fromJson(Json json) => Session(
    tokens: Tokens(
      accessToken: json.str('accessToken'),
      refreshToken: json.str('refreshToken'),
    ),
    user: User.fromJson(json.obj('user')),
  );

  final Tokens tokens;
  final User user;
}

/// When a sent OTP expires and when another may be requested.
class OtpChallenge {
  const OtpChallenge({this.expiresAt, this.resendAvailableAt});

  factory OtpChallenge.fromJson(Json json) => OtpChallenge(
    expiresAt: json.time('expiresAt'),
    resendAvailableAt: json.time('resendAvailableAt'),
  );

  final DateTime? expiresAt;
  final DateTime? resendAvailableAt;
}

/// A sign-in waiting for the second factor (FR-IAM-09): the password was
/// right and the user has MFA on, so the API answers a single-use token
/// instead of the session.
class MfaChallenge {
  const MfaChallenge({required this.token, this.expiresAt});

  factory MfaChallenge.fromJson(Json json) => MfaChallenge(
    token: json.str('challengeToken'),
    expiresAt: json.time('challengeExpiresAt'),
  );

  final String token;
  final DateTime? expiresAt;
}

/// What a password sign-in answers: the session, or a challenge when the
/// user has MFA on.
sealed class SignInResult {
  const SignInResult();

  factory SignInResult.fromJson(Json json) => json.flag('mfaRequired')
      ? MfaRequired(MfaChallenge.fromJson(json))
      : SignedIn(Session.fromJson(json));
}

class SignedIn extends SignInResult {
  const SignedIn(this.session);

  final Session session;
}

class MfaRequired extends SignInResult {
  const MfaRequired(this.challenge);

  final MfaChallenge challenge;
}

/// Whether the user's second factor is on (v1.GetMfaStatusResponse).
class MfaStatus {
  const MfaStatus({
    this.enabled = false,
    this.enabledAt,
    this.recoveryCodesRemaining = 0,
  });

  factory MfaStatus.fromJson(Json json) => MfaStatus(
    enabled: json.flag('enabled'),
    enabledAt: json.time('enabledAt'),
    recoveryCodesRemaining: json.int32('recoveryCodesRemaining'),
  );

  final bool enabled;
  final DateTime? enabledAt;
  final int recoveryCodesRemaining;
}

/// A new secret to add to an authenticator app (v1.EnrollMfaResponse).
class MfaEnrollment {
  const MfaEnrollment({required this.secret, required this.otpauthUri});

  factory MfaEnrollment.fromJson(Json json) => MfaEnrollment(
    secret: json.str('secret'),
    otpauthUri: json.str('otpauthUri'),
  );

  /// Base32, for typing into the app.
  final String secret;

  /// The `otpauth://` URI the app reads from a QR code.
  final String otpauthUri;
}
