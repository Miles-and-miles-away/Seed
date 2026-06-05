import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/theme/app_colors.dart';

/// CustomPainter that draws the Rainbow Sun visualization.
///
/// The sun consists of:
/// - A central ball that grows based on goal completion
/// - 17 evenly-spaced bar segments forming a ring around the sun
/// - 17 rays extending to screen edges for each completed SDG category
class RainbowSunPainter extends CustomPainter {
  RainbowSunPainter({
    required this.completionRatio,
    required this.completedSdgs,
    required this.animationValue,
    required this.sdgColors,
  });

  /// Goal completion ratio (0.0 to 1.0)
  final double completionRatio;

  /// List of completed SDG numbers (1-17)
  final List<int> completedSdgs;

  /// Animation progress (0.0 to 1.0) for smooth transitions
  final double animationValue;

  /// SDG colors indexed 0-16 for goals 1-17
  final List<Color> sdgColors;

  /// Minimum ball radius as a fraction of max radius
  static const double _minRadiusFraction = 0.2;

  /// Maximum ball radius as a fraction of half the container width
  static const double _maxRadiusFraction = 0.25;

  /// Each SDG gets exactly 360/17 degrees
  static const double _angleStep = 2 * math.pi / 17;

  /// Start from top (-90 degrees or -π/2)
  static const double _startAngle = -math.pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate ball radius
    final maxRadius = size.width * _maxRadiusFraction;
    final minRadius = maxRadius * _minRadiusFraction;
    final currentRadius =
        minRadius + (maxRadius - minRadius) * completionRatio * animationValue;

    // Draw rays first (behind everything)
    _drawRays(canvas, size, center, currentRadius);

    // Draw the bar segments (ring around the sun)
    _drawBarSegments(canvas, center, currentRadius);

    // Draw the central ball on top
    _drawBall(canvas, center, currentRadius);
  }

  void _drawBall(Canvas canvas, Offset center, double radius) {
    // Create radial gradient from yellow to orange
    final gradient = RadialGradient(
      colors: [
        AppColors.sunYellow,
        AppColors.sunAmber,
        AppColors.sunOrange,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    // Draw soft glow around the ball using a gradient instead of blur
    // (MaskFilter.blur causes Impeller crashes on iOS)
    final glowGradient = RadialGradient(
      colors: [
        AppColors.sunYellow.withValues(
          alpha: opacityMuted,
        ),
        AppColors.sunYellow.withValues(alpha: 0),
      ],
    );
    final glowPaint = Paint()
      ..shader = glowGradient.createShader(
        Rect.fromCircle(center: center, radius: radius * 1.5),
      );

    // Draw the main ball
    canvas
      ..drawCircle(center, radius * 1.5, glowPaint)
      ..drawCircle(center, radius, paint);
  }

  void _drawBarSegments(Canvas canvas, Offset center, double ballRadius) {
    final completedSet = completedSdgs.toSet();

    // Bar segment dimensions
    final innerRadius = ballRadius + 8; // Gap from ball
    final outerRadius = ballRadius + 40; // Bar thickness of 32

    for (var sdgNumber = 1; sdgNumber <= 17; sdgNumber++) {
      final isCompleted = completedSet.contains(sdgNumber);
      final sdgColor = sdgColors[sdgNumber - 1];

      // Calculate start angle for this segment
      final segmentStartAngle = _startAngle + (sdgNumber - 1) * _angleStep;

      // Draw the arc segment
      _drawArcSegment(
        canvas,
        center,
        innerRadius,
        outerRadius,
        segmentStartAngle,
        _angleStep,
        isCompleted ? sdgColor : sdgColor.withValues(alpha: opacitySubtle),
        isCompleted,
      );
    }
  }

  void _drawArcSegment(
    Canvas canvas,
    Offset center,
    double innerRadius,
    double outerRadius,
    double startAngle,
    double sweepAngle,
    Color color,
    bool isCompleted,
  ) {
    // Apply animation to completed segments
    final animatedOuterRadius = isCompleted
        ? innerRadius + (outerRadius - innerRadius) * animationValue
        : outerRadius;

    final animatedColor =
        isCompleted ? color.withValues(alpha: color.a * animationValue) : color;

    // Create path for the arc segment (pie slice with hole)
    final innerEndAngle = startAngle + sweepAngle - 0.02;
    final path = Path()
      // Outer arc
      ..arcTo(
        Rect.fromCircle(center: center, radius: animatedOuterRadius),
        startAngle,
        sweepAngle - 0.02, // Tiny gap between segments for visual separation
        true,
      )
      // Line to inner arc end point
      ..lineTo(
        center.dx + innerRadius * math.cos(innerEndAngle),
        center.dy + innerRadius * math.sin(innerEndAngle),
      )
      // Inner arc (reverse direction)
      ..arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        innerEndAngle,
        -(sweepAngle - 0.02),
        false,
      )
      ..close();

    final paint = Paint()
      ..color = animatedColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  void _drawRays(Canvas canvas, Size size, Offset center, double ballRadius) {
    final completedSet = completedSdgs.toSet();

    // Rays start from outside the bar segments
    final rayStartRadius = ballRadius + 48;

    for (var sdgNumber = 1; sdgNumber <= 17; sdgNumber++) {
      if (!completedSet.contains(sdgNumber)) continue;

      // Ray is centered in the middle of its segment
      final segmentCenterAngle =
          _startAngle + (sdgNumber - 1) * _angleStep + _angleStep / 2;
      final sdgColor = sdgColors[sdgNumber - 1];

      // Calculate ray endpoint (extend to screen edge)
      final endpoint = _calculateRayEndpoint(center, segmentCenterAngle, size);

      // Draw the ray
      _drawRay(
        canvas,
        center,
        rayStartRadius,
        segmentCenterAngle,
        endpoint,
        sdgColor,
      );
    }
  }

  void _drawRay(
    Canvas canvas,
    Offset center,
    double startRadius,
    double angle,
    Offset endpoint,
    Color color,
  ) {
    final startPoint = Offset(
      center.dx + startRadius * math.cos(angle),
      center.dy + startRadius * math.sin(angle),
    );

    // Create gradient paint that fades out towards the edge
    final rayLength = (endpoint - startPoint).distance;
    final direction = Offset(math.cos(angle), math.sin(angle));

    final gradient = LinearGradient(
      colors: [
        color.withValues(
          alpha: opacityStrong * animationValue,
        ),
        color.withValues(
          alpha: opacityMuted * animationValue,
        ),
        color.withValues(alpha: 0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    // Create a path for the ray (tapered shape)
    // Width based on segment angle for even visual spacing
    const rayWidth = 10.0;
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
    var t = double.infinity;

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
