/// Shared core of the VietGara Flutter apps: the REST client and its
/// session, the sign-in screens, shared widgets, formatting, theme and
/// their Vietnamese/English strings ([CoreLocalizations]).
///
/// Apps register [CoreLocalizations.delegate] next to their own
/// localizations delegate, and the sign-in screens at [AuthRoutes].
library;

export 'src/account/account_page.dart';
export 'src/api/api_client.dart';
export 'src/api/api_exception.dart';
export 'src/api/idempotency.dart';
export 'src/api/json.dart';
export 'src/api/page.dart';
export 'src/api/token_store.dart';
export 'src/auth/auth_repository.dart';
export 'src/auth/auth_routes.dart';
export 'src/auth/auth_scaffold.dart';
export 'src/auth/forgot_password_page.dart';
export 'src/auth/login_page.dart';
export 'src/auth/register_page.dart';
export 'src/auth/resend_countdown.dart';
export 'src/auth/session_controller.dart';
export 'src/auth/splash_page.dart';
export 'src/auth/user.dart';
export 'src/auth/verify_email_page.dart';
export 'src/config.dart';
export 'src/error_text.dart';
export 'src/format.dart';
export 'src/invitations/invitation.dart';
export 'src/invitations/invitation_providers.dart';
export 'src/invitations/invitation_tile.dart';
export 'src/invitations/invitations_page.dart';
export 'src/invitations/invitations_repository.dart';
export 'src/l10n/core_localizations.dart';
export 'src/locale_controller.dart';
export 'src/providers.dart';
export 'src/share_origin.dart';
export 'src/theme.dart';
export 'src/validators.dart';
export 'src/widgets/common.dart';
export 'src/widgets/form_sheet.dart';
export 'src/widgets/paged_list.dart';
export 'src/widgets/vg.dart';
