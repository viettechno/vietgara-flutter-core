import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietgara_core/vietgara_core.dart';

String _asset(WidgetTester tester) {
  final image = tester.widget<Image>(find.byType(Image));
  return (image.image as AssetImage).keyName;
}

Widget _app(Brightness brightness, Widget child) => MaterialApp(
  theme: ThemeData(brightness: brightness),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('VgLogo shows the lockup that fits the theme', (tester) async {
    await tester.pumpWidget(_app(Brightness.light, const VgLogo()));
    expect(_asset(tester), 'packages/vietgara_core/assets/brand/logo.webp');

    await tester.pumpWidget(_app(Brightness.dark, const VgLogo()));
    await tester.pumpAndSettle(); // the theme animates to the new brightness
    expect(
      _asset(tester),
      'packages/vietgara_core/assets/brand/logo-dark.webp',
    );
  });

  testWidgets('VgLogo with mark shows the glyph alone', (tester) async {
    await tester.pumpWidget(_app(Brightness.light, const VgLogo(mark: true)));
    expect(_asset(tester), 'packages/vietgara_core/assets/brand/mark.webp');
    expect(find.bySemanticsLabel('VietGara'), findsOneWidget);
  });
}
