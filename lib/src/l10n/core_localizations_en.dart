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
  String get accountTitle => 'My account';

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
  String get errorUserSuspended => 'This user is suspended.';

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
  String get errorPhoneTaken => 'This phone number belongs to another user.';

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
      'Enter your e-mail; we will send you a 6-digit code.';

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
  String get loginNoAccount => 'New to VietGara? Sign up';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get notSet => '—';

  @override
  String get registerHaveAccount => 'Already registered? Sign in';

  @override
  String get registerSubmit => 'Sign up';

  @override
  String get registerTitle => 'Register';

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
    return 'We sent a 6-digit code to $email. Enter it below to activate your profile. If you don\'t see it, check your spam or junk folder.';
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

  @override
  String get mfaSectionTitle => 'Two-step verification';

  @override
  String get mfaSectionBody =>
      'Ask for a code from an authenticator app at every sign-in with e-mail and password. Signing in with Google is protected by your Google account.';

  @override
  String get mfaOn => 'On';

  @override
  String get mfaOff => 'Off';

  @override
  String mfaSince(String date) {
    return 'On since $date';
  }

  @override
  String mfaCodesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recovery codes left',
      one: '$count recovery code left',
    );
    return '$_temp0';
  }

  @override
  String get mfaTurnOn => 'Turn on';

  @override
  String get mfaTurnOff => 'Turn off';

  @override
  String get mfaNewCodes => 'New recovery codes';

  @override
  String get mfaSetupTitle => 'Turn on two-step verification';

  @override
  String get mfaSetupBody =>
      'Scan the QR code with an authenticator app, then enter the code it shows.';

  @override
  String get mfaKey => 'Key';

  @override
  String get mfaKeyHint =>
      'Type this key into the app if you cannot scan the code.';

  @override
  String get mfaCode => 'Authentication code';

  @override
  String get mfaCodeFormat => 'Enter the 6-digit code.';

  @override
  String get mfaCodeOrRecovery => 'Authentication code or recovery code';

  @override
  String get mfaConfirm => 'Confirm';

  @override
  String get mfaCodesTitle => 'Your recovery codes';

  @override
  String get mfaCodesBody =>
      'Keep them somewhere safe. If you lose your phone, each code signs you in once. They are shown only now.';

  @override
  String get mfaCopyAll => 'Copy all';

  @override
  String get mfaCodesCopied => 'Recovery codes copied.';

  @override
  String get mfaSaved => 'I saved my recovery codes';

  @override
  String get mfaDone => 'Done';

  @override
  String get mfaRegenerateTitle => 'New recovery codes';

  @override
  String get mfaRegenerateBody =>
      'Enter the current code from the app. The old recovery codes stop working.';

  @override
  String get mfaDisableTitle => 'Turn off two-step verification';

  @override
  String get mfaDisableBody =>
      'Enter the current code from the app, or a recovery code.';

  @override
  String get mfaDisabled => 'Two-step verification is off.';

  @override
  String get mfaChallengeTitle => 'Two-step verification';

  @override
  String get mfaChallengeBody =>
      'Enter the 6-digit code from your authenticator app.';

  @override
  String get mfaChallengeRecoveryBody =>
      'Enter one of your recovery codes. Each code works once.';

  @override
  String get mfaRecoveryCode => 'Recovery code';

  @override
  String get mfaVerify => 'Verify';

  @override
  String get mfaUseApp => 'Use the authenticator app';

  @override
  String get mfaUseRecovery => 'Use a recovery code';

  @override
  String get mfaBack => 'Back to sign in';

  @override
  String get errorMfaCodeInvalid => 'The code is incorrect.';

  @override
  String get errorMfaLocked => 'Too many wrong codes. Try again in 15 minutes.';

  @override
  String get errorMfaChallengeInvalid =>
      'The sign-in expired. Go back and sign in again.';

  @override
  String get errorMfaAlreadyEnabled => 'Two-step verification is already on.';

  @override
  String get errorMfaNotEnabled => 'Two-step verification is not on.';

  @override
  String get errorMfaEnrollmentNotStarted =>
      'Start turning on two-step verification first.';

  @override
  String get errorMfaNotAvailable =>
      'Two-step verification needs an e-mail and password sign-in; Google sign-in is protected by your Google account.';

  @override
  String get errorMfaNotConfigured =>
      'Two-step verification is not available on this server.';

  @override
  String get googleSectionTitle => 'Google account';

  @override
  String get googleSectionBody =>
      'Link your Google account to sign in with one tap. Your password stays as a second way in.';

  @override
  String get googleLinked => 'Linked';

  @override
  String get googleNotLinked => 'Not linked';

  @override
  String get googleLink => 'Link Google account';

  @override
  String get googleUnlink => 'Unlink Google account';

  @override
  String get googleNoPassword =>
      'You sign in with Google only. Set a password first to change this.';

  @override
  String get googleNotConfigured => 'Google sign-in is not set up in this app.';

  @override
  String get googleFailed => 'Google sign-in failed. Try again.';

  @override
  String get googleLinkTitle => 'Link a Google account';

  @override
  String get googleLinkBody =>
      'Enter your password, then choose the Google account.';

  @override
  String get googleLinkedDone => 'Google account linked.';

  @override
  String get googleUnlinkTitle => 'Unlink your Google account';

  @override
  String get googleUnlinkBody =>
      'Enter your password. You stay signed in here and are signed out everywhere else.';

  @override
  String get googleUnlinkedDone => 'Google account unlinked.';

  @override
  String get errorPasswordIncorrect => 'The password is incorrect.';

  @override
  String get errorNoPassword => 'Set a password first.';

  @override
  String get errorGoogleAlreadyLinked =>
      'This Google account is linked to another user.';

  @override
  String get errorGoogleLinkExists =>
      'A Google account is already linked. Unlink it first.';

  @override
  String get errorGoogleNotLinked => 'No Google account is linked.';

  @override
  String get errorGoogleSigninBlocked =>
      'Google sign-in is off for this account. Link a Google account in your security settings.';
}
