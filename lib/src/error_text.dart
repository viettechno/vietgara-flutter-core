import 'api/api_exception.dart';
import 'auth/google_id_token_source.dart';
import 'l10n/core_localizations.dart';

/// The user-facing text of an error: the translation of its API code, else
/// the server's message, else a generic text.
String errorText(CoreLocalizations l10n, Object? error) {
  if (error is GoogleSignInError) {
    return switch (error.failure) {
      GoogleSignInFailure.notConfigured => l10n.googleNotConfigured,
      GoogleSignInFailure.failed => l10n.googleFailed,
    };
  }
  if (error is! ApiException) return l10n.errorGeneric;
  return switch (error.code) {
    'NETWORK' => l10n.errorNetwork,
    'INTERNAL' => l10n.errorInternal,
    'BAD_REQUEST' => l10n.errorBadRequest,
    'VALIDATION_ERROR' => l10n.errorValidation,
    'NOT_FOUND' => l10n.errorNotFound,
    'UNAUTHENTICATED' => l10n.errorUnauthenticated,
    'PERMISSION_DENIED' => l10n.errorPermissionDenied,
    'ALREADY_EXISTS' => l10n.errorAlreadyExists,
    'FAILED_PRECONDITION' => l10n.errorFailedPrecondition,
    'RATE_LIMITED' => l10n.errorRateLimited,
    'INVALID_CREDENTIALS' => l10n.errorInvalidCredentials,
    'USER_SUSPENDED' || 'USER_INACTIVE' => l10n.errorUserSuspended,
    'EMAIL_TAKEN' => l10n.errorEmailTaken,
    'PHONE_TAKEN' => l10n.errorPhoneTaken,
    'EMAIL_NOT_VERIFIED' => l10n.errorEmailNotVerified,
    'EMAIL_ALREADY_VERIFIED' => l10n.errorEmailAlreadyVerified,
    'OTP_INVALID' => l10n.errorOtpInvalid,
    'OTP_EXPIRED' => l10n.errorOtpExpired,
    'OTP_TOO_MANY_ATTEMPTS' => l10n.errorOtpTooManyAttempts,
    'OTP_RESEND_TOO_SOON' => l10n.errorOtpResendTooSoon,
    'RESET_TOKEN_INVALID' => l10n.errorResetTokenInvalid,
    'REFRESH_TOKEN_INVALID' => l10n.errorRefreshTokenInvalid,
    'MFA_CODE_INVALID' => l10n.errorMfaCodeInvalid,
    'MFA_LOCKED' => l10n.errorMfaLocked,
    'MFA_CHALLENGE_INVALID' => l10n.errorMfaChallengeInvalid,
    'MFA_ALREADY_ENABLED' => l10n.errorMfaAlreadyEnabled,
    'MFA_NOT_ENABLED' => l10n.errorMfaNotEnabled,
    'MFA_ENROLLMENT_NOT_STARTED' => l10n.errorMfaEnrollmentNotStarted,
    'MFA_NOT_AVAILABLE' => l10n.errorMfaNotAvailable,
    'MFA_NOT_CONFIGURED' => l10n.errorMfaNotConfigured,
    'PASSWORD_INCORRECT' => l10n.errorPasswordIncorrect,
    'NO_PASSWORD' => l10n.errorNoPassword,
    'GOOGLE_ALREADY_LINKED' => l10n.errorGoogleAlreadyLinked,
    'GOOGLE_LINK_EXISTS' => l10n.errorGoogleLinkExists,
    'GOOGLE_NOT_LINKED' => l10n.errorGoogleNotLinked,
    'GOOGLE_SIGNIN_BLOCKED' => l10n.errorGoogleSigninBlocked,
    'GOOGLE_TOKEN_INVALID' => l10n.googleFailed,
    'GARAGE_ACCESS_DENIED' => l10n.errorGarageAccessDenied,
    'OWNER_ONLY' => l10n.errorOwnerOnly,
    'GARAGE_INACTIVE' => l10n.errorGarageInactive,
    'SUBSCRIPTION_SUSPENDED' => l10n.errorSubscriptionSuspended,
    'SUBSCRIPTION_READ_ONLY' => l10n.errorSubscriptionReadOnly,
    'PLAN_LIMIT_REACHED' => l10n.errorPlanLimitReached,
    'PLAN_NOT_AVAILABLE' => l10n.errorPlanNotAvailable,
    'INVITATION_NOT_PENDING' => l10n.errorInvitationNotPending,
    'INVITATION_EXPIRED' => l10n.errorInvitationExpired,
    'PLAN_CODE_TAKEN' => l10n.errorPlanCodeTaken,
    'IDEMPOTENCY_KEY_REUSED' => l10n.errorIdempotencyKeyReused,
    _ => error.message.isNotEmpty ? error.message : l10n.errorGeneric,
  };
}
