import 'package:material_ui/material_ui.dart';

/// The VietGara logo: the stacked lockup (the glyph over the name), or with
/// [mark] the glyph alone. The light files have dark ink and the dark ones
/// white, so the one that fits the theme's brightness is shown.
class VgLogo extends StatelessWidget {
  const VgLogo({super.key, this.height = 72, this.mark = false});

  /// The height of the image; its width follows.
  final double height;

  /// Show only the V-and-wrench glyph.
  final bool mark;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final name = mark ? 'mark' : 'logo';
    return Image.asset(
      'assets/brand/$name${dark ? '-dark' : ''}.webp',
      package: 'vietgara_core',
      height: height,
      semanticLabel: 'VietGara',
    );
  }
}
