import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietgara_core/testing.dart';

import '../support/core_app.dart';

FakeApi apiFor(Json me) => FakeApi()
  ..on('GET /me', (_) => me)
  ..on('GET /me/mfa', (_) => {'enabled': false});

Future<void> pumpAccount(WidgetTester tester, FakeApi api) async {
  await pumpCoreApp(tester, api: api, signedIn: true);
  await tester.tap(find.text('Home'));
  await tester.pumpAndSettle();
}

Future<void> openSheet(WidgetTester tester) async {
  await tester.ensureVisible(find.byKey(const Key('password-change')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('password-change')));
  await tester.pumpAndSettle();
}

Future<void> fillSheet(
  WidgetTester tester, {
  String current = 'secret12',
  String password = 'brand-new-pass',
  String confirm = 'brand-new-pass',
}) async {
  await tester.enterText(find.byKey(const Key('password-current')), current);
  await tester.enterText(find.byKey(const Key('password-new')), password);
  await tester.enterText(find.byKey(const Key('password-confirm')), confirm);
  await tester.tap(
    find.descendant(
      of: find.byType(BottomSheet),
      matching: find.widgetWithText(FilledButton, 'Change password'),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('Password section of the account page', () {
    testWidgets('changes the password and continues with the new session', (
      tester,
    ) async {
      final api = apiFor(userJson())
        ..on(
          'POST /me/password:change',
          (_) => {
            'accessToken': 'access-2',
            'refreshToken': 'refresh-2',
            'user': userJson(),
          },
        );
      await pumpAccount(tester, api);

      await openSheet(tester);
      await fillSheet(tester);

      expect(decodeBody(api.calls('POST /me/password:change').single), {
        'currentPassword': 'secret12',
        'newPassword': 'brand-new-pass',
      });
      expect(
        find.text('Password changed. Other devices were signed out.'),
        findsOneWidget,
      );
      expect(find.byType(BottomSheet), findsNothing);
    });

    testWidgets('sends nothing while the repeat differs', (tester) async {
      final api = apiFor(userJson());
      await pumpAccount(tester, api);

      await openSheet(tester);
      await fillSheet(tester, confirm: 'other-new-pass');

      expect(find.text('The passwords do not match.'), findsOneWidget);
      expect(api.calls('POST /me/password:change'), isEmpty);
    });

    testWidgets('shows the translated error of a wrong current password', (
      tester,
    ) async {
      final api = apiFor(userJson())
        ..on(
          'POST /me/password:change',
          (_) => FakeResponse.error(403, 'PASSWORD_INCORRECT'),
        );
      await pumpAccount(tester, api);

      await openSheet(tester);
      await fillSheet(tester);

      expect(find.text('The password is incorrect.'), findsOneWidget);
      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('offers nothing to a user with no password', (tester) async {
      final api = apiFor(userJson(hasPassword: false));
      await pumpAccount(tester, api);

      expect(find.byKey(const Key('password-change')), findsNothing);
    });
  });
}
