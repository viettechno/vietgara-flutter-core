import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietgara_core/testing.dart';
import 'package:vietgara_core/vietgara_core.dart';

import 'support/core_app.dart';

Json invitationJson(String id, String garage) => {
  'id': id,
  'garageName': garage,
  'status': 'INVITATION_STATUS_PENDING',
  'invitedByName': 'Nguyen Van An',
};

Future<FakeApi> pumpInvitations(
  WidgetTester tester,
  FakeApi api, {
  VoidCallback? onAccepted,
}) async {
  api
    ..on('GET /me', (_) => accountJson())
    ..on('GET /me/invitations', (request) {
      expect(
        request.url.queryParameters['status'],
        'INVITATION_STATUS_PENDING',
      );
      return {
        'data': [
          if (api.calls('POST /me/invitations/inv-1/accept').isEmpty)
            invitationJson('inv-1', 'Gara An Phat'),
          if (api.calls('POST /me/invitations/inv-2/decline').isEmpty)
            invitationJson('inv-2', 'Gara Binh Minh'),
        ],
      };
    });
  final overrides = await overridesFor(api, tokens: signedInTokens);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      retry: (_, _) => null,
      child: MaterialApp(
        locale: const Locale('en'),
        supportedLocales: CoreLocalizations.supportedLocales,
        localizationsDelegates: const [
          CoreLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: InvitationsPage(onAccepted: onAccepted),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return api;
}

void main() {
  testWidgets('lists pending invitations, accepts and declines them', (
    tester,
  ) async {
    var accepted = 0;
    final api = FakeApi()
      ..on(
        'POST /me/invitations/inv-1/accept',
        (_) => invitationJson('inv-1', 'Gara An Phat'),
      )
      ..on(
        'POST /me/invitations/inv-2/decline',
        (_) => invitationJson('inv-2', 'Gara Binh Minh'),
      );
    await pumpInvitations(tester, api, onAccepted: () => accepted++);

    expect(find.text('Gara An Phat'), findsOneWidget);
    expect(find.text('Invited by Nguyen Van An'), findsNWidgets(2));

    await tester.tap(find.text('Accept').first);
    await tester.pumpAndSettle();
    expect(find.text('You joined Gara An Phat.'), findsOneWidget);
    expect(accepted, 1);
    expect(find.text('Gara An Phat'), findsNothing);

    await tester.tap(find.text('Decline'));
    await tester.pumpAndSettle();
    expect(api.calls('POST /me/invitations/inv-2/decline'), hasLength(1));
    expect(find.text('No pending invitation.'), findsOneWidget);
    expect(accepted, 1);
  });

  testWidgets('shows the translated refusal of an answer', (tester) async {
    final api = FakeApi()
      ..on(
        'POST /me/invitations/inv-1/accept',
        (_) => FakeResponse.error(409, 'INVITATION_EXPIRED'),
      );
    await pumpInvitations(tester, api);

    await tester.tap(find.text('Accept').first);
    await tester.pumpAndSettle();

    expect(find.text('The invitation expired.'), findsOneWidget);
  });
}
