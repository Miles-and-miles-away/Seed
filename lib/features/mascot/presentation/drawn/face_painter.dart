import 'dart:math' as math;
import 'dart:ui';

import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';

/// Eye and mouth colours for one species.
class FacePalette {
  const FacePalette({
    required this.line,
    required this.iris,
    required this.lidShadow,
    required this.glow,
    required this.pupil,
    required this.mouthInside,
    required this.tongue,
  });

  final Color line;
  final Color iris;
  final Color lidShadow;
  final Color glow;
  final Color pupil;
  final Color mouthInside;
  final Color tongue;
}

/// The shared face: eye design "G, ButtonPupil" and the crescent mouth.
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

  static const double _openingRx = 84;
  static const double _openingRy = 98;
  static const double _eyeLineWidth = 10;

  static const Color _eyeWhite = Color(0xFFFFFBF5);
  static const Offset _eyeCentre = Offset(100, 122);
  static const double _gazeReach = 20;
  static const double _lineWidth = 16;
  static const double _shutBelow = 0.14;
  static const double _tongueFrom = 0.45;

  /// Paints with the origin midway between the eyes.
  void paint(
    Canvas canvas,
    MascotPose pose, {
    required double eyeGap,
    required double mouthDrop,
    required double mouthScale,
  }) {
    for (final side in const [-1.0, 1.0]) {
      final squeeze = side > 0
          ? math.max(pose.smile, pose.wink)
          : pose.smile * (1 - pose.wink);
      final open = pose.eyeOpen * (1 - squeeze);
      canvas
        ..save()
        ..translate(side * eyeGap / 2 - _eyeCentre.dx, -_eyeCentre.dy);
      if (open < _shutBelow) {
        _paintShutEye(canvas, squeeze);
      } else {
        _paintOpenEye(canvas, open, pose.gaze);
      }
      canvas.restore();
    }
    canvas
      ..save()
      ..translate(0, mouthDrop)
      ..scale(mouthScale)
      ..translate(-130, -60);
    _paintMouth(canvas, pose.smile);
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

  void _paintOpenEye(Canvas canvas, double open, Offset gaze) {
    final opening = _oval(_eyeCentre, _openingRx, _openingRy);
    final reach = gaze.distance > 1 ? gaze / gaze.distance : gaze;
    canvas
      ..save()
      ..translate(0, _eyeCentre.dy)
      ..scale(1, open)
      ..translate(0, -_eyeCentre.dy)
      ..drawOval(opening, _fill(_eyeWhite))
      ..save()
      ..clipPath(Path()..addOval(opening))
      ..translate(reach.dx * _gazeReach, reach.dy * _gazeReach)
      ..drawOval(_oval(_eyeCentre, 66, 96), _fill(palette.line))
      ..drawOval(_oval(_eyeCentre, 59, 88), _fill(palette.iris))
      ..drawPath(
        Path()
          ..moveTo(44, 96)
          ..arcToPoint(
            const Offset(156, 96),
            radius: const Radius.elliptical(59, 88),
          )
          ..quadraticBezierTo(100, 122, 44, 96)
          ..close(),
        _fill(palette.lidShadow),
      )
      ..drawOval(_oval(const Offset(100, 182), 32, 14), _fill(palette.glow))
      ..drawOval(_oval(_eyeCentre, 26, 38), _fill(palette.pupil))
      ..drawCircle(const Offset(76, 96), 18, _fill(_eyeWhite))
      ..drawCircle(const Offset(126, 152), 8, _fill(_eyeWhite))
      ..drawCircle(const Offset(118, 98), 5, _fill(_eyeWhite))
      ..restore()
      ..drawOval(opening, _stroke(palette.line, _eyeLineWidth))
      ..restore();
  }

  // A blink rests as a soft downward curve; a smile lifts it into an arch.
  void _paintShutEye(Canvas canvas, double smile) {
    final ends = lerpDouble(126, 138, smile)!;
    final bend = lerpDouble(150, 52, smile)!;
    canvas.drawPath(
      Path()
        ..moveTo(26, ends)
        ..quadraticBezierTo(100, bend, 174, ends),
      _stroke(palette.line, _lineWidth),
    );
  }

  // At rest the floor lies on the lip, so the stroke reads as a crescent.
  void _paintMouth(Canvas canvas, double smile) {
    final lip = lerpDouble(106, 90, smile)!;
    final sideX = lerpDouble(180, 216, smile)!;
    final sideY = lerpDouble(83, 158, smile)!;
    final floor = lerpDouble(83, 166, smile)!;
    final cavity = Path()
      ..moveTo(30, 60)
      ..quadraticBezierTo(130, lip, 230, 60)
      ..quadraticBezierTo(sideX, sideY, 130, floor)
      ..quadraticBezierTo(260 - sideX, sideY, 30, 60)
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
    canvas.drawPath(cavity, _stroke(palette.line, _lineWidth));
  }
}
