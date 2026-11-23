import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/face_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';

typedef _Branch = ({double angle, double length, int forks, double width});
typedef _Fish = ({Offset centre, double facing});
typedef _Tube = ({Offset centre, Size size, double turn});

/// Coral: Polyp, Colony, Reef, Ecosystem.
class CoralPainter extends DrawnMascotPainter {
  const CoralPainter({required super.stage, super.pose = const MascotPose()});

  static const Color _body = Color(0xFFB3A4F5);
  static const Color _bodyShade = Color(0xFF9685E3);
  static const Color _bodyLight = Color(0xFFDDD5FD);
  static const Color _limb = Color(0xFF9F8EEA);
  static const Color _fringe = Color(0xFF6FD6DC);
  static const Color _fringeShade = Color(0xFF48B9C4);
  static const Color _coral = Color(0xFFFF8F6E);
  static const Color _sponge = Color(0xFFFFD166);
  static const Color _spongeShade = Color(0xFFEBA83C);
  static const Color _grass = Color(0xFF5DBB6E);

  static const FacePalette _facePalette = FacePalette(
    line: Color(0xFF1A2348),
    bead: Color(0xFF1C3464),
    glow: Color(0xFF6FD0E0),
    mouthInside: Color(0xFF2A1238),
    tongue: Color(0xFFFF9C9C),
  );

  static const double _forkTurn = 0.8;
  static const double _forkAt = 0.5;
  static const double _forkLength = 0.6;
  static const double _fringeHeight = 0.55;
  static const double _grassWidth = 3.6;
  static const double _fishBob = 14;
  static const double _swimLegSeconds = 6;
  static const double _swimTurn = 0.1;
  static const double _hideTurn = 0.25;
  static const Size _footSize = Size(13, 10);

  static const List<MascotRig> _rigs = [
    (
      pivot: Offset(50, 96),
      face: Offset(50, 79),
      top: Offset(50, 62.5),
      shoulder: Offset(20, 82),
      armLength: 0,
      armRest: 1,
      footX: 9,
      faceSize: 9.375,
      eyeSize: 7,
      eyeGap: 18.1,
    ),
    (
      pivot: Offset(50, 90),
      face: Offset(50, 68.5),
      top: Offset(50, 50.5),
      shoulder: Offset(23.5, 70),
      armLength: 11,
      armRest: 1,
      footX: 10.5,
      faceSize: 10.125,
      eyeSize: 7.29,
      eyeGap: 19.6,
    ),
    (
      pivot: Offset(50, 90),
      face: Offset(50, 65.5),
      top: Offset(50, 44.5),
      shoulder: Offset(26, 67.5),
      armLength: 13,
      armRest: 1.05,
      footX: 11.5,
      faceSize: 10.5,
      eyeSize: 7.28,
      eyeGap: 21.1,
    ),
    (
      pivot: Offset(50, 90),
      face: Offset(50, 62.5),
      top: Offset(50, 38.5),
      shoulder: Offset(28.5, 65),
      armLength: 14,
      armRest: 1.1,
      footX: 12.5,
      faceSize: 10.875,
      eyeSize: 7.25,
      eyeGap: 22.4,
    ),
  ];

  // Every stage is wider and taller than the one before it.
  static const List<MascotBody> _bodies = [
    (top: 62, mid: 81, bottom: 96, halfWidth: 22),
    (top: 50, mid: 71, bottom: 90, halfWidth: 25),
    (top: 44, mid: 68, bottom: 90, halfWidth: 27.5),
    (top: 38, mid: 65, bottom: 90, halfWidth: 30),
  ];

  static final List<Path> _bodyPaths = [
    for (final body in _bodies) bodyPath(body, point: 0.6),
  ];

  // The polyp is small, so its shade is a thinner crescent.
  static final List<Path> _bodyShades = [
    shadeOf(_bodyPaths.first, const Offset(-2, -3)),
    ..._bodyPaths.skip(1).map(shadeOf),
  ];

  // A scalloped fringe of the second colour along the base of the body.
  static final List<Path> _fringes = [
    for (final (index, body) in _bodies.indexed)
      Path.combine(PathOperation.intersect, _bodyPaths[index], _scallops(body)),
  ];

  static Path _scallops(MascotBody body) {
    final w = body.halfWidth;
    final h = (body.bottom - body.mid) * _fringeHeight;
    Rect lobe(double x, double width, double height) => Rect.fromCenter(
      center: Offset(50 + w * x, body.bottom),
      width: w * width * 2,
      height: h * height * 2,
    );
    return Path()
      ..addOval(lobe(-0.62, 0.42, 1))
      ..addOval(lobe(0.05, 0.36, 0.62))
      ..addOval(lobe(0.66, 0.4, 0.9));
  }

  static const List<List<_Branch>> _crowns = [
    [
      (angle: -0.75, length: 5.5, forks: 0, width: 4.2),
      (angle: 0.75, length: 5.5, forks: 0, width: 4.2),
      (angle: 0, length: 7.5, forks: 0, width: 4.2),
    ],
    [(angle: 0, length: 15, forks: 1, width: 5)],
    [
      (angle: -0.8, length: 14, forks: 1, width: 4.4),
      (angle: 0.8, length: 14, forks: 1, width: 4.4),
      (angle: 0, length: 22, forks: 2, width: 4.4),
    ],
    [
      (angle: -0.75, length: 13, forks: 1, width: 4.6),
      (angle: 0.75, length: 13, forks: 1, width: 4.6),
      (angle: 0, length: 25, forks: 2, width: 4.6),
    ],
  ];

  static const List<double> _finWidths = [0, 8, 9, 10];

  static const List<List<_Fish>> _shoals = [
    [],
    [],
    [(centre: Offset(18, 30), facing: -1)],
    [(centre: Offset(90, 11), facing: 1), (centre: Offset(10, 23), facing: -1)],
  ];

  static final Path _fishBody = Path()
    ..addOval(Rect.fromCenter(center: Offset.zero, width: 10, height: 6.6));

  static final Path _fishTail = Path()
    ..moveTo(3.5, 0)
    ..lineTo(8.5, -3.4)
    ..lineTo(8.5, 3.4)
    ..close();

  static final Path _seaGrass = Path()
    ..moveTo(8, -3)
    ..quadraticBezierTo(8, -15, 18, -20)
    ..moveTo(14, -3)
    ..quadraticBezierTo(15, -10, 27, -12);

  // The stage 4 reef garden: tube sponges and a bubble coral beside the
  // branching coral, so the crown is a soft mass of several kinds.
  static const List<_Tube> _tubes = [
    (centre: Offset(28, 37), size: Size(10, 24), turn: -0.45),
    (centre: Offset(21, 45.5), size: Size(8.5, 14), turn: -0.9),
  ];

  static const List<(double, double, double)> _bubbleLobes = [
    (70, 40, 8.5),
    (79, 46, 6.5),
    (77.5, 33, 5.5),
  ];

  static final Path _bubbles = _bubbleLobes.fold(
    Path(),
    (path, lobe) => Path.combine(
      PathOperation.union,
      path,
      Path()..addOval(
        Rect.fromCircle(center: Offset(lobe.$1, lobe.$2), radius: lobe.$3),
      ),
    ),
  );

  static final Path _bubbleShade = shadeOf(_bubbles);

  // Adds a stalk with [forks] levels of side prongs; angle 0 points up.
  static void _fork(
    Path path,
    Offset from,
    double angle,
    double length,
    int forks,
  ) {
    final reach = Offset(math.sin(angle), -math.cos(angle)) * length;
    final to = from + reach;
    path
      ..moveTo(from.dx, from.dy)
      ..lineTo(to.dx, to.dy);
    if (forks == 0) return;
    for (final turn in const [-_forkTurn, _forkTurn]) {
      _fork(
        path,
        from + reach * _forkAt,
        angle + turn,
        length * _forkLength,
        forks - 1,
      );
    }
  }

  @override
  MascotRig get rig => _rigs[stage - 1];

  @override
  MascotBody get body => _bodies[stage - 1];

  @override
  Path get bodyOutline => _bodyPaths[stage - 1];

  @override
  Color get outline => const Color(0xFF262058);

  @override
  FacePalette get facePalette => _facePalette;

  // Swims to the mirrored spot and back, turning at each end.
  _Fish _swimming(_Fish fish) {
    final legs = pose.swim / _swimLegSeconds;
    final leg = legs - legs.floor();
    final outbound = legs.floor().isEven;
    final far = Offset(
      DrawnMascotPainter.designSize - fish.centre.dx,
      fish.centre.dy,
    );
    final (from, to) = outbound ? (fish.centre, far) : (far, fish.centre);
    final turn = ((leg - 1 + _swimTurn) / _swimTurn).clamp(0.0, 1.0);
    return (
      centre: Offset.lerp(from, to, Curves.easeInOut.transform(leg))!,
      facing:
          (outbound ? fish.facing : -fish.facing) * math.cos(math.pi * turn),
    );
  }

  /// Where each fish is for [pose]: swimming, or hiding behind the body.
  List<({Offset centre, double facing})> get shoal {
    final den = Offset(DrawnMascotPainter.designSize / 2, body.mid);
    return [
      for (final home in _shoals[stage - 1])
        _hiding(_swimming(home), den, pose.hide),
    ];
  }

  // Head first to the den and back out, turning near each end of the trip.
  static _Fish _hiding(_Fish fish, Offset den, double hide) {
    final toward = fish.centre.dx > den.dx ? 1.0 : -1.0;
    final heading = hide <= 1 ? toward : -toward;
    final turn = (math.min(hide, 2 - hide) / _hideTurn).clamp(0.0, 1.0);
    return (
      centre: Offset.lerp(fish.centre, den, hide <= 1 ? hide : 2 - hide)!,
      facing: fish.facing + (heading - fish.facing) * turn,
    );
  }

  @override
  void paintGround(Canvas canvas) {
    for (final fish in shoal) {
      canvas
        ..save()
        ..translate(fish.centre.dx, fish.centre.dy + pose.topSway * _fishBob)
        ..scale(fish.facing, 1);
      part(canvas, _fishTail, _sponge);
      part(canvas, _fishBody, _sponge);
      canvas
        ..drawCircle(const Offset(-2.4, -0.8), 0.9, fill(outline))
        ..restore();
    }
    if (stage == 1) return;
    if (stage == 4) {
      paintFeet(canvas, () => branch(canvas, _seaGrass, _grass, _grassWidth));
    }
    paintFeet(
      canvas,
      () => part(
        canvas,
        Path()..addOval(
          oval(
            Offset(0, -_footSize.height / 2),
            _footSize.width,
            _footSize.height,
          ),
        ),
        _limb,
      ),
      kick: true,
    );
  }

  @override
  void paintBody(Canvas canvas) {
    final path = bodyOutline;
    final length = rig.armLength;
    paintArms(
      canvas,
      () => part(
        canvas,
        Path()
          ..addOval(oval(Offset(0, length / 2), _finWidths[stage - 1], length)),
        _limb,
      ),
    );
    paintTop(canvas, () {
      for (final shape in _crowns[stage - 1]) {
        final stalk = Path();
        _fork(
          stalk,
          rig.top + const Offset(0, 2),
          shape.angle,
          shape.length,
          shape.forks,
        );
        branch(canvas, stalk, _coral, shape.width);
      }
      if (stage == 4) _paintGarden(canvas);
    });
    canvas
      ..drawPath(path, fill(_body))
      ..drawPath(
        _bodyShades[stage - 1],
        fill(
          stage == 1
              ? _bodyShade.withValues(alpha: DrawnMascotPainter.seedShadeAlpha)
              : _bodyShade,
        ),
      )
      ..drawPath(_fringes[stage - 1], fill(_fringe));
    paintBodyHighlight(canvas, _bodyLight);
    canvas.drawPath(path, outlinePaint);
  }

  void _paintGarden(Canvas canvas) {
    for (final tube in _tubes) {
      final (:centre, :size, :turn) = tube;
      canvas
        ..save()
        ..translate(centre.dx, centre.dy)
        ..rotate(turn);
      part(
        canvas,
        Path()..addRRect(
          RRect.fromRectAndRadius(
            oval(Offset.zero, size.width, size.height),
            Radius.circular(size.width / 2),
          ),
        ),
        _sponge,
      );
      canvas
        ..drawOval(
          oval(
            Offset(0, size.width * 0.42 - size.height / 2),
            size.width * 0.5,
            size.width * 0.28,
          ),
          fill(_spongeShade),
        )
        ..restore();
    }
    canvas
      ..drawPath(_bubbles, fill(_fringe))
      ..drawPath(_bubbleShade, fill(_fringeShade))
      ..drawPath(_bubbles, outlinePaint);
  }
}
