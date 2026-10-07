# Changelog

Versions are git tags (`vX.Y.Z`), following semantic versioning. Apps pin one in their `pubspec.yaml`; see the README.

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
