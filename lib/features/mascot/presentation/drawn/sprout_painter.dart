import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/face_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';

typedef _Leaf = ({double angle, double length, double width});
typedef _Hem = ({double waist, double toeHeight});

/// Sprout: Seed, Sprout, Sapling, Tree.
class SproutPainter extends DrawnMascotPainter {
  const SproutPainter({required super.stage, super.pose = const MascotPose()});

  static const Color _body = Color(0xFFB57A54);
  static const Color _bodyShade = Color(0xFF9A5F42);
  static const Color _bodyLight = Color(0xFFD9A47C);
  static const Color _limb = Color(0xFFA2664A);
  static const Color _leaf = Color(0xFF82B85A);
  static const Color _leafShade = Color(0xFF62993F);
  static const Color _leafLight = Color(0xFFA9D67C);
  static const Color _petal = Color(0xFFF8A9C8);
  static const Color _pollen = Color(0xFFFFE08A);

  static const FacePalette _facePalette = FacePalette(
    line: Color(0xFF300C00),
    bead: Color(0xFF321406),
    glow: Color(0xFF7FB350),
    mouthInside: Color(0xFF2A0E04),
    tongue: Color(0xFFFC9078),
  );

  static const double _up = -math.pi / 2;
  static const double _stemWidth = 2.4;
  static const double _twigWidth = 3.2;
  static const Size _roundFoot = Size(15, 11.5);

  static const double _toeWidth = 0.7;
  static const double _toeSpread = 0.66;

  static const List<MascotRig> _rigs = [
    (
      pivot: Offset(50, 96),
      face: Offset(50, 79.5),
      top: Offset(50, 56.5),
      shoulder: Offset(16, 80),
      armLength: 0,
      armRest: 0.62,
      footX: 7,
      faceSize: 8.25,
      eyeSize: 6.16,
      eyeGap: 14.9,
    ),
    (
      pivot: Offset(50, 90),
      face: Offset(50, 70),
      top: Offset(50, 40.5),
      shoulder: Offset(19, 69),
      armLength: 14,
      armRest: 0.62,
      footX: 9.5,
      faceSize: 9.375,
      eyeSize: 6.5,
      eyeGap: 16.2,
    ),
    (
      pivot: Offset(50, 90),
      face: Offset(50, 61),
      top: Offset(50, 36.5),
      shoulder: Offset(18, 64),
      armLength: 16,
      armRest: 0.95,
      footX: 10.5,
      faceSize: 9.375,
      eyeSize: 6.25,
      eyeGap: 14.5,
    ),
    (
      pivot: Offset(50, 90),
      face: Offset(50, 62),
      top: Offset(50, 32),
      shoulder: Offset(20.5, 66),
      armLength: 16,
      armRest: 0.95,
      footX: 11.5,
      faceSize: 9.75,
      eyeSize: 6.24,
      eyeGap: 15.3,
    ),
  ];

  // Every stage is wider and taller than the one before it. Stages 1 and
  // 2 are seeds; stages 3 and 4 are trunks.
  static const List<MascotBody> _bodies = [
    (top: 56, mid: 79, bottom: 96, halfWidth: 18),
    (top: 40, mid: 70, bottom: 90, halfWidth: 20.5),
    (top: 36, mid: 62, bottom: 90, halfWidth: 21.5),
    (top: 30, mid: 62, bottom: 90, halfWidth: 27.5),
  ];

  // The sapling's hem is almost straight; the tree's flares into root toes.
  static const List<_Hem> _hems = [
    (waist: 0.91, toeHeight: 0),
    (waist: 0.8, toeHeight: 8),
  ];

  static final List<Path> _bodyPaths = [
    bodyPath(_bodies[0]),
    bodyPath(_bodies[1]),
    _trunkPath(_bodies[2], _hems[0]),
    _trunkPath(_bodies[3], _hems[1]),
  ];

  static final List<Path> _bodyShades = _bodyPaths.map(shadeOf).toList();

  // A domed top, straight sides and a flared hem, with root toes if any.
  static Path _trunkPath(MascotBody body, _Hem hem) {
    const x = DrawnMascotPainter.designSize / 2;
    final (:top, :mid, bottom: toeTip, halfWidth: w) = body;
    final s = w * hem.waist;
    final bottom = toeTip - hem.toeHeight / 2;
    final trunk = Path()
      ..moveTo(x, top)
      ..cubicTo(x + s * 0.55, top, x + s, top + s * 0.45, x + s, top + s)
      ..cubicTo(x + s * 0.93, mid, x + s * 0.98, bottom - 9, x + w, bottom - 3)
      ..cubicTo(x + w * 0.9, bottom, x + w * 0.4, bottom, x, bottom)
      ..cubicTo(x - w * 0.4, bottom, x - w * 0.9, bottom, x - w, bottom - 3)
      ..cubicTo(x - s * 0.98, bottom - 9, x - s * 0.93, mid, x - s, top + s)
      ..cubicTo(x - s, top + s * 0.45, x - s * 0.55, top, x, top)
      ..close();
    if (hem.toeHeight == 0) return trunk;
    return const [-1.0, 0.0, 1.0].fold(
      trunk,
      (path, side) => Path.combine(
        PathOperation.union,
        path,
        Path()..addOval(
          Rect.fromCenter(
            center: Offset(x + side * w * _toeSpread, bottom),
            width: w * _toeWidth,
            height: hem.toeHeight,
          ),
        ),
      ),
    );
  }

  // The tree's canopy replaces the stem, so it has no tip and no leaves.
  static const List<Offset?> _stemTips = [
    Offset(50.4, 52.5),
    Offset(50.6, 32),
    Offset(50, 30),
    null,
  ];

  static const List<List<_Leaf>> _leaves = [
    [(angle: -0.9, length: 8, width: 3.4)],
    [
      (angle: -2.5, length: 16.5, width: 6.2),
      (angle: -0.8, length: 19.5, width: 7.2),
    ],
    [
      (angle: _up - 1.3, length: 17, width: 5.2),
      (angle: _up + 1.3, length: 17, width: 5.2),
      (angle: _up - 0.65, length: 20, width: 5.6),
      (angle: _up + 0.65, length: 20, width: 5.6),
      (angle: _up, length: 22, width: 5.8),
    ],
    [],
  ];

  static const List<(double, double, double)> _canopyLobes = [
    (50, 24, 20),
    (27, 32, 15),
    (73, 32, 15),
    (36, 16, 13),
    (64, 16, 13),
  ];

  static final Path _canopy = _canopyLobes.fold(
    Path(),
    (path, lobe) => Path.combine(
      PathOperation.union,
      path,
      Path()..addOval(
        Rect.fromCircle(center: Offset(lobe.$1, lobe.$2), radius: lobe.$3),
      ),
    ),
  );

  static final Path _canopyShade = shadeOf(_canopy);

  static const List<Offset> _blossoms = [
    Offset(24, 33),
    Offset(42, 14),
    Offset(62, 26),
    Offset(77, 35),
  ];

  static final Path _foot = Path()
    ..addOval(
      Rect.fromCenter(
        center: Offset(0, -_roundFoot.height / 2),
        width: _roundFoot.width,
        height: _roundFoot.height,
      ),
    );

  @override
  MascotRig get rig => _rigs[stage - 1];

  @override
  MascotBody get body => _bodies[stage - 1];

  @override
  Path get bodyOutline => _bodyPaths[stage - 1];

  @override
  Color get outline => const Color(0xFF3A1408);

  @override
  FacePalette get facePalette => _facePalette;

  @override
  void paintGround(Canvas canvas) {
    if (stage == 1) return;
    paintFeet(canvas, () => part(canvas, _foot, _limb));
  }

  @override
  void paintBody(Canvas canvas) {
    final path = bodyOutline;
    paintArms(canvas, () => _paintArm(canvas));
    paintTop(canvas, () => _paintStem(canvas));
    canvas
      ..drawPath(path, fill(_body))
      ..drawPath(
        _bodyShades[stage - 1],
        fill(
          stage == 1
              ? _bodyShade.withValues(alpha: DrawnMascotPainter.seedShadeAlpha)
              : _bodyShade,
        ),
      );
    paintBodyHighlight(canvas, _bodyLight);
    canvas.drawPath(path, outlinePaint);
    if (stage == 4) paintTop(canvas, () => _paintCanopy(canvas));
  }

  void _paintArm(Canvas canvas) {
    final length = rig.armLength;
    if (stage == 2) {
      part(
        canvas,
        Path()..addOval(oval(Offset(0, length / 2), 7.8, length)),
        _limb,
      );
      return;
    }
    branch(
      canvas,
      Path()
        ..moveTo(0, 0)
        ..lineTo(0, length),
      _limb,
      _twigWidth,
    );
    _paintLeaf(canvas, Offset(0, length - 3.5), (
      angle: -0.25,
      length: 8.5,
      width: 3.6,
    ));
  }

  void _paintStem(Canvas canvas) {
    final tip = _stemTips[stage - 1];
    if (tip == null) return;
    final top = rig.top;
    final stem = Path()
      ..moveTo(top.dx, top.dy + 1.5)
      ..quadraticBezierTo(top.dx - 0.6, (top.dy + tip.dy) / 2, tip.dx, tip.dy);
    canvas.drawPath(
      stem,
      line(outline, _stemWidth + DrawnMascotPainter.outlineWidth * 2),
    );
    for (final leaf in _leaves[stage - 1]) {
      _paintLeaf(canvas, tip, leaf);
    }
    canvas.drawPath(stem, line(_leafShade, _stemWidth));
  }

  void _paintLeaf(Canvas canvas, Offset from, _Leaf leaf) {
    final length = leaf.length;
    final width = leaf.width;
    final lower = Path()
      ..moveTo(length, 0)
      ..cubicTo(length, width * 1.1, length * 0.3, width * 1.25, 0, 0);
    final blade = Path()
      ..moveTo(0, 0)
      ..cubicTo(length * 0.3, -width * 1.25, length, -width * 1.1, length, 0)
      ..extendWithPath(lower, Offset.zero);
    final shade = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(length / 2, -width * 0.2, length, 0)
      ..extendWithPath(lower, Offset.zero);
    canvas
      ..save()
      ..translate(from.dx, from.dy)
      ..rotate(leaf.angle)
      // The shade stays on the lower side of a leaf that points left.
      ..scale(1, math.cos(leaf.angle) < 0 ? -1 : 1)
      ..drawPath(blade, fill(_leaf))
      ..drawPath(shade, fill(_leafShade))
      ..drawPath(blade, outlinePaint)
      ..restore();
  }

  void _paintCanopy(Canvas canvas) {
    canvas
      ..drawPath(_canopy, fill(_leaf))
      ..drawPath(_canopyShade, fill(_leafShade));
    paintHighlight(canvas, const Offset(34, 14), _leafLight);
    canvas.drawPath(_canopy, outlinePaint);
    for (final blossom in _blossoms) {
      part(canvas, Path()..addOval(oval(blossom, 5.6, 5.6)), _petal);
      canvas.drawCircle(blossom, 1.1, fill(_pollen));
    }
  }
}
