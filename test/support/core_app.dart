import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vietgara_core/testing.dart';
import 'package:vietgara_core/vietgara_core.dart';

Json accountJson({bool verified = true, String locale = 'LOCALE_EN'}) => {
  'id': 'acc-1',
  'email': 'owner@example.com',
  'fullName': 'Nguyen Van An',
  'phone': '0901234567',
  'emailVerified': verified,
  'locale': locale,
};

Json sessionJson({bool verified = true}) => {
  'accessToken': 'access-1',
  'refreshToken': 'refresh-1',
  'account': accountJson(verified: verified),
};

/// The smallest app around the core's screens: the sign-in screens at
/// [AuthRoutes], a `/home` for signed-in accounts and an `/account`.
class CoreTestApp extends ConsumerStatefulWidget {
  const CoreTestApp({super.key, this.allowSignUp = true});

  final bool allowSignUp;

  @override
  ConsumerState<CoreTestApp> createState() => _CoreTestAppState();
}

class _CoreTestAppState extends ConsumerState<CoreTestApp> {
  // Created once: rebuilding the app (e.g. on a language change) must keep
  // the navigation.
  late final GoRouter router = _router();

  @override
  void dispose() {
    router.dispose();
    super.dispose();
  }

  GoRouter _router() {
    final allowSignUp = widget.allowSignUp;
    return GoRouter(
      initialLocation: AuthRoutes.splash,
      refreshListenable: _SessionListenable(ref),
      redirect: (context, state) {
        final session = ref.read(sessionControllerProvider);
        final location = state.matchedLocation;
        if (!session.hasValue) {
          return location == AuthRoutes.splash ? null : AuthRoutes.splash;
        }
        final account = session.value;
        const signedOut = {
          AuthRoutes.login,
          AuthRoutes.register,
          AuthRoutes.forgotPassword,
        };
        if (account == null) {
          return signedOut.contains(location) ? null : AuthRoutes.login;
        }
        if (!account.emailVerified) {
          return location == AuthRoutes.verifyEmail
              ? null
              : AuthRoutes.verifyEmail;
        }
        return signedOut.contains(location) ||
                location == AuthRoutes.splash ||
                location == AuthRoutes.verifyEmail
            ? '/home'
            : null;
      },
      routes: [
        GoRoute(path: AuthRoutes.splash, builder: (_, _) => const SplashPage()),
        GoRoute(
          path: AuthRoutes.login,
          builder: (_, _) => LoginPage(allowSignUp: allowSignUp),
        ),
        GoRoute(
          path: AuthRoutes.register,
          builder: (_, _) => const RegisterPage(),
        ),
        GoRoute(
          path: AuthRoutes.forgotPassword,
          builder: (_, _) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: AuthRoutes.verifyEmail,
          builder: (_, _) => const VerifyEmailPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, _) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => context.push('/account'),
                child: const Text('Home'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/account',
          builder: (_, _) => const AccountPage(showSettings: true),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: ref.watch(localeControllerProvider),
      supportedLocales: CoreLocalizations.supportedLocales,
      localizationsDelegates: const [
        CoreLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}

class _SessionListenable extends ChangeNotifier {
  _SessionListenable(WidgetRef ref) {
    ref.listenManual(sessionControllerProvider, (_, _) => notifyListeners());
  }
}

/// Pumps [CoreTestApp] on [api].
Future<FakeApi> pumpCoreApp(
  WidgetTester tester, {
  FakeApi? api,
  bool signedIn = false,
  bool allowSignUp = true,
}) async {
  final fake = api ?? FakeApi();
  final overrides = await overridesFor(
    fake,
    tokens: signedIn ? signedInTokens : null,
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      retry: (_, _) => null,
      child: CoreTestApp(allowSignUp: allowSignUp),
    ),
  );
  await tester.pumpAndSettle();
  return fake;
}
