import 'api/api_exception.dart';
import 'l10n/core_localizations.dart';

/// The user-facing text of an error: the translation of its API code, else
/// the server's message, else a generic text.
String errorText(CoreLocalizations l10n, Object? error) {
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
    'ACCOUNT_SUSPENDED' || 'ACCOUNT_INACTIVE' => l10n.errorAccountSuspended,
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
    _ => error.message.isNotEmpty ? error.message : l10n.errorGeneric,
  };
}
