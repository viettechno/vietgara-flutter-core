import 'package:flutter/material.dart';

import '../theme.dart';

/// The vehicle's license plate: the product's recurring identity element
/// (Design System 1.2). White plate, ink border, monospace capitals.
class PlateChip extends StatelessWidget {
  const PlateChip(this.plate, {super.key, this.large = false});

  final String plate;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final vg = context.vg;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 10 : 6,
        vertical: large ? 3 : 1,
      ),
      decoration: BoxDecoration(
        color: vg.plate,
        borderRadius: BorderRadius.circular(VgRadius.sm),
        border: Border.all(color: vg.onPlate, width: 1.5),
      ),
      child: Text(
        plate,
        semanticsLabel: plate,
        style: TextStyle(
          fontFamily: vgMonoFamily,
          fontVariations: const [FontVariation.weight(500)],
          fontSize: large ? 16 : 12,
          height: 1.3,
          letterSpacing: 0.04 * (large ? 16 : 12),
          color: vg.onPlate,
        ),
      ),
    );
  }
}

/// A block that shimmers while content loads. Static when the platform
/// asks to reduce motion.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 14,
    this.radius = VgRadius.sm,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.surfaceContainerHighest;
    final highlight = context.vg.border;
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + _controller.value * 3, 0),
              end: Alignment(_controller.value * 3, 0),
              colors: [base, highlight, base],
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder rows shaped like the list that is loading.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key});

  static const rows = 6;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
    child: ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(width: 120 + (index % 3) * 40),
                  const SizedBox(height: 8),
                  Skeleton(width: 180 + (index % 2) * 50, height: 12),
                ],
              ),
            ),
            const Skeleton(width: 56, height: 22),
          ],
        ),
      ),
    ),
  );
}

/// A small duotone illustration for empty and error states (decorative).
class VgIllustration extends StatelessWidget {
  const VgIllustration({super.key, this.error = false});

  final bool error;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final vg = context.vg;
    return ExcludeSemantics(
      child: SizedBox(
        width: 120,
        height: 90,
        child: CustomPaint(
          painter: _IllustrationPainter(
            line: error ? vg.warning : scheme.primary,
            fill: error ? vg.warningSubtle : scheme.primaryContainer,
            ground: scheme.surfaceContainerHighest,
            wheel: scheme.surface,
            error: error,
          ),
        ),
      ),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  _IllustrationPainter({
    required this.line,
    required this.fill,
    required this.ground,
    required this.wheel,
    required this.error,
  });

  final Color line;
  final Color fill;
  final Color ground;
  final Color wheel;
  final bool error;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final solid = Paint()..color = fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(8, 66, 104, 6),
        const Radius.circular(3),
      ),
      Paint()..color = ground,
    );
    if (error) {
      final triangle = Path()
        ..moveTo(60, 14)
        ..lineTo(98, 62)
        ..lineTo(22, 62)
        ..close();
      canvas.drawPath(triangle, solid);
      canvas.drawPath(triangle, stroke..strokeWidth = 3);
      canvas.drawLine(const Offset(60, 32), const Offset(60, 46), stroke);
      canvas.drawCircle(const Offset(60, 54), 2.5, Paint()..color = line);
      return;
    }
    final body = Path()
      ..moveTo(22, 60)
      ..lineTo(22, 46)
      ..lineTo(30, 32)
      ..quadraticBezierTo(31, 29, 35, 29)
      ..lineTo(85, 29)
      ..quadraticBezierTo(89, 29, 90, 32)
      ..lineTo(98, 46)
      ..lineTo(98, 60)
      ..close();
    canvas.drawPath(body, solid);
    canvas.drawPath(body, stroke);
    canvas.drawLine(
      const Offset(33, 46),
      const Offset(87, 46),
      stroke..color = line.withValues(alpha: 0.5),
    );
    stroke.color = line;
    for (final x in const [40.0, 80.0]) {
      canvas.drawCircle(Offset(x, 60), 7, Paint()..color = wheel);
      canvas.drawCircle(Offset(x, 60), 7, stroke);
    }
  }

  @override
  bool shouldRepaint(_IllustrationPainter old) =>
      old.line != line || old.fill != fill || old.error != error;
}
