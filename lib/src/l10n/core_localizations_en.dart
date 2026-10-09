// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'core_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class CoreLocalizationsEn extends CoreLocalizations {
  CoreLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get accountSaved => 'Saved.';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountUnverified => 'E-mail not verified';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionSave => 'Save';

  @override
  String get appTitle => 'VietGara';

  @override
  String get errorAccountSuspended => 'This account is suspended.';

  @override
  String get errorAlreadyExists => 'This already exists.';

  @override
  String get errorBadRequest => 'The request is invalid.';

  @override
  String get errorEmailAlreadyVerified => 'Your e-mail is already verified.';

  @override
  String get errorEmailNotVerified => 'Please verify your e-mail first.';

  @override
  String get errorEmailTaken => 'This e-mail is already registered.';

  @override
  String get errorFailedPrecondition => 'This cannot be done right now.';

  @override
  String get errorGarageAccessDenied => 'You have no access to this garage.';

  @override
  String get errorGarageInactive => 'This garage is inactive.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorIdempotencyKeyReused =>
      'This was already submitted with different details. Check the record before trying again.';

  @override
  String get errorInternal =>
      'The service is having trouble. Please try again later.';

  @override
  String get errorInvalidCredentials => 'Wrong e-mail or password.';

  @override
  String get errorInvitationExpired => 'The invitation expired.';

  @override
  String get errorInvitationNotPending =>
      'The invitation was already answered or revoked.';

  @override
  String get errorNetwork => 'Cannot reach VietGara. Check your connection.';

  @override
  String get errorNotFound => 'Not found.';

  @override
  String get errorOtpExpired => 'The code expired. Request a new one.';

  @override
  String get errorOtpInvalid => 'Wrong code.';

  @override
  String get errorOtpResendTooSoon =>
      'Please wait before requesting another code.';

  @override
  String get errorOtpTooManyAttempts =>
      'Too many wrong codes. Request a new one.';

  @override
  String get errorOwnerOnly => 'Only the garage owner can do this.';

  @override
  String get errorPermissionDenied => 'You are not allowed to do this.';

  @override
  String get errorPhoneTaken => 'This phone number belongs to another account.';

  @override
  String get errorPlanCodeTaken => 'A plan with this code already exists.';

  @override
  String get errorPlanLimitReached =>
      'Your plan limit is reached. Upgrade to add more.';

  @override
  String get errorPlanNotAvailable => 'This plan cannot be chosen.';

  @override
  String get errorRateLimited => 'Too many attempts. Please wait a moment.';

  @override
  String get errorRefreshTokenInvalid => 'Your session expired.';

  @override
  String get errorResetTokenInvalid =>
      'The reset session expired. Start again.';

  @override
  String get errorSubscriptionReadOnly =>
      'The subscription is past due: read-only mode.';

  @override
  String get errorSubscriptionSuspended =>
      'The subscription is suspended. Please renew.';

  @override
  String get errorUnauthenticated =>
      'Your session expired. Please sign in again.';

  @override
  String get errorValidation => 'Please check the highlighted information.';

  @override
  String get fieldEmail => 'E-mail';

  @override
  String get fieldFullName => 'Full name';

  @override
  String get fieldNewPassword => 'New password';

  @override
  String get fieldOtp => '6-digit code';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldPhoneOptional => 'Phone (optional)';

  @override
  String forgotCodeBody(String email) {
    return 'Enter the code sent to $email. If you don\'t see the e-mail, check your spam or junk folder.';
  }

  @override
  String get forgotDone =>
      'Your password was changed. Sign in with the new one.';

  @override
  String get forgotEmailBody =>
      'Enter your account\'s e-mail; we will send you a 6-digit code.';

  @override
  String get forgotPasswordBody => 'Choose a new password.';

  @override
  String get forgotSendCode => 'Send code';

  @override
  String get forgotTitle => 'Reset your password';

  @override
  String get language => 'Language';

  @override
  String get loginForgot => 'Forgot password?';

  @override
  String get loginGoogleHint =>
      'Signed up with Google? Set a password with “Forgot password?” to sign in on the app.';

  @override
  String get loginNoAccount => 'No account yet? Sign up';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get notSet => '—';

  @override
  String get registerHaveAccount => 'Already have an account? Sign in';

  @override
  String get registerSubmit => 'Sign up';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutConfirm => 'Sign out on this device?';

  @override
  String get splashError => 'Cannot reach VietGara. Check your connection.';

  @override
  String get validationEmail => 'Enter a valid e-mail.';

  @override
  String get validationOtp => 'Enter the 6-digit code.';

  @override
  String get validationPassword => 'At least 8 characters.';

  @override
  String get validationRequired => 'Required.';

  @override
  String verifyBody(String email) {
    return 'We sent a 6-digit code to $email. Enter it below to activate your account. If you don\'t see it, check your spam or junk folder.';
  }

  @override
  String get verifyResend => 'Send a new code';

  @override
  String verifyResendIn(int seconds) {
    return 'Send a new code in ${seconds}s';
  }

  @override
  String get verifySent => 'A new code is on its way.';

  @override
  String get verifySubmit => 'Verify';

  @override
  String get verifyTitle => 'Verify your e-mail';

  @override
  String get verifyWrongAccount => 'Not you? Sign out';

  @override
  String get invitationsTitle => 'Invitations';

  @override
  String get invitationsEmpty => 'No pending invitation.';

  @override
  String invitationFrom(String name) {
    return 'Invited by $name';
  }

  @override
  String invitationExpires(String date) {
    return 'Expires $date';
  }

  @override
  String get invitationAccept => 'Accept';

  @override
  String get invitationDecline => 'Decline';

  @override
  String invitationAccepted(String garage) {
    return 'You joined $garage.';
  }
}
