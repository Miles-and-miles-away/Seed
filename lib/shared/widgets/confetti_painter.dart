import 'dart:math';

import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// A single confetti particle. Position is normalized 0..1 and mutated as
/// the particle falls, so reuse the same list across repaints.
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

  /// A random particle starting just above the top edge.
  ///
  /// [colorCount] must match the palette length passed to
  /// [ConfettiPainter.colors] for an even color distribution.
  factory ConfettiParticle.random({int colorCount = 5}) {
    final random = Random();
    return ConfettiParticle(
      x: random.nextDouble(),
      y: -random.nextDouble() * 0.5, // Start above screen
      size: random.nextDouble() * 10 + 5,
      speed: random.nextDouble() * 0.5 + 0.3,
      colorIndex: random.nextInt(colorCount),
      rotation: random.nextDouble() * pi * 2,
      rotationSpeed: (random.nextDouble() - 0.5) * 0.2,
      shape: random.nextInt(3), // 0: rect, 1: circle, 2: star
    );
  }

  final double x;
  double y;
  final double size;
  final double speed;
  final int colorIndex;
  double rotation;
  final double rotationSpeed;
  final int shape;
}

/// Paints falling, rotating confetti as rectangles, circles, and stars.
///
/// Advances each particle on every paint, so drive it from an animation that
/// repaints continuously (it always reports [shouldRepaint] true).
class ConfettiPainter extends CustomPainter {
  ConfettiPainter({required this.particles, required this.colors});

  final List<ConfettiParticle> particles;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Update particle position and rotation
      particle
        ..y += particle.speed * 0.02
        ..rotation += particle.rotationSpeed;

      // Reset if past bottom
      if (particle.y > 1.2) {
        particle.y = -0.1;
      }

      final x = particle.x * size.width;
      final y = particle.y * size.height;

      // Modulo so palettes shorter than the random colorIndex range
      // (nextInt(5) above) cannot index out of bounds.
      final paint = Paint()
        ..color = colors[particle.colorIndex % colors.length].withValues(
          alpha: opacityHeavy,
        );

      canvas
        ..save()
        ..translate(x, y)
        ..rotate(particle.rotation);

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
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) => true;
}
