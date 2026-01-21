import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../sdg/data/sdg_data.dart';

/// CustomPainter that draws the Rainbow Sun visualization.
///
/// The sun consists of:
/// - A central ball that grows based on goal completion (up to 50% screen width)
/// - 17 rays extending to screen edges for each completed SDG category
class RainbowSunPainter extends CustomPainter {
  RainbowSunPainter({
    required this.completionRatio,
    required this.completedSdgs,
    required this.animationValue,
  });

  /// Goal completion ratio (0.0 to 1.0)
  final double completionRatio;

  /// List of completed SDG numbers (1-17)
  final List<int> completedSdgs;

  /// Animation progress (0.0 to 1.0) for smooth transitions
  final double animationValue;

  /// Minimum ball radius as a fraction of max radius
  static const double _minRadiusFraction = 0.2;

  /// Maximum ball radius as a fraction of half the container width
  static const double _maxRadiusFraction = 0.25;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate ball radius
    final maxRadius = size.width * _maxRadiusFraction;
    final minRadius = maxRadius * _minRadiusFraction;
    final currentRadius =
        minRadius + (maxRadius - minRadius) * completionRatio * animationValue;

    // Draw rays first (behind the ball)
    _drawRays(canvas, size, center, currentRadius);

    // Draw the central ball
    _drawBall(canvas, center, currentRadius);
  }

  void _drawBall(Canvas canvas, Offset center, double radius) {
    // Create radial gradient from yellow to orange
    final gradient = RadialGradient(
      colors: [
        const Color(0xFFFFEB3B), // Yellow
        const Color(0xFFFFC107), // Amber
        const Color(0xFFFF9800), // Orange
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    // Draw soft glow around the ball
    final glowPaint = Paint()
      ..color = const Color(0xFFFFEB3B).withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, radius * 1.2, glowPaint);

    // Draw the main ball
    canvas.drawCircle(center, radius, paint);
  }

  void _drawRays(Canvas canvas, Size size, Offset center, double ballRadius) {
    final completedSet = completedSdgs.toSet();

    // Calculate angle for each SDG (17 rays equally spaced)
    // Start from top (-90 degrees or -π/2)
    const startAngle = -math.pi / 2;
    const angleStep = 2 * math.pi / 17;

    for (var sdgNumber = 1; sdgNumber <= 17; sdgNumber++) {
      if (!completedSet.contains(sdgNumber)) continue;

      final angle = startAngle + (sdgNumber - 1) * angleStep;
      final sdgColor = sdgGoals[sdgNumber - 1].color;

      // Calculate ray endpoint (extend to screen edge)
      final endpoint = _calculateRayEndpoint(center, angle, size);

      // Draw the ray
      _drawRay(
        canvas,
        center,
        ballRadius,
        angle,
        endpoint,
        sdgColor,
      );
    }
  }

  void _drawRay(
    Canvas canvas,
    Offset center,
    double ballRadius,
    double angle,
    Offset endpoint,
    Color color,
  ) {
    // Ray starts just outside the ball
    final startRadius = ballRadius + 4;
    final startPoint = Offset(
      center.dx + startRadius * math.cos(angle),
      center.dy + startRadius * math.sin(angle),
    );

    // Create gradient paint that fades out towards the edge
    final rayLength = (endpoint - startPoint).distance;
    final direction = Offset(math.cos(angle), math.sin(angle));

    final gradient = LinearGradient(
      begin: Alignment.center,
      end: Alignment.centerRight,
      colors: [
        color.withValues(alpha: 0.9 * animationValue),
        color.withValues(alpha: 0.4 * animationValue),
        color.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    // Create a path for the ray (tapered shape)
    final rayWidth = 8.0;
    final perpendicular = Offset(-direction.dy, direction.dx);

    final path = Path()
      ..moveTo(
        startPoint.dx + perpendicular.dx * rayWidth / 2,
        startPoint.dy + perpendicular.dy * rayWidth / 2,
      )
      ..lineTo(
        startPoint.dx - perpendicular.dx * rayWidth / 2,
        startPoint.dy - perpendicular.dy * rayWidth / 2,
      )
      ..lineTo(
        endpoint.dx - perpendicular.dx * rayWidth / 4,
        endpoint.dy - perpendicular.dy * rayWidth / 4,
      )
      ..lineTo(
        endpoint.dx + perpendicular.dx * rayWidth / 4,
        endpoint.dy + perpendicular.dy * rayWidth / 4,
      )
      ..close();

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromPoints(startPoint, startPoint + direction * rayLength),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  Offset _calculateRayEndpoint(Offset center, double angle, Size size) {
    // Calculate where the ray intersects the screen boundary
    final dx = math.cos(angle);
    final dy = math.sin(angle);

    // Check intersection with each edge
    double t = double.infinity;

    // Right edge (x = width)
    if (dx > 0) {
      final tRight = (size.width - center.dx) / dx;
      t = math.min(t, tRight);
    }
    // Left edge (x = 0)
    if (dx < 0) {
      final tLeft = -center.dx / dx;
      t = math.min(t, tLeft);
    }
    // Bottom edge (y = height)
    if (dy > 0) {
      final tBottom = (size.height - center.dy) / dy;
      t = math.min(t, tBottom);
    }
    // Top edge (y = 0)
    if (dy < 0) {
      final tTop = -center.dy / dy;
      t = math.min(t, tTop);
    }

    return Offset(center.dx + dx * t, center.dy + dy * t);
  }

  @override
  bool shouldRepaint(RainbowSunPainter oldDelegate) {
    return completionRatio != oldDelegate.completionRatio ||
        !_listEquals(completedSdgs, oldDelegate.completedSdgs) ||
        animationValue != oldDelegate.animationValue;
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
