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
  });

  factory User.fromJson(Json json) => User(
    id: json.str('id'),
    email: json.str('email'),
    fullName: json.str('fullName'),
    phone: json.str('phone'),
    emailVerified: json.flag('emailVerified'),
    language: AppLanguage.fromWire(json.strOrNull('locale')),
    platformAdmin: json.flag('platformAdmin'),
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

  @override
  bool operator ==(Object other) =>
      other is User &&
      other.id == id &&
      other.email == email &&
      other.fullName == fullName &&
      other.phone == phone &&
      other.emailVerified == emailVerified &&
      other.language == language &&
      other.platformAdmin == platformAdmin;

  @override
  int get hashCode => Object.hash(
    id,
    email,
    fullName,
    phone,
    emailVerified,
    language,
    platformAdmin,
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
