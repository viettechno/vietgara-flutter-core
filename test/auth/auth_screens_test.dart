import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietgara_core/testing.dart';

import '../support/core_app.dart';

Future<void> signIn(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('login-email')),
    'owner@example.com',
  );
  await tester.enterText(find.byKey(const Key('login-password')), 'secret12');
  await tester.tap(find.byKey(const Key('login-submit')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('validates the sign-in form before calling the API', (
    tester,
  ) async {
    final api = await pumpCoreApp(tester);

    await tester.enterText(find.byKey(const Key('login-email')), 'owner');
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pump();

    expect(find.text('Enter a valid e-mail.'), findsOneWidget);
    expect(find.text('Required.'), findsOneWidget);
    expect(api.calls('POST /auth/login'), isEmpty);
  });

  testWidgets('shows the translated error of a refused sign-in', (
    tester,
  ) async {
    final api = FakeApi()
      ..on(
        'POST /auth/login',
        (_) => FakeResponse.error(401, 'INVALID_CREDENTIALS'),
      );
    await pumpCoreApp(tester, api: api);

    await signIn(tester);

    expect(find.text('Wrong e-mail or password.'), findsOneWidget);
  });

  testWidgets('signs in and follows the account language', (tester) async {
    final api = FakeApi()
      ..on(
        'POST /auth/login',
        (_) => {...sessionJson(), 'account': accountJson(locale: 'LOCALE_VI')},
      );
    await pumpCoreApp(tester, api: api);

    await signIn(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(decodeBody(api.calls('POST /auth/login').single), {
      'email': 'owner@example.com',
      'password': 'secret12',
    });
  });

  testWidgets('offers sign-up only when allowed', (tester) async {
    await pumpCoreApp(tester, allowSignUp: false);
    expect(find.text('No account yet? Sign up'), findsNothing);
  });

  testWidgets('signs up and verifies the e-mail', (tester) async {
    final api = FakeApi()
      ..on('POST /auth/register', (_) => sessionJson(verified: false))
      ..on('POST /auth/email-verification/otp', (_) => {})
      ..on('POST /auth/email-verification', (_) => sessionJson());
    await pumpCoreApp(tester, api: api);

    await tester.tap(find.text('No account yet? Sign up'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'Nguyen Van An',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail'),
      'owner@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'secret123',
    );
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Verify your e-mail'), findsOneWidget);
    expect(api.calls('POST /auth/email-verification/otp'), hasLength(1));

    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(decodeBody(api.calls('POST /auth/email-verification').single), {
      'otpCode': '123456',
      'refreshToken': 'refresh-1',
    });
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('resets the password in three steps', (tester) async {
    final api = FakeApi()
      ..on('POST /auth/password-reset/otp', (_) => {})
      ..on(
        'POST /auth/password-reset/otp/verification',
        (_) => {'resetToken': 'reset-1'},
      )
      ..on('POST /auth/password-reset', (_) => {});
    await pumpCoreApp(tester, api: api);

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'owner@example.com');
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '123456');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'newsecret1');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(decodeBody(api.calls('POST /auth/password-reset').single), {
      'resetToken': 'reset-1',
      'newPassword': 'newsecret1',
    });
    expect(find.byKey(const Key('login-email')), findsOneWidget);
  });

  testWidgets('shows a retry when the API cannot be reached at start-up', (
    tester,
  ) async {
    var online = false;
    final api = FakeApi()
      ..on('GET /me', (_) {
        if (!online) throw Exception('offline');
        return accountJson();
      });
    await pumpCoreApp(tester, api: api, signedIn: true);

    expect(
      find.text('Cannot reach VietGara. Check your connection.'),
      findsOneWidget,
    );

    online = true;
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('edits the profile, switches language and signs out', (
    tester,
  ) async {
    final api = FakeApi()
      ..on('GET /me', (_) => accountJson())
      ..on('PATCH /me', (request) => {...accountJson(), ...decodeBody(request)})
      ..on('POST /auth/logout', (_) => {});
    await pumpCoreApp(tester, api: api, signedIn: true);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Phone'),
      '0909999999',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(decodeBody(api.calls('PATCH /me').single), {
      'fullName': 'Nguyen Van An',
      'phone': '0909999999',
    });

    await tester.tap(find.text('VI'));
    await tester.pumpAndSettle();
    expect(decodeBody(api.calls('PATCH /me').last), {'locale': 'LOCALE_VI'});

    await tester.tap(find.text('Đăng xuất'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xác nhận'));
    await tester.pumpAndSettle();

    expect(decodeBody(api.calls('POST /auth/logout').single), {
      'refreshToken': 'refresh-1',
    });
    expect(find.byKey(const Key('login-email')), findsOneWidget);
  });
}
