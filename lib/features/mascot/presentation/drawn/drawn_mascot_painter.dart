import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import 'package:seed_app/features/mascot/presentation/drawn/face_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';

/// Rest positions of the shared rig for one stage, in design units.
///
/// [shoulder] is the screen-right one; the left one mirrors it. A stage
/// with [armLength] 0 has no visible arms. [faceSize] sets the mouth and
/// the line weight, [eyeSize] the eyes alone.
typedef MascotRig = ({
  Offset pivot,
  Offset face,
  Offset top,
  Offset shoulder,
  double armLength,
  double armRest,
  double footX,
  double faceSize,
  double eyeSize,
  double eyeGap,
});

/// A rounded body: [top] and [bottom] on the centre line, widest at [mid].
typedef MascotBody = ({
  double top,
  double mid,
  double bottom,
  double halfWidth,
});

/// [point] near 0.35 gives a seed tip, near 0.6 a round dome.
Path bodyPath(MascotBody body, {double point = 0.35}) {
  const x = DrawnMascotPainter.designSize / 2;
  final (:top, :mid, :bottom, halfWidth: w) = body;
  final upper = top + (mid - top) * 0.49;
  final lower = mid + (bottom - mid) * 0.67;
  return Path()
    ..moveTo(x, top)
    ..cubicTo(x + w * point, top + 1, x + w, upper, x + w, mid)
    ..cubicTo(x + w, lower, x + w * 0.58, bottom, x, bottom)
    ..cubicTo(x - w * 0.58, bottom, x - w, lower, x - w, mid)
    ..cubicTo(x - w, upper, x - w * point, top + 1, x, top)
    ..close();
}

/// The single shade shape of a part: a crescent on its lower right.
Path shadeOf(Path part, [Offset lit = const Offset(-3.5, -5)]) =>
    Path.combine(PathOperation.difference, part, part.shift(lit));

/// One species of the code-drawn generation ("v3"), in a 100 x 100 design
/// box that scales to fit. A stage is a parameter set, not a new drawing.
abstract class DrawnMascotPainter extends CustomPainter {
  const DrawnMascotPainter({required this.stage, required this.pose});

  /// 1 to [stageCount].
  final int stage;
  final MascotPose pose;

  static const int stageCount = 4;
  static const double designSize = 100;
  static const double groundY = 96;
  static const double outlineWidth = 1.5;
  static const double seedShadeAlpha = 0.3;

  static const Color _blush = Color(0x59FC9078);
  static const double _armlessLean = -0.06;
  static const double _gazeTurn = 1.8;
  static const double _restBlush = 0.9;
  static const double _mouthScale = 0.5;
  static const double _mouthDrop = 62;
  static const Offset _kickReach = Offset(2.5, -5);
  static const double _kickTurn = 0.5;
  static const double _hipSeam = 0.5;

  MascotRig get rig;
  MascotBody get body;
  Path get bodyOutline;
  Color get outline;
  FacePalette get facePalette;

  /// Paints what stands on the ground and does not move with the body.
  void paintGround(Canvas canvas);

  /// Paints the body and what grows from it, inside the body transform.
  void paintBody(Canvas canvas);

  // A stage with no arms leans its body where the others raise an arm.
  double get _lean =>
      pose.lean +
      (rig.armLength == 0 ? (pose.armR - pose.armL) * _armlessLean : 0);

  double get _widthScale => 1 - pose.squash * 0.6;

  /// Places the body and what grows from it for [pose]; the feet stay.
  Matrix4 get bodyTransform {
    final pivot = rig.pivot;
    final sink = pose.sink * math.max(groundY - body.bottom, 0);
    return Matrix4.translationValues(pivot.dx, pivot.dy + sink, 0)
      ..rotateZ(_lean)
      ..scaleByDouble(_widthScale, 1 + pose.squash, 1, 1)
      ..translateByDouble(-pivot.dx, -pivot.dy, 0, 1);
  }

  // Halfway from the face to the bottom, so the face never wiggles.
  double get _hipLine => (rig.face.dy + body.bottom) / 2;

  /// Shears the body below the hip line by the pose's hips, inside
  /// [bodyTransform]; the bottom moves the most.
  Matrix4 get hipTransform {
    final shear = pose.hips / (rig.pivot.dy - _hipLine);
    return Matrix4.identity()
      ..setEntry(0, 1, shear)
      ..setEntry(0, 3, -shear * _hipLine);
  }

  Offset _shoulder(double side) =>
      Offset(designSize / 2 + side * rig.shoulder.dx, rig.shoulder.dy);

  /// Rig joints for [pose], for geometry checks and cosmetic anchors.
  MascotJoints get joints {
    final transform = bodyTransform;
    Offset inBody(Offset point) => MatrixUtils.transformPoint(transform, point);
    Offset hand(double side, double raise) {
      final angle = rig.armRest + raise;
      final direction = Offset(side * math.sin(angle), math.cos(angle));
      return inBody(_shoulder(side) + direction * rig.armLength);
    }

    return (
      faceAnchor: inBody(rig.face),
      topAnchor: inBody(rig.top),
      handL: hand(-1, pose.armL),
      handR: hand(1, pose.armR),
      footL: _foot(-1, pose.kickL),
      footR: _foot(1, pose.kickR),
    );
  }

  Offset _foot(double side, double kick) =>
      Offset(designSize / 2 + side * rig.footX, groundY) +
      _kickReach.scale(side * kick, kick);

  /// The outer bounds of both eyes for [pose], before the body transform.
  List<Rect> get eyeBounds {
    final scale =
        rig.eyeSize /
        FacePainter.eyeWidth *
        (1 + FacePainter.wowGrowth * pose.wow);
    final centre = rig.face + pose.gaze * _gazeTurn;
    return [
      for (final side in const [-1.0, 1.0])
        Rect.fromCenter(
          center: centre + Offset(side * rig.eyeGap / 2, 0),
          width: FacePainter.eyeExtent.width * scale,
          height: FacePainter.eyeExtent.height * scale,
        ),
    ];
  }

  Paint fill(Color color) => Paint()..color = color;

  Paint line(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint get outlinePaint => line(outline, outlineWidth);

  /// A filled shape with the outline.
  void part(Canvas canvas, Path path, Color color) => canvas
    ..drawPath(path, fill(color))
    ..drawPath(path, outlinePaint);

  /// Open strokes (stems, twigs, coral) with the outline around them.
  void branch(Canvas canvas, Path path, Color color, double width) => canvas
    ..drawPath(path, line(outline, width + outlineWidth * 2))
    ..drawPath(path, line(color, width));

  Rect oval(Offset centre, double width, double height) =>
      Rect.fromCenter(center: centre, width: width, height: height);

  /// The single highlight shape of a part.
  void paintHighlight(Canvas canvas, Offset centre, Color color) => canvas
    ..save()
    ..translate(centre.dx, centre.dy)
    ..rotate(-0.75)
    ..drawOval(oval(Offset.zero, 9, 4.6), fill(color))
    ..restore();

  void paintBodyHighlight(Canvas canvas, Color color) => paintHighlight(
    canvas,
    Offset(
      designSize / 2 - body.halfWidth * 0.4,
      body.top + (body.mid - body.top) * 0.38,
    ),
    color,
  );

  /// Runs [draw] once per foot, mirrored, with the origin on the ground.
  /// With [kick] the pose can lift each foot up and out.
  void paintFeet(Canvas canvas, VoidCallback draw, {bool kick = false}) {
    for (final (side, amount) in [(-1.0, pose.kickL), (1.0, pose.kickR)]) {
      final k = kick ? amount : 0.0;
      final foot = _foot(side, k);
      canvas
        ..save()
        ..translate(foot.dx, foot.dy)
        ..scale(side, 1)
        ..rotate(-_kickTurn * k);
      draw();
      canvas.restore();
    }
  }

  /// Runs [draw] once per arm, mirrored, with the origin on the shoulder
  /// and the arm along +y.
  void paintArms(Canvas canvas, VoidCallback draw) {
    if (rig.armLength == 0) return;
    for (final (side, raise) in [(-1.0, pose.armL), (1.0, pose.armR)]) {
      final shoulder = _shoulder(side);
      canvas
        ..save()
        ..translate(shoulder.dx, shoulder.dy)
        ..scale(side, 1)
        ..rotate(-(rig.armRest + raise));
      draw();
      canvas.restore();
    }
  }

  /// Runs [draw] rotated about the top anchor by the pose's sway.
  void paintTop(Canvas canvas, VoidCallback draw) {
    canvas
      ..save()
      ..translate(rig.top.dx, rig.top.dy)
      ..rotate(pose.topSway)
      ..translate(-rig.top.dx, -rig.top.dy);
    draw();
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / designSize;
    canvas
      ..save()
      ..translate(
        (size.width - designSize * scale) / 2,
        (size.height - designSize * scale) / 2,
      )
      ..scale(scale);
    paintGround(canvas);
    canvas.transform(bodyTransform.storage);
    if (pose.hips == 0) {
      paintBody(canvas);
    } else {
      _paintWiggle(canvas);
    }
    _paintFace(canvas);
    canvas.restore();
  }

  // Two passes split at the hip line; the top pass overlaps the seam.
  void _paintWiggle(Canvas canvas) {
    const reach = designSize * 2;
    canvas
      ..save()
      ..clipRect(Rect.fromLTRB(-reach, _hipLine, reach, reach))
      ..transform(hipTransform.storage);
    paintBody(canvas);
    canvas
      ..restore()
      ..save()
      ..clipRect(Rect.fromLTRB(-reach, -reach, reach, _hipLine + _hipSeam));
    paintBody(canvas);
    canvas.restore();
  }

  void _paintFace(Canvas canvas) {
    final turn = pose.gaze * _gazeTurn;
    canvas.translate(rig.face.dx + turn.dx, rig.face.dy + turn.dy);
    final blushShare = [pose.smile, pose.wink, _restBlush].reduce(math.max);
    final blush = fill(_blush.withValues(alpha: _blush.a * blushShare));
    for (final side in const [-1.0, 1.0]) {
      canvas.drawOval(
        oval(Offset(side * (rig.eyeGap / 2 + 1.5), 5.5), 6.5, 4),
        blush,
      );
    }
    final faceScale = rig.eyeSize / FacePainter.eyeWidth;
    final faceShare = rig.faceSize / rig.eyeSize;
    canvas.scale(faceScale);
    FacePainter(facePalette).paint(
      canvas,
      pose,
      eyeGap: rig.eyeGap / faceScale,
      mouthDrop: _mouthDrop * faceShare,
      mouthScale: _mouthScale * faceShare,
      lineScale: faceShare,
    );
  }

  @override
  bool shouldRepaint(DrawnMascotPainter oldDelegate) =>
      oldDelegate.stage != stage || !identical(oldDelegate.pose, pose);
}
