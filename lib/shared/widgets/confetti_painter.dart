import 'dart:math';

import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// Repaints [painter] every frame of a looping [durationParticleLoop]
/// controller, passing the loop progress (0..1). Isolated in its own
/// [RepaintBoundary] so the continuous repaint does not invalidate the
/// rest of the celebration (Impeller).
class ConfettiLayer extends StatefulWidget {
  const ConfettiLayer({
    required this.painter,
    this.animating = true,
    super.key,
  });

  final CustomPainter Function(double progress) painter;

  /// False once the layer has faded out, so it stops repainting.
  final bool animating;

  @override
  State<ConfettiLayer> createState() => _ConfettiLayerState();
}

class _ConfettiLayerState extends State<ConfettiLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: durationParticleLoop,
    );
    if (widget.animating) _controller.repeat();
  }

  @override
  void didUpdateWidget(ConfettiLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating == oldWidget.animating) return;
    if (widget.animating) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: widget.painter(_controller.value),
        ),
      ),
    );
  }
}

/// A single confetti particle. Every field is a fixed seed; the painter
/// derives position from loop progress, so reuse the list across repaints.
class ConfettiParticle {
  ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.colorIndex,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
  });

  /// A random particle at a random point in its fall.
  ///
  /// [colorCount] must match the palette length passed to
  /// [ConfettiPainter.colors] for an even color distribution.
  factory ConfettiParticle.random({int colorCount = 5}) {
    return ConfettiParticle(
      x: _rng.nextDouble(),
      y: _yStart + _rng.nextDouble() * _ySpan,
      size: _rng.nextDouble() * 10 + 5,
      speed: _rng.nextDouble() * 0.5 + 0.3,
      colorIndex: _rng.nextInt(colorCount),
      rotation: _rng.nextDouble() * pi * 2,
      rotationSpeed: (_rng.nextDouble() - 0.5) * 0.2,
      shape: _rng.nextInt(3), // 0: rect, 1: circle, 2: star
    );
  }

  static final _rng = Random();

  final double x;
  final double y;
  final double size;
  final double speed;
  final int colorIndex;
  final double rotation;
  final double rotationSpeed;
  final int shape;

  /// Whole fall cycles per loop, so a particle lands back on its own
  /// start at progress 1 and the loop seam stays invisible.
  int get fallCycles =>
      max(1, (speed * _fallPerSecond * _loopSeconds / _ySpan).round());

  /// Whole turns per loop, for the same reason.
  int get spinTurns =>
      (rotationSpeed * _spinPerSecond * _loopSeconds / (pi * 2)).round();
}

// The legacy per-frame step assumed 60Hz: y += speed * 0.02 and
// rotation += rotationSpeed each frame.
const double _fallPerSecond = 0.02 * 60;
const double _spinPerSecond = 60;
const double _yStart = -0.1;
const double _ySpan = 1.3;
final double _loopSeconds = durationParticleLoop.inMilliseconds / 1000;

/// Paints falling, rotating confetti as rectangles, circles, and stars.
///
/// Every position derives from [progress] (0..1 over one loop) rather
/// than from a per-paint mutation, so the fall speed is the same on a
/// 60Hz and a 120Hz display and an extra repaint cannot advance it.
class ConfettiPainter extends CustomPainter {
  ConfettiPainter({
    required this.particles,
    required this.colors,
    required this.progress,
  });

  final List<ConfettiParticle> particles;
  final List<Color> colors;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final fallen =
          particle.y + progress * particle.fallCycles * _ySpan - _yStart;
      final rotation =
          particle.rotation + progress * particle.spinTurns * pi * 2;

      final x = particle.x * size.width;
      final y = (_yStart + fallen % _ySpan) * size.height;

      // Modulo so palettes shorter than the random colorIndex range
      // (nextInt(5) above) cannot index out of bounds.
      final paint = Paint()
        ..color = colors[particle.colorIndex % colors.length].withValues(
          alpha: opacityHeavy,
        );

      canvas
        ..save()
        ..translate(x, y)
        ..rotate(rotation);

      switch (particle.shape) {
        case 0: // Rectangle
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.6,
            ),
            paint,
          );
        case 1: // Circle
          canvas.drawCircle(Offset.zero, particle.size * 0.5, paint);
        case 2: // Star
          _drawStar(canvas, particle.size * 0.5, paint);
      }

      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, double radius, Paint paint) {
    final path = Path();
    const points = 5;
    const innerRadius = 0.4;

    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius * innerRadius;
      final angle = (i * pi / points) - (pi / 2);
      final x = r * cos(angle);
      final y = r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.particles != particles ||
      oldDelegate.colors != colors;
}
