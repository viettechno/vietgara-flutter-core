# Changelog

Versions are git tags (`vX.Y.Z`), following semantic versioning. Apps pin one in their `pubspec.yaml`; see the README.

## v0.3.0 — unreleased

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
