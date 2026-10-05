import 'l10n/core_localizations.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
final _otpPattern = RegExp(r'^\d{6}$');

/// Form field validators returning the localized issue, or null when valid.
class Validators {
  const Validators(this.l10n);

  final CoreLocalizations l10n;

  String? required(String? value) =>
      (value ?? '').trim().isEmpty ? l10n.validationRequired : null;

  String? email(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return l10n.validationRequired;
    return _emailPattern.hasMatch(text) ? null : l10n.validationEmail;
  }

  /// At least 8 characters (FR-IAM-01).
  String? password(String? value) =>
      (value ?? '').length < 8 ? l10n.validationPassword : null;

  String? otp(String? value) =>
      _otpPattern.hasMatch((value ?? '').trim()) ? null : l10n.validationOtp;
}
