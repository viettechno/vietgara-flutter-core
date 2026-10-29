import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietgara_core/testing.dart';
import 'package:vietgara_core/vietgara_core.dart';

import '../support/core_app.dart';

/// A Google source that answers [token] (null: the person canceled).
class FakeGoogleSource implements GoogleIdTokenSource {
  FakeGoogleSource({this.token = 'id-token-1', this.configured = true});

  final String? token;
  Object? error;
  int signIns = 0;
  int signOuts = 0;

  @override
  final bool configured;

  @override
  Future<String?> signIn() async {
    signIns++;
    if (error != null) throw error!;
    return token;
  }

  @override
  Future<void> signOut() async => signOuts++;
}

Future<FakeApi> pumpAccount(
  WidgetTester tester, {
  required FakeApi api,
  required FakeGoogleSource source,
}) async {
  await pumpCoreApp(
    tester,
    api: api,
    signedIn: true,
    extraOverrides: [googleIdTokenSourceProvider.overrideWithValue(source)],
  );
  await tester.tap(find.text('Home'));
  await tester.pumpAndSettle();
  return api;
}

FakeApi apiFor(Json me) => FakeApi()
  ..on('GET /me', (_) => me)
  ..on('GET /me/mfa', (_) => {'enabled': false});

/// Taps the control with [key], scrolling it into view first.
Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.ensureVisible(find.byKey(Key(key)));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

Future<void> confirmWithPassword(WidgetTester tester, String label) async {
  await tester.enterText(
    find.byKey(const Key('google-sheet-password')),
    'secret12',
  );
  await tester.tap(
    find.descendant(
      of: find.byType(BottomSheet),
      matching: find.widgetWithText(FilledButton, label),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('Google section of the account page', () {
    testWidgets('links the Google account with the password', (tester) async {
      final source = FakeGoogleSource();
      final api = apiFor(userJson())
        ..on('POST /me/google-link', (_) => userJson(googleLinked: true));
      await pumpAccount(tester, api: api, source: source);

      expect(find.text('Not linked'), findsOneWidget);
      await tapKey(tester, 'google-link');
      await confirmWithPassword(tester, 'Link Google account');

      expect(decodeBody(api.calls('POST /me/google-link').single), {
        'idToken': 'id-token-1',
        'password': 'secret12',
      });
      expect(source.signOuts, 1);
      expect(find.text('Google account linked.'), findsOneWidget);
      expect(find.text('Linked'), findsOneWidget);
      expect(find.byKey(const Key('google-unlink')), findsOneWidget);
    });

    testWidgets('links nothing when the person cancels Google', (tester) async {
      final source = FakeGoogleSource(token: null);
      final api = apiFor(userJson());
      await pumpAccount(tester, api: api, source: source);

      await tapKey(tester, 'google-link');
      await confirmWithPassword(tester, 'Link Google account');

      expect(source.signIns, 1);
      expect(api.calls('POST /me/google-link'), isEmpty);
      expect(find.text('Not linked'), findsOneWidget);
    });

    testWidgets('shows the translated error of a wrong password', (
      tester,
    ) async {
      final source = FakeGoogleSource();
      final api = apiFor(userJson())
        ..on(
          'POST /me/google-link',
          (_) => FakeResponse.error(403, 'PASSWORD_INCORRECT'),
        );
      await pumpAccount(tester, api: api, source: source);

      await tapKey(tester, 'google-link');
      await confirmWithPassword(tester, 'Link Google account');

      expect(find.text('The password is incorrect.'), findsOneWidget);
      expect(find.text('Not linked'), findsOneWidget);
    });

    testWidgets('shows a failed Google sign-in in the sheet', (tester) async {
      final source = FakeGoogleSource()
        ..error = const GoogleSignInError(GoogleSignInFailure.failed);
      final api = apiFor(userJson());
      await pumpAccount(tester, api: api, source: source);

      await tapKey(tester, 'google-link');
      await confirmWithPassword(tester, 'Link Google account');

      expect(find.text('Google sign-in failed. Try again.'), findsOneWidget);
      expect(api.calls('POST /me/google-link'), isEmpty);
    });

    testWidgets('unlinks and continues with the new session', (tester) async {
      final source = FakeGoogleSource();
      final api = apiFor(userJson(googleLinked: true))
        ..on(
          'POST /me/google-link:unlink',
          (_) => {
            'accessToken': 'access-2',
            'refreshToken': 'refresh-2',
            'user': userJson(),
          },
        );
      await pumpAccount(tester, api: api, source: source);

      expect(find.text('Linked'), findsOneWidget);
      await tapKey(tester, 'google-unlink');
      await confirmWithPassword(tester, 'Unlink Google account');

      expect(decodeBody(api.calls('POST /me/google-link:unlink').single), {
        'password': 'secret12',
      });
      expect(find.text('Google account unlinked.'), findsOneWidget);
      expect(find.text('Not linked'), findsOneWidget);
      expect(find.byKey(const Key('google-link')), findsOneWidget);
    });

    testWidgets('offers no action to a user with no password', (tester) async {
      final api = apiFor(userJson(hasPassword: false, googleLinked: true));
      await pumpAccount(tester, api: api, source: FakeGoogleSource());

      expect(find.text('Linked'), findsOneWidget);
      expect(find.byKey(const Key('google-link')), findsNothing);
      expect(find.byKey(const Key('google-unlink')), findsNothing);
      expect(
        find.text(
          'You sign in with Google only. Set a password first to change this.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('says so when the app has no Google client IDs', (
      tester,
    ) async {
      final api = apiFor(userJson());
      await pumpAccount(
        tester,
        api: api,
        source: FakeGoogleSource(configured: false),
      );

      expect(find.byKey(const Key('google-link')), findsNothing);
      expect(
        find.text('Google sign-in is not set up in this app.'),
        findsOneWidget,
      );
    });
  });
}
