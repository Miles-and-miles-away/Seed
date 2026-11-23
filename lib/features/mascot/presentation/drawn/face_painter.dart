import 'dart:math' as math;
import 'dart:ui';

import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';

/// Eye and mouth colours for one species.
class FacePalette {
  const FacePalette({
    required this.line,
    required this.bead,
    required this.glow,
    required this.mouthInside,
    required this.tongue,
  });

  final Color line;
  final Color bead;
  final Color glow;
  final Color mouthInside;
  final Color tongue;
}

/// The shared face: solid bead eyes and the crescent mouth.
///
/// Geometry is in face units. One eye is [eyeWidth] units wide, and the
/// caller scales the canvas so that the face fits its species.
class FacePainter {
  const FacePainter(this.palette);

  final FacePalette palette;

  static const double eyeWidth = 176;

  /// The outer size of one open eye, line included.
  static const Size eyeExtent = Size(
    (_openingRx + _eyeLineWidth / 2) * 2,
    (_openingRy + _eyeLineWidth / 2) * 2,
  );

  /// How much the eyes grow at full [MascotPose.wow].
  static const double wowGrowth = 0.12;

  static const double _openingRx = 82;
  static const double _openingRy = 88;
  static const double _eyeLineWidth = 10;

  static const Color _eyeWhite = Color(0xFFFFFBF5);
  static const Offset _eyeCentre = Offset(100, 122);
  static const double _gazeReach = 20;
  static const double _converge = 5;
  static const double _glowAlpha = 0.55;
  static const double _lineWidth = 22.4;
  static const double _shutBelow = 0.14;
  static const double _tongueFrom = 0.45;

  /// Paints with the origin midway between the eyes.
  void paint(
    Canvas canvas,
    MascotPose pose, {
    required double eyeGap,
    required double mouthDrop,
    required double mouthScale,
    required double lineScale,
  }) {
    final line = _stroke(palette.line, _lineWidth * lineScale);
    for (final side in const [-1.0, 1.0]) {
      final squeeze = side > 0
          ? math.max(pose.smile, pose.wink)
          : pose.smile * (1 - pose.wink);
      final open = pose.eyeOpen * (1 - squeeze);
      canvas
        ..save()
        ..translate(side * eyeGap / 2 - _eyeCentre.dx, -_eyeCentre.dy);
      if (open < _shutBelow) {
        _paintShutEye(canvas, squeeze, line);
      } else {
        _paintOpenEye(canvas, open, 1 + wowGrowth * pose.wow, pose.gaze, side);
      }
      canvas.restore();
    }
    canvas
      ..save()
      ..translate(0, mouthDrop)
      ..scale(mouthScale)
      ..translate(-130, -60);
    _paintMouth(canvas, pose.smile, pose.wow, line);
    canvas.restore();
  }

  Paint _fill(Color color) => Paint()..color = color;

  Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Rect _oval(Offset centre, double rx, double ry) =>
      Rect.fromCenter(center: centre, width: rx * 2, height: ry * 2);

  // The beads rest turned slightly inward, towards the mouth.
  void _paintOpenEye(
    Canvas canvas,
    double open,
    double grow,
    Offset gaze,
    double side,
  ) {
    final opening = _oval(_eyeCentre, _openingRx, _openingRy);
    final reach = gaze.distance > 1 ? gaze / gaze.distance : gaze;
    canvas
      ..save()
      ..translate(_eyeCentre.dx, _eyeCentre.dy)
      ..scale(grow, grow * open)
      ..translate(-_eyeCentre.dx, -_eyeCentre.dy)
      ..drawOval(opening, _fill(_eyeWhite))
      ..save()
      ..clipPath(Path()..addOval(opening))
      ..translate(
        reach.dx * _gazeReach - side * _converge,
        reach.dy * _gazeReach,
      )
      ..drawOval(_oval(_eyeCentre, 76, 86), _fill(palette.bead))
      ..drawOval(
        _oval(const Offset(100, 180.5), 41, 14),
        _fill(palette.glow.withValues(alpha: _glowAlpha)),
      )
      ..drawCircle(const Offset(72, 92), 28, _fill(_eyeWhite))
      ..drawCircle(const Offset(126, 154), 14, _fill(_eyeWhite))
      ..restore()
      ..drawOval(opening, _stroke(palette.line, _eyeLineWidth))
      ..restore();
  }

  // A blink rests as a soft downward curve; a smile lifts it into an arch.
  void _paintShutEye(Canvas canvas, double smile, Paint line) {
    final ends = lerpDouble(126, 138, smile)!;
    final bend = lerpDouble(150, 52, smile)!;
    canvas.drawPath(
      Path()
        ..moveTo(26, ends)
        ..quadraticBezierTo(100, bend, 174, ends),
      line,
    );
  }

  // At rest the floor lies on the lip, so the stroke reads as a crescent.
  // Wow pulls the corners in and the lip up into a small round "o".
  void _paintMouth(Canvas canvas, double smile, double wow, Paint line) {
    double mix(double rest, double smiling, double round) =>
        lerpDouble(lerpDouble(rest, smiling, smile), round, wow)!;
    final corner = mix(30, 30, 85);
    final lip = mix(106, 90, -10);
    final sideX = mix(180, 216, 185);
    final sideY = mix(83, 158, 125);
    final floor = mix(83, 166, 135);
    final cavity = Path()
      ..moveTo(corner, 60)
      ..quadraticBezierTo(130, lip, 260 - corner, 60)
      ..quadraticBezierTo(sideX, sideY, 130, floor)
      ..quadraticBezierTo(260 - sideX, sideY, corner, 60)
      ..close();
    canvas.drawPath(cavity, _fill(palette.mouthInside));
    if (smile > _tongueFrom) {
      canvas
        ..save()
        ..clipPath(cavity)
        ..translate(0, floor - 166)
        ..drawPath(
          Path()
            ..moveTo(82, 148)
            ..quadraticBezierTo(130, 118, 178, 148)
            ..quadraticBezierTo(154, 164, 130, 164)
            ..quadraticBezierTo(106, 164, 82, 148)
            ..close(),
          _fill(palette.tongue),
        )
        ..restore();
    }
    canvas.drawPath(cavity, line);
  }
}
