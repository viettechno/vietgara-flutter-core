# vietgara-flutter-core

Shared core of the VietGara Flutter apps, as the Dart package `vietgara_core`. It is used by `vietgara-owner-app` and `vietgara-admin-app`, and is meant for `vietgara-customer-app` and `vietgara-technician-app`.

It holds what every app needs the same way:

- the REST client (bearer auth, refresh-token rotation, typed errors) and the session;
- the e-mail sign-in screens;
- shared widgets, formatting, validators and the theme;
- their Vietnamese/English strings.

Feature screens, routers and app-specific strings stay in each app.

## What's inside

| Area | Main types |
| --- | --- |
| REST API | `ApiClient`, `ApiException`, `ResultPage`, `TokenStore` / `SecureTokenStore`, JSON readers (`JsonRead`) |
| Session and sign-in | `sessionControllerProvider` (`SessionController`), `AuthRepository`, `Account`; screens `SplashPage`, `LoginPage`, `RegisterPage`, `ForgotPasswordPage`, `VerifyEmailPage` at the paths in `AuthRoutes` |
| Account | `AccountPage` (profile; language and sign-out with `showSettings: true`), `LanguageTile`, `SignOutTile` |
| Widgets | `AsyncBody`, `MessageView`, `ErrorView`, `SectionCard`, `InfoRow`, `StatusChip`, `BusyButton`, `confirm`, `PagedListView` (with `itemKey`), `SearchField`, `FormSheet` / `showFormSheet` |
| Utilities | `formatMoney` / `context.money`, `formatDate`, `formatQuantity`, `Validators`, `errorText` / `context.showError`, `shareOrigin`, `buildTheme` |
| Configuration | `AppConfig.apiBaseUrl` (`--dart-define=API_BASE_URL=…`), `sharedPreferencesProvider` (override in `main`), `localeControllerProvider` |
| Strings | `CoreLocalizations` (vi/en), read through `context.coreL10n` |
| Tests | `package:vietgara_core/testing.dart`: `FakeApi`, `FakeResponse`, `decodeBody`, `overridesFor` |

## Use it in an app

1. **Depend on a released tag, never a branch:**

   ```yaml
   dependencies:
     vietgara_core:
       git:
         url: https://github.com/viettechno/vietgara-flutter-core.git
         ref: v0.1.0
   ```

2. **Register the core's strings** next to the app's own:

   ```dart
   MaterialApp.router(
     localizationsDelegates: const [
       AppLocalizations.delegate,
       CoreLocalizations.delegate,
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       GlobalCupertinoLocalizations.delegate,
     ],
     supportedLocales: AppLocalizations.supportedLocales,
     // ...
   );
   ```

3. **Register the sign-in screens** at the `AuthRoutes` paths in the app's go_router. The app's redirect decides who sees what.
4. **Override `sharedPreferencesProvider`** in `main` with the loaded `SharedPreferences`.
5. **Clear app-specific session state yourself.** On sign-out the core clears its own state only; for example, the owner app's selected garage is cleared by listening to `sessionControllerProvider`.

The app's own strings stay in its `lib/l10n/*.arb` and are read through the app's own `context.l10n` extension. Strings the core already has (actions, field labels, validation, errors) are not repeated in the apps.

### CI access

The repository is public, so `flutter pub get` fetches it over HTTPS with no credentials, both locally and in GitHub Actions. Use the `https://` URL, not the `git@github.com:` SSH form: GitHub requires an SSH key for SSH clones even of public repositories, and CI has none.

It holds no secrets, and must never hold any. Configuration such as the API address comes from `--dart-define` at build time.

## Change it

1. Change the code here, with tests, on a branch, and open a pull request into `master`.
2. To try it in an app before releasing, override the dependency locally and do not commit the override:

   ```yaml
   dependency_overrides:
     vietgara_core:
       path: ../vietgara-flutter-core
   ```

3. Once merged, add a `CHANGELOG.md` entry and tag the release:

   ```bash
   git tag -a v0.2.0 -m "v0.2.0" && git push origin v0.2.0
   ```

   Use semantic versions: a breaking API change bumps the minor version while below 1.0.
4. In each app, bump `ref:` in `pubspec.yaml`, run `flutter pub get`, and open a pull request.

## Quality checks

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

The same checks run in GitHub Actions. `flutter gen-l10n` regenerates `lib/src/l10n/core_localizations*.dart` from the `.arb` files. The generated files are committed, because apps do not generate a dependency's localizations.
