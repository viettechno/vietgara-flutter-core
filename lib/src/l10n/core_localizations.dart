import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'core_localizations_en.dart';
import 'core_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of CoreLocalizations
/// returned by `CoreLocalizations.of(context)`.
///
/// Applications need to include `CoreLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/core_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: CoreLocalizations.localizationsDelegates,
///   supportedLocales: CoreLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the CoreLocalizations.supportedLocales
/// property.
abstract class CoreLocalizations {
  CoreLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static CoreLocalizations of(BuildContext context) {
    return Localizations.of<CoreLocalizations>(context, CoreLocalizations)!;
  }

  static const LocalizationsDelegate<CoreLocalizations> delegate =
      _CoreLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @accountSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get accountSaved;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get accountTitle;

  /// No description provided for @accountUnverified.
  ///
  /// In en, this message translates to:
  /// **'E-mail not verified'**
  String get accountUnverified;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'VietGara'**
  String get appTitle;

  /// No description provided for @errorUserSuspended.
  ///
  /// In en, this message translates to:
  /// **'This user is suspended.'**
  String get errorUserSuspended;

  /// No description provided for @errorAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This already exists.'**
  String get errorAlreadyExists;

  /// No description provided for @errorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'The request is invalid.'**
  String get errorBadRequest;

  /// No description provided for @errorEmailAlreadyVerified.
  ///
  /// In en, this message translates to:
  /// **'Your e-mail is already verified.'**
  String get errorEmailAlreadyVerified;

  /// No description provided for @errorEmailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Please verify your e-mail first.'**
  String get errorEmailNotVerified;

  /// No description provided for @errorEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'This e-mail is already registered.'**
  String get errorEmailTaken;

  /// No description provided for @errorFailedPrecondition.
  ///
  /// In en, this message translates to:
  /// **'This cannot be done right now.'**
  String get errorFailedPrecondition;

  /// No description provided for @errorGarageAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'You have no access to this garage.'**
  String get errorGarageAccessDenied;

  /// No description provided for @errorGarageInactive.
  ///
  /// In en, this message translates to:
  /// **'This garage is inactive.'**
  String get errorGarageInactive;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorIdempotencyKeyReused.
  ///
  /// In en, this message translates to:
  /// **'This was already submitted with different details. Check the record before trying again.'**
  String get errorIdempotencyKeyReused;

  /// No description provided for @errorInternal.
  ///
  /// In en, this message translates to:
  /// **'The service is having trouble. Please try again later.'**
  String get errorInternal;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong e-mail or password.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorInvitationExpired.
  ///
  /// In en, this message translates to:
  /// **'The invitation expired.'**
  String get errorInvitationExpired;

  /// No description provided for @errorInvitationNotPending.
  ///
  /// In en, this message translates to:
  /// **'The invitation was already answered or revoked.'**
  String get errorInvitationNotPending;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach VietGara. Check your connection.'**
  String get errorNetwork;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found.'**
  String get errorNotFound;

  /// No description provided for @errorOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'The code expired. Request a new one.'**
  String get errorOtpExpired;

  /// No description provided for @errorOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'Wrong code.'**
  String get errorOtpInvalid;

  /// No description provided for @errorOtpResendTooSoon.
  ///
  /// In en, this message translates to:
  /// **'Please wait before requesting another code.'**
  String get errorOtpResendTooSoon;

  /// No description provided for @errorOtpTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong codes. Request a new one.'**
  String get errorOtpTooManyAttempts;

  /// No description provided for @errorOwnerOnly.
  ///
  /// In en, this message translates to:
  /// **'Only the garage owner can do this.'**
  String get errorOwnerOnly;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to do this.'**
  String get errorPermissionDenied;

  /// No description provided for @errorPhoneTaken.
  ///
  /// In en, this message translates to:
  /// **'This phone number belongs to another user.'**
  String get errorPhoneTaken;

  /// No description provided for @errorPlanCodeTaken.
  ///
  /// In en, this message translates to:
  /// **'A plan with this code already exists.'**
  String get errorPlanCodeTaken;

  /// No description provided for @errorPlanLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Your plan limit is reached. Upgrade to add more.'**
  String get errorPlanLimitReached;

  /// No description provided for @errorPlanNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This plan cannot be chosen.'**
  String get errorPlanNotAvailable;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment.'**
  String get errorRateLimited;

  /// No description provided for @errorRefreshTokenInvalid.
  ///
  /// In en, this message translates to:
  /// **'Your session expired.'**
  String get errorRefreshTokenInvalid;

  /// No description provided for @errorResetTokenInvalid.
  ///
  /// In en, this message translates to:
  /// **'The reset session expired. Start again.'**
  String get errorResetTokenInvalid;

  /// No description provided for @errorSubscriptionReadOnly.
  ///
  /// In en, this message translates to:
  /// **'The subscription is past due: read-only mode.'**
  String get errorSubscriptionReadOnly;

  /// No description provided for @errorSubscriptionSuspended.
  ///
  /// In en, this message translates to:
  /// **'The subscription is suspended. Please renew.'**
  String get errorSubscriptionSuspended;

  /// No description provided for @errorUnauthenticated.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please sign in again.'**
  String get errorUnauthenticated;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please check the highlighted information.'**
  String get errorValidation;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get fieldEmail;

  /// No description provided for @fieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fieldFullName;

  /// No description provided for @fieldNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get fieldNewPassword;

  /// No description provided for @fieldOtp.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get fieldOtp;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get fieldPhone;

  /// No description provided for @fieldPhoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get fieldPhoneOptional;

  /// No description provided for @forgotCodeBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to {email}. If you don\'t see the e-mail, check your spam or junk folder.'**
  String forgotCodeBody(String email);

  /// No description provided for @forgotDone.
  ///
  /// In en, this message translates to:
  /// **'Your password was changed. Sign in with the new one.'**
  String get forgotDone;

  /// No description provided for @forgotEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your e-mail; we will send you a 6-digit code.'**
  String get forgotEmailBody;

  /// No description provided for @forgotPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password.'**
  String get forgotPasswordBody;

  /// No description provided for @forgotSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get forgotSendCode;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @loginForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgot;

  /// No description provided for @loginGoogleHint.
  ///
  /// In en, this message translates to:
  /// **'Signed up with Google? Set a password with “Forgot password?” to sign in on the app.'**
  String get loginGoogleHint;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'New to VietGara? Sign up'**
  String get loginNoAccount;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get notSet;

  /// No description provided for @registerHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already registered? Sign in'**
  String get registerHaveAccount;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get registerSubmit;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out on this device?'**
  String get signOutConfirm;

  /// No description provided for @splashError.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach VietGara. Check your connection.'**
  String get splashError;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid e-mail.'**
  String get validationEmail;

  /// No description provided for @validationOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code.'**
  String get validationOtp;

  /// No description provided for @validationPassword.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters.'**
  String get validationPassword;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Required.'**
  String get validationRequired;

  /// No description provided for @verifyBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}. Enter it below to activate your profile. If you don\'t see it, check your spam or junk folder.'**
  String verifyBody(String email);

  /// No description provided for @verifyResend.
  ///
  /// In en, this message translates to:
  /// **'Send a new code'**
  String get verifyResend;

  /// No description provided for @verifyResendIn.
  ///
  /// In en, this message translates to:
  /// **'Send a new code in {seconds}s'**
  String verifyResendIn(int seconds);

  /// No description provided for @verifySent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way.'**
  String get verifySent;

  /// No description provided for @verifySubmit.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifySubmit;

  /// No description provided for @verifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your e-mail'**
  String get verifyTitle;

  /// No description provided for @verifyWrongAccount.
  ///
  /// In en, this message translates to:
  /// **'Not you? Sign out'**
  String get verifyWrongAccount;

  /// No description provided for @invitationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get invitationsTitle;

  /// No description provided for @invitationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No pending invitation.'**
  String get invitationsEmpty;

  /// No description provided for @invitationFrom.
  ///
  /// In en, this message translates to:
  /// **'Invited by {name}'**
  String invitationFrom(String name);

  /// No description provided for @invitationExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String invitationExpires(String date);

  /// No description provided for @invitationAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get invitationAccept;

  /// No description provided for @invitationDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get invitationDecline;

  /// No description provided for @invitationAccepted.
  ///
  /// In en, this message translates to:
  /// **'You joined {garage}.'**
  String invitationAccepted(String garage);

  /// No description provided for @mfaSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification'**
  String get mfaSectionTitle;

  /// No description provided for @mfaSectionBody.
  ///
  /// In en, this message translates to:
  /// **'Ask for a code from an authenticator app at every sign-in with e-mail and password. Signing in with Google is protected by your Google account.'**
  String get mfaSectionBody;

  /// No description provided for @mfaOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get mfaOn;

  /// No description provided for @mfaOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get mfaOff;

  /// No description provided for @mfaSince.
  ///
  /// In en, this message translates to:
  /// **'On since {date}'**
  String mfaSince(String date);

  /// No description provided for @mfaCodesLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} recovery code left} other{{count} recovery codes left}}'**
  String mfaCodesLeft(int count);

  /// No description provided for @mfaTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get mfaTurnOn;

  /// No description provided for @mfaTurnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get mfaTurnOff;

  /// No description provided for @mfaNewCodes.
  ///
  /// In en, this message translates to:
  /// **'New recovery codes'**
  String get mfaNewCodes;

  /// No description provided for @mfaSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn on two-step verification'**
  String get mfaSetupTitle;

  /// No description provided for @mfaSetupBody.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code with an authenticator app, then enter the code it shows.'**
  String get mfaSetupBody;

  /// No description provided for @mfaKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get mfaKey;

  /// No description provided for @mfaKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Type this key into the app if you cannot scan the code.'**
  String get mfaKeyHint;

  /// No description provided for @mfaCode.
  ///
  /// In en, this message translates to:
  /// **'Authentication code'**
  String get mfaCode;

  /// No description provided for @mfaCodeFormat.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code.'**
  String get mfaCodeFormat;

  /// No description provided for @mfaCodeOrRecovery.
  ///
  /// In en, this message translates to:
  /// **'Authentication code or recovery code'**
  String get mfaCodeOrRecovery;

  /// No description provided for @mfaConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get mfaConfirm;

  /// No description provided for @mfaCodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your recovery codes'**
  String get mfaCodesTitle;

  /// No description provided for @mfaCodesBody.
  ///
  /// In en, this message translates to:
  /// **'Keep them somewhere safe. If you lose your phone, each code signs you in once. They are shown only now.'**
  String get mfaCodesBody;

  /// No description provided for @mfaCopyAll.
  ///
  /// In en, this message translates to:
  /// **'Copy all'**
  String get mfaCopyAll;

  /// No description provided for @mfaCodesCopied.
  ///
  /// In en, this message translates to:
  /// **'Recovery codes copied.'**
  String get mfaCodesCopied;

  /// No description provided for @mfaSaved.
  ///
  /// In en, this message translates to:
  /// **'I saved my recovery codes'**
  String get mfaSaved;

  /// No description provided for @mfaDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get mfaDone;

  /// No description provided for @mfaRegenerateTitle.
  ///
  /// In en, this message translates to:
  /// **'New recovery codes'**
  String get mfaRegenerateTitle;

  /// No description provided for @mfaRegenerateBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the current code from the app. The old recovery codes stop working.'**
  String get mfaRegenerateBody;

  /// No description provided for @mfaDisableTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off two-step verification'**
  String get mfaDisableTitle;

  /// No description provided for @mfaDisableBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the current code from the app, or a recovery code.'**
  String get mfaDisableBody;

  /// No description provided for @mfaDisabled.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification is off.'**
  String get mfaDisabled;

  /// No description provided for @mfaChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification'**
  String get mfaChallengeTitle;

  /// No description provided for @mfaChallengeBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app.'**
  String get mfaChallengeBody;

  /// No description provided for @mfaChallengeRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'Enter one of your recovery codes. Each code works once.'**
  String get mfaChallengeRecoveryBody;

  /// No description provided for @mfaRecoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get mfaRecoveryCode;

  /// No description provided for @mfaVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get mfaVerify;

  /// No description provided for @mfaUseApp.
  ///
  /// In en, this message translates to:
  /// **'Use the authenticator app'**
  String get mfaUseApp;

  /// No description provided for @mfaUseRecovery.
  ///
  /// In en, this message translates to:
  /// **'Use a recovery code'**
  String get mfaUseRecovery;

  /// No description provided for @mfaBack.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get mfaBack;

  /// No description provided for @errorMfaCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'The code is incorrect.'**
  String get errorMfaCodeInvalid;

  /// No description provided for @errorMfaLocked.
  ///
  /// In en, this message translates to:
  /// **'Too many wrong codes. Try again in 15 minutes.'**
  String get errorMfaLocked;

  /// No description provided for @errorMfaChallengeInvalid.
  ///
  /// In en, this message translates to:
  /// **'The sign-in expired. Go back and sign in again.'**
  String get errorMfaChallengeInvalid;

  /// No description provided for @errorMfaAlreadyEnabled.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification is already on.'**
  String get errorMfaAlreadyEnabled;

  /// No description provided for @errorMfaNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification is not on.'**
  String get errorMfaNotEnabled;

  /// No description provided for @errorMfaEnrollmentNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Start turning on two-step verification first.'**
  String get errorMfaEnrollmentNotStarted;

  /// No description provided for @errorMfaNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification needs an e-mail and password sign-in; Google sign-in is protected by your Google account.'**
  String get errorMfaNotAvailable;

  /// No description provided for @errorMfaNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification is not available on this server.'**
  String get errorMfaNotConfigured;

  /// No description provided for @googleSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Google account'**
  String get googleSectionTitle;

  /// No description provided for @googleSectionBody.
  ///
  /// In en, this message translates to:
  /// **'Link your Google account to sign in with one tap. Your password stays as a second way in.'**
  String get googleSectionBody;

  /// No description provided for @googleLinked.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get googleLinked;

  /// No description provided for @googleNotLinked.
  ///
  /// In en, this message translates to:
  /// **'Not linked'**
  String get googleNotLinked;

  /// No description provided for @googleLink.
  ///
  /// In en, this message translates to:
  /// **'Link Google account'**
  String get googleLink;

  /// No description provided for @googleUnlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink Google account'**
  String get googleUnlink;

  /// No description provided for @googleNoPassword.
  ///
  /// In en, this message translates to:
  /// **'You sign in with Google only. Set a password first to change this.'**
  String get googleNoPassword;

  /// No description provided for @googleNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in is not set up in this app.'**
  String get googleNotConfigured;

  /// No description provided for @googleFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Try again.'**
  String get googleFailed;

  /// No description provided for @googleLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Link a Google account'**
  String get googleLinkTitle;

  /// No description provided for @googleLinkBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your password, then choose the Google account.'**
  String get googleLinkBody;

  /// No description provided for @googleLinkedDone.
  ///
  /// In en, this message translates to:
  /// **'Google account linked.'**
  String get googleLinkedDone;

  /// No description provided for @googleUnlinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlink your Google account'**
  String get googleUnlinkTitle;

  /// No description provided for @googleUnlinkBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your password. You stay signed in here and are signed out everywhere else.'**
  String get googleUnlinkBody;

  /// No description provided for @googleUnlinkedDone.
  ///
  /// In en, this message translates to:
  /// **'Google account unlinked.'**
  String get googleUnlinkedDone;

  /// No description provided for @errorPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'The password is incorrect.'**
  String get errorPasswordIncorrect;

  /// No description provided for @errorNoPassword.
  ///
  /// In en, this message translates to:
  /// **'Set a password first.'**
  String get errorNoPassword;

  /// No description provided for @errorGoogleAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'This Google account is linked to another user.'**
  String get errorGoogleAlreadyLinked;

  /// No description provided for @errorGoogleLinkExists.
  ///
  /// In en, this message translates to:
  /// **'A Google account is already linked. Unlink it first.'**
  String get errorGoogleLinkExists;

  /// No description provided for @errorGoogleNotLinked.
  ///
  /// In en, this message translates to:
  /// **'No Google account is linked.'**
  String get errorGoogleNotLinked;

  /// No description provided for @errorGoogleSigninBlocked.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in is off for this account. Link a Google account in your security settings.'**
  String get errorGoogleSigninBlocked;
}

class _CoreLocalizationsDelegate
    extends LocalizationsDelegate<CoreLocalizations> {
  const _CoreLocalizationsDelegate();

  @override
  Future<CoreLocalizations> load(Locale locale) {
    return SynchronousFuture<CoreLocalizations>(
      lookupCoreLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_CoreLocalizationsDelegate old) => false;
}

CoreLocalizations lookupCoreLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return CoreLocalizationsEn();
    case 'vi':
      return CoreLocalizationsVi();
  }

  throw FlutterError(
    'CoreLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
