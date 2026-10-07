import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietgara_core/vietgara_core.dart';

double _luminance(Color color) {
  double channel(double value) => value <= 0.03928
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}

double _contrast(Color a, Color b) {
  final hi = math.max(_luminance(a), _luminance(b));
  final lo = math.min(_luminance(a), _luminance(b));
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  for (final brightness in Brightness.values) {
    group('${brightness.name} theme', () {
      final theme = buildTheme(brightness);
      final scheme = theme.colorScheme;
      final vg = theme.extension<VgColors>()!;

      test('text pairs reach 4.5:1', () {
        final pairs = <String, (Color, Color)>{
          'onSurface/surface': (scheme.onSurface, scheme.surface),
          'onSurface/background': (scheme.onSurface, vg.background),
          'onSurfaceVariant/surface': (scheme.onSurfaceVariant, scheme.surface),
          'onPrimary/primary': (scheme.onPrimary, scheme.primary),
          'onPrimaryContainer/primaryContainer': (
            scheme.onPrimaryContainer,
            scheme.primaryContainer,
          ),
          'onError/error': (scheme.onError, scheme.error),
          'onErrorContainer/errorContainer': (
            scheme.onErrorContainer,
            scheme.errorContainer,
          ),
          'success': (vg.onSuccessSubtle, vg.successSubtle),
          'warning': (vg.onWarningSubtle, vg.warningSubtle),
          'info': (vg.onInfoSubtle, vg.infoSubtle),
          'destructive': (vg.onDestructiveSubtle, vg.destructiveSubtle),
          'plate': (vg.onPlate, vg.plate),
          'muted/surface': (vg.mutedForeground, scheme.surface),
          'muted/background': (vg.mutedForeground, vg.background),
        };
        pairs.forEach((name, pair) {
          expect(
            _contrast(pair.$1, pair.$2),
            greaterThanOrEqualTo(4.5),
            reason: name,
          );
        });
      });

      test('control outlines reach 3:1', () {
        expect(
          _contrast(scheme.outline, scheme.surface),
          greaterThanOrEqualTo(3),
        );
      });

      test('is built on the bundled font', () {
        expect(theme.textTheme.bodyMedium?.fontFamily, vgFontFamily);
      });
    });
  }

  testWidgets('StatusChip, PlateChip and skeletons render in both themes', (
    tester,
  ) async {
    for (final brightness in Brightness.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(brightness),
          home: const Scaffold(
            body: Column(
              children: [
                StatusChip(label: 'Approved', tone: ChipTone.success),
                PlateChip('51F-123.45'),
                SizedBox(height: 200, child: SkeletonList()),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Approved'), findsOneWidget);
      expect(find.text('51F-123.45'), findsOneWidget);
    }
  });
}
