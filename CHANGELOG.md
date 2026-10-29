# Changelog

Versions are git tags (`vX.Y.Z`), following semantic versioning. Apps pin one in their `pubspec.yaml`; see the README.

## Unreleased

- **Link and unlink a Google account (FR-IAM-06, Release 10.3)**, needs vietgara-proto v1.20.0 and a backend with `GOOGLE_MOBILE_CLIENT_IDS`:
  - `AccountPage` shows a `GoogleSection` next to the Security section (hidden with `showSecurity: false`): status, link (password, then the Google picker) and unlink (password; the answer is the new session, since every other is revoked). A user with no password (Google only) sees the status and no action; a build without Google client IDs says so.
  - `GoogleIdTokenSource`, `GoogleConfig`, `GoogleSignInError` and `googleIdTokenSourceProvider` move here from the customer app (new dependency `google_sign_in`); the source gains `configured`. Apps that kept their own copy must remove it.
  - `GoogleLinkRepository` (`link`, `unlink`), `SessionController.setUser` and `adoptSession`, `User.googleLinked` and `User.hasPassword`; `errorText` translates `PASSWORD_INCORRECT`, `NO_PASSWORD`, `GOOGLE_*` and `GoogleSignInError`; new vi/en strings.
  - Test support: `pumpCoreApp(extraOverrides:)`.
- `ApiClient.bytes` takes a `method` (default `GET`), so the print endpoints, which answer the PDF to a `POST` (FR-DOC-05, Release 10.0), can be read as bytes.
- E-mail verification and password-reset OTP screens remind users to check their spam or junk folder (vi/en).
- **Optional two-step verification (MFA, FR-IAM-09, Release 6.1)**, never enforced. Needs vietgara-proto v1.11.0 and a backend with `MFA_ENCRYPTION_KEY`:
  - Sign-in: `LoginPage` asks for the authenticator code, or a recovery code, when the API answers `mfaRequired` (new `MfaChallengePage`, shown inside the login page, so apps register no new route).
  - Account: `AccountPage` shows a `SecuritySection` (turn on with a QR code and key, recovery codes shown once, new recovery codes, turn off); `AccountPage(showSecurity: false)` hides it.
  - API: `AuthRepository.login` returns a `SignInResult` (`SignedIn` or `MfaRequired`) and `verifyMfaChallenge` completes it; `SessionController.signIn` returns the `MfaChallenge?` to finish with `verifyMfa`, and `setMfaEnabled` keeps the user current; `MfaRepository` and `mfaStatusProvider` serve the Security section; `User.mfaEnabled`.
  - `errorText` translates the `MFA_*` codes; new vi/en strings; new dependency `qr_flutter` (the QR code is drawn on the device).

## v0.5.0 — 2026-10-10

- Breaking API rename: `Account` and `Session.account` are now `User` and `Session.user`, matching proto v1.6.0. Apps must update their model references and consume the `user` field in session responses.
- Auth copy now avoids using “account” for the person signing in; the profile page remains “My account”.

## v0.4.0 — 2026-10-07

Design System v2 on mobile (`vietgara-docs/docs/02-Design/v2/03_Design_System.md`, section 9). **Visual breaking change for all four apps**: bump together.

- `buildTheme` is rebuilt on the v2 tokens: Gara Blue `#1F66B3`, slate neutrals, light and dark, Be Vietnam Pro (bundled), radius 4/8/12/16, hairline cards instead of shadows, component themes for buttons, inputs, chips, dialogs, sheets, navigation bar, snack bars and tabs. `brandColor` is now `#1F66B3`.
- `VgColors` theme extension (`context.vg`): surface/border roles, subtle success/warning/info/destructive roles, license plate colors. `VgRadius` constants. Contrast is covered by `test/theme_test.dart`.
- New widgets: `PlateChip`, `Skeleton`, `SkeletonList`, `VgIllustration`.
- `StatusChip` uses the status roles and an icon per tone (never color alone). `MessageView` shows a spot illustration (its `icon` is kept for call sites and ignored); `ErrorView` uses the warning illustration. `AsyncBody` and `PagedListView` show skeleton rows while loading. `SectionCard` is a hairline panel. `FormSheet` shows its error in an error container.
- Sign-in screens show the VG brand mark.
- Fonts: Be Vietnam Pro and JetBrains Mono (SIL OFL, licenses in `assets/fonts/`).

## v0.3.1 — unreleased

- `AppConfig.supportEmail` is `support@viettechno.com`; `support@vietgara.vn` was on a domain we do not own.
- `AppConfig.apiBaseUrl` documents the API hosts: `vietgara-api-staging.viettechno.com` and `vietgara-api.viettechno.com`.

## v0.3.0 — 2026-10-06

- `ApiClient.postIdempotent` sends an `Idempotency-Key` with a POST, which the API requires to create a settlement or record a payment (API Specification §1.1). The key is kept when the request is retried after a token refresh.
- `newIdempotencyKey()`: a random key for one user action.
- `errorText` translates `IDEMPOTENCY_KEY_REUSED` (vi/en).

## v0.2.0 — unreleased

- **Staff invitations** (FR-TEN-03), shared by the owner and technician apps:
  - `Invitation`, `InvitationsRepository` (pending list, accept, decline) and `pendingInvitationsProvider`;
  - `InvitationTile` and `InvitationsPage`, each with an `onAccepted` callback, so the app reloads its own state, such as its garages.
- Their vi/en strings in `CoreLocalizations`.

## v0.1.0 — 2026-10-05

First version, extracted from `vietgara-owner-app` and `vietgara-admin-app`, where the code was duplicated.

- **REST client** (`ApiClient`):
  - bearer authentication, with one refresh-token rotation shared by concurrent 401 answers;
  - `Accept-Language`;
  - error answers as `ApiException` carrying the stable error code;
  - file downloads.
- `ResultPage`, the proto3 JSON readers, and `TokenStore` (Keychain/Keystore through `flutter_secure_storage`).
- **Session:**
  - `SessionController` (restore, sign in, register, verify the e-mail, update the profile, change the language, sign out), `AuthRepository`, and `Account`, which has value equality and `platformAdmin`.
  - Sign-in screens at `AuthRoutes`: splash, login (sign-up link optional), register, forgot password, verify e-mail.
  - `AccountPage` (profile; language and sign-out with `showSettings`), `LanguageTile`, `SignOutTile`.
- **Shared widgets:**
  - `MessageView`, `ErrorView`, `AsyncBody`, `InfoRow`, `SectionCard`, `StatusChip`, `BusyButton`, `confirm`;
  - `PagedListView` with item keys, `SearchField`, `FormSheet`;
  - `shareOrigin` for the iPad share popover.
- `formatMoney`, `formatDate`, `formatQuantity`, `Validators`, `errorText` (every backend error code), `buildTheme`, `LocaleController`, `AppConfig` (`API_BASE_URL`), and the providers wiring them.
- `CoreLocalizations`: Vietnamese/English strings for all of the above.
- `package:vietgara_core/testing.dart`: `FakeApi`, `FakeResponse`, `decodeBody` and `overridesFor`, for the apps' widget tests.
