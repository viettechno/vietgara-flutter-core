import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietgara_core/testing.dart';

import '../support/core_app.dart';

Json mfaChallengeJson() => {
  'mfaRequired': true,
  'challengeToken': 'challenge-1',
  'challengeExpiresAt': '2026-10-17T10:05:00Z',
  'user': userJson(),
};

Future<void> signInWithPassword(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('login-email')),
    'owner@example.com',
  );
  await tester.enterText(find.byKey(const Key('login-password')), 'secret12');
  await tester.tap(find.byKey(const Key('login-submit')));
  await tester.pumpAndSettle();
}

Future<void> openAccount(WidgetTester tester) async {
  await tester.tap(find.text('Home'));
  await tester.pumpAndSettle();
}

void main() {
  group('sign-in second step', () {
    testWidgets('asks for the code and signs in with it', (tester) async {
      final api = FakeApi()
        ..on('POST /auth/login', (_) => mfaChallengeJson())
        ..on('POST /auth/mfa/challenge', (_) => sessionJson());
      await pumpCoreApp(tester, api: api);

      await signInWithPassword(tester);

      expect(find.text('Two-step verification'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
      await tester.enterText(find.byKey(const Key('mfa-code')), '123456');
      await tester.pump();
      await tester.tap(find.byKey(const Key('mfa-submit')));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(decodeBody(api.calls('POST /auth/mfa/challenge').single), {
        'challengeToken': 'challenge-1',
        'code': '123456',
      });
    });

    testWidgets('takes a recovery code instead', (tester) async {
      final api = FakeApi()
        ..on('POST /auth/login', (_) => mfaChallengeJson())
        ..on('POST /auth/mfa/challenge', (_) => sessionJson());
      await pumpCoreApp(tester, api: api);
      await signInWithPassword(tester);

      await tester.tap(find.byKey(const Key('mfa-toggle')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('mfa-recovery-code')),
        'K7QX2-M9PTR',
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('mfa-submit')));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(
        decodeBody(api.calls('POST /auth/mfa/challenge').single)['code'],
        'K7QX2-M9PTR',
      );
    });

    testWidgets('does not submit an incomplete code', (tester) async {
      final api = FakeApi()..on('POST /auth/login', (_) => mfaChallengeJson());
      await pumpCoreApp(tester, api: api);
      await signInWithPassword(tester);

      await tester.enterText(find.byKey(const Key('mfa-code')), '12');
      await tester.pump();

      final submit = tester.widget<FilledButton>(
        find.descendant(
          of: find.byKey(const Key('mfa-submit')),
          matching: find.byType(FilledButton),
        ),
      );
      expect(submit.onPressed, isNull);
      expect(api.calls('POST /auth/mfa/challenge'), isEmpty);
    });

    testWidgets('shows the translated error and goes back to the password', (
      tester,
    ) async {
      final api = FakeApi()
        ..on('POST /auth/login', (_) => mfaChallengeJson())
        ..on(
          'POST /auth/mfa/challenge',
          (_) => FakeResponse.error(429, 'MFA_LOCKED'),
        );
      await pumpCoreApp(tester, api: api);
      await signInWithPassword(tester);

      await tester.enterText(find.byKey(const Key('mfa-code')), '000000');
      await tester.pump();
      await tester.tap(find.byKey(const Key('mfa-submit')));
      await tester.pumpAndSettle();
      expect(
        find.text('Too many wrong codes. Try again in 15 minutes.'),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('mfa-back')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('login-submit')), findsOneWidget);
    });
  });

  group('security section of the account page', () {
    FakeApi signedInApi() => FakeApi()..on('GET /me', (_) => userJson());

    testWidgets('turns two-step verification on and shows the codes once', (
      tester,
    ) async {
      var enabled = false;
      final api = signedInApi()
        ..on(
          'GET /me/mfa',
          (_) => {
            'enabled': enabled,
            'enabledAt': '2026-10-17T09:00:00Z',
            'recoveryCodesRemaining': enabled ? 2 : 0,
          },
        )
        ..on(
          'POST /me/mfa/enroll',
          (_) => {
            'secret': 'JBSWY3DPEHPK3PXP',
            'otpauthUri':
                'otpauth://totp/VietGara:owner@example.com?secret=JBSWY3DPEHPK3PXP',
          },
        )
        ..on('POST /me/mfa/enroll:confirm', (_) {
          enabled = true;
          return {
            'recoveryCodes': ['AAAAA-BBBBB', 'CCCCC-DDDDD'],
          };
        });
      await pumpCoreApp(tester, api: api, signedIn: true);
      await openAccount(tester);

      expect(find.text('Off'), findsOneWidget);
      await tester.tap(find.byKey(const Key('mfa-turn-on')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('mfa-qr')), findsOneWidget);
      expect(find.text('JBSWY3DPEHPK3PXP'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('mfa-sheet-code')), '12');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(find.text('Enter the 6-digit code.'), findsOneWidget);
      expect(api.calls('POST /me/mfa/enroll:confirm'), isEmpty);

      await tester.enterText(find.byKey(const Key('mfa-sheet-code')), '123456');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('AAAAA-BBBBB'), findsOneWidget);
      expect(find.text('CCCCC-DDDDD'), findsOneWidget);
      expect(decodeBody(api.calls('POST /me/mfa/enroll:confirm').single), {
        'code': '123456',
      });

      final done = find.byKey(const Key('mfa-recovery-done'));
      expect(tester.widget<FilledButton>(done).onPressed, isNull);
      await tester.tap(find.byKey(const Key('mfa-recovery-saved')));
      await tester.pump();
      await tester.tap(done);
      await tester.pumpAndSettle();

      expect(find.text('On'), findsOneWidget);
      expect(find.textContaining('2 recovery codes left'), findsOneWidget);
    });

    testWidgets('shows the translated error of a wrong confirming code', (
      tester,
    ) async {
      final api = signedInApi()
        ..on('GET /me/mfa', (_) => {'enabled': false})
        ..on(
          'POST /me/mfa/enroll',
          (_) => {
            'secret': 'JBSWY3DPEHPK3PXP',
            'otpauthUri': 'otpauth://totp/x?secret=JBSWY3DPEHPK3PXP',
          },
        )
        ..on(
          'POST /me/mfa/enroll:confirm',
          (_) => FakeResponse.error(422, 'MFA_CODE_INVALID'),
        );
      await pumpCoreApp(tester, api: api, signedIn: true);
      await openAccount(tester);

      await tester.tap(find.byKey(const Key('mfa-turn-on')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('mfa-sheet-code')), '000000');
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('The code is incorrect.'), findsOneWidget);
    });

    testWidgets('turns it off with a code', (tester) async {
      var enabled = true;
      final api = signedInApi()
        ..on(
          'GET /me/mfa',
          (_) => {
            'enabled': enabled,
            'enabledAt': '2026-10-01T09:00:00Z',
            'recoveryCodesRemaining': 8,
          },
        )
        ..on('POST /me/mfa:disable', (_) {
          enabled = false;
          return const {};
        });
      await pumpCoreApp(tester, api: api, signedIn: true);
      await openAccount(tester);

      expect(find.text('On'), findsOneWidget);
      expect(find.textContaining('8 recovery codes left'), findsOneWidget);

      await tester.tap(find.byKey(const Key('mfa-turn-off')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('mfa-sheet-code')),
        'AAAAA-BBBBB',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Turn off'));
      await tester.pumpAndSettle();

      expect(decodeBody(api.calls('POST /me/mfa:disable').single), {
        'code': 'AAAAA-BBBBB',
      });
      expect(find.text('Off'), findsOneWidget);
      expect(find.text('Two-step verification is off.'), findsOneWidget);
    });

    testWidgets('needs a code to replace the recovery codes', (tester) async {
      final api = signedInApi()
        ..on(
          'GET /me/mfa',
          (_) => {'enabled': true, 'recoveryCodesRemaining': 1},
        )
        ..on(
          'POST /me/mfa/recovery-codes',
          (_) => {
            'recoveryCodes': ['EEEEE-FFFFF'],
          },
        );
      await pumpCoreApp(tester, api: api, signedIn: true);
      await openAccount(tester);

      await tester.tap(find.byKey(const Key('mfa-new-codes')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('mfa-sheet-code')), '123456');
      await tester.tap(find.widgetWithText(FilledButton, 'New recovery codes'));
      await tester.pumpAndSettle();

      expect(find.text('EEEEE-FFFFF'), findsOneWidget);
    });
  });
}
