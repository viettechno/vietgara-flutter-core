import '../api/json.dart';
import '../api/token_store.dart';

/// The UI language of an account (`LOCALE_VI` / `LOCALE_EN`).
enum AppLanguage {
  vi('LOCALE_VI'),
  en('LOCALE_EN');

  const AppLanguage(this.wire);

  final String wire;

  static AppLanguage fromWire(String? value) =>
      value == en.wire ? en : AppLanguage.vi;

  static AppLanguage fromCode(String? code) => code == 'en' ? en : vi;
}

/// A login account (v1.Account).
class Account {
  const Account({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone = '',
    this.emailVerified = false,
    this.language = AppLanguage.vi,
    this.platformAdmin = false,
  });

  factory Account.fromJson(Json json) => Account(
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

  /// Listed as a VietGara platform administrator; the only accounts this
  /// app serves (FR-AAPP-01).
  final bool platformAdmin;

  @override
  bool operator ==(Object other) =>
      other is Account &&
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
  const Session({required this.tokens, required this.account});

  factory Session.fromJson(Json json) => Session(
    tokens: Tokens(
      accessToken: json.str('accessToken'),
      refreshToken: json.str('refreshToken'),
    ),
    account: Account.fromJson(json.obj('account')),
  );

  final Tokens tokens;
  final Account account;
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
