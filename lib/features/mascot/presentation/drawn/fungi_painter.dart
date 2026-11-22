import 'package:flutter/rendering.dart';

import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/face_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';

typedef _Cap = ({
  double top,
  double rim,
  double halfWidth,
  double lip,
  double gills,
});
typedef _Baby = ({double x, double size});

/// Fungi: Spore, Cap, Colony, Network.
class FungiPainter extends DrawnMascotPainter {
  const FungiPainter({required super.stage, super.pose = const MascotPose()});

  static const Color _stem = Color(0xFFF7E6C4);
  static const Color _stemShade = Color(0xFFE6CC9E);
  static const Color _stemLight = Color(0xFFFFF8E6);
  static const Color _limb = Color(0xFFEDD6AB);
  static const Color _cap = Color(0xFFD3A478);
  static const Color _capShade = Color(0xFFB98759);
  static const Color _capLight = Color(0xFFF3DDBD);
  static const Color _glow = Color(0xFF8DE5CB);
  static const Color _glowShade = Color(0xFF55BFA6);

  static const FacePalette _facePalette = FacePalette(
    line: Color(0xFF3C240C),
    iris: Color(0xFF7A4A22),
    lidShadow: Color(0xFF5A3414),
    glow: Color(0xFF8DE5CB),
    pupil: Color(0xFF2A1506),
    mouthInside: Color(0xFF2A1506),
    tongue: Color(0xFFF2A08C),
  );

  static const double _x = DrawnMascotPainter.designSize / 2;
  static const double _hyphaWidth = 1.8;
  static const double _threadWidth = 1.6;
  static const double _gillLineWidth = 0.8;
  static const double _gillInset = 2;
  static const double _babyEye = 0.75;
  static const Size _footSize = Size(13, 10);

  static const List<MascotRig> _rigs = [
    (
      pivot: Offset(50, 96),
      face: Offset(50, 77.7),
      top: Offset(50, 63.5),
      shoulder: Offset(16, 82),
      armLength: 0,
      armRest: 0.62,
      footX: 7,
      eyeSize: 10.5,
      eyeGap: 14.5,
    ),
    (
      pivot: Offset(50, 90),
      face: Offset(50, 69.7),
      top: Offset(50, 54),
      shoulder: Offset(19, 75),
      armLength: 11,
      armRest: 0.62,
      footX: 9,
      eyeSize: 11,
      eyeGap: 15,
    ),
    (
      pivot: Offset(50, 90),
      face: Offset(50, 66.7),
      top: Offset(50, 49),
      shoulder: Offset(20.5, 72.5),
      armLength: 12.5,
      armRest: 0.7,
      footX: 10,
      eyeSize: 11.5,
      eyeGap: 16,
    ),
    (
      pivot: Offset(50, 90),
      face: Offset(50, 62.7),
      top: Offset(50, 44),
      shoulder: Offset(22.5, 72),
      armLength: 14,
      armRest: 0.95,
      footX: 11,
      eyeSize: 12,
      eyeGap: 17,
    ),
  ];

  // The body is the spore, then the stem. Every stage is wider and taller
  // than the one before it.
  static const List<MascotBody> _bodies = [
    (top: 63, mid: 80.5, bottom: 96, halfWidth: 18.5),
    (top: 49, mid: 73, bottom: 90, halfWidth: 20),
    (top: 44, mid: 71, bottom: 90, halfWidth: 21.5),
    (top: 39, mid: 70, bottom: 90, halfWidth: 23.5),
  ];

  static const List<_Cap?> _caps = [
    null,
    (top: 31, rim: 54, halfWidth: 28, lip: 3, gills: 7),
    (top: 23, rim: 49, halfWidth: 33, lip: 3.5, gills: 8),
    (top: 14, rim: 44, halfWidth: 39, lip: 4, gills: 9),
  ];

  // Glowing lobes that hang from the top of the cap: x and half width as
  // shares of the cap half width, drop as a share of the cap height.
  static const List<List<(double, double, double)>> _crownLobes = [
    [],
    [],
    [(0, 0.5, 0.45)],
    [(-0.42, 0.26, 0.5), (0.02, 0.3, 0.62), (0.46, 0.24, 0.44)],
  ];

  static const List<double> _gillLines = [0.55, 0.8, 1.05];
  static const List<double> _armWidths = [0, 7, 7.5, 8];

  // Offsets from a foot, towards the outside.
  static const List<List<_Baby>> _babies = [
    [],
    [],
    [(x: 18, size: 1.1)],
    [(x: 29.5, size: 0.8), (x: 17, size: 1.25)],
  ];

  static final List<Path> _stemPaths = [
    for (final body in _bodies) bodyPath(body, point: 0.6),
  ];

  static final List<Path> _stemShades = _stemPaths.map(shadeOf).toList();

  static final List<Path?> _capPaths = [
    for (final cap in _caps)
      if (cap == null) null else _capPath(cap),
  ];

  static final List<Path?> _capShades = [
    for (final path in _capPaths)
      if (path == null) null else shadeOf(path),
  ];

  // The cap hides the top of the stem, so the eyes keep clear of its hem.
  static final List<Path> _bodyOutlines = [
    for (final (index, stem) in _stemPaths.indexed)
      switch (_capPaths[index]) {
        null => stem,
        final cap => Path.combine(PathOperation.difference, stem, cap),
      },
  ];

  static final List<Path?> _crowns = [
    for (final (index, lobes) in _crownLobes.indexed)
      if (lobes.isEmpty)
        null
      else
        _crown(_caps[index]!, _capPaths[index]!, lobes),
  ];

  // A dome with a hem that bows up in the middle to show the gills.
  static Path _capPath(_Cap cap) {
    final w = cap.halfWidth;
    final shoulder = cap.rim - (cap.rim - cap.top) * 0.62;
    final hem = cap.rim + cap.lip;
    final corner = cap.lip * 1.5;
    return Path()
      ..moveTo(_x - w, cap.rim)
      ..cubicTo(_x - w, shoulder, _x - w * 0.5, cap.top, _x, cap.top)
      ..cubicTo(_x + w * 0.5, cap.top, _x + w, shoulder, _x + w, cap.rim)
      ..quadraticBezierTo(_x + w, hem, _x + w - corner, hem)
      ..quadraticBezierTo(_x, cap.rim - cap.lip, _x - w + corner, hem)
      ..quadraticBezierTo(_x - w, hem, _x - w, cap.rim)
      ..close();
  }

  static Path _crown(
    _Cap cap,
    Path path,
    List<(double, double, double)> lobes,
  ) {
    final w = cap.halfWidth;
    final height = cap.rim - cap.top;
    final drips = Path();
    for (final (x, halfWidth, drop) in lobes) {
      drips.addOval(
        Rect.fromCenter(
          center: Offset(_x + w * x, cap.top),
          width: w * halfWidth * 2,
          height: height * drop * 2,
        ),
      );
    }
    return Path.combine(PathOperation.intersect, path, drips);
  }

  // The spore's first thread; the network of stage 4 grows from it.
  static final Path _hypha = Path()
    ..moveTo(50, 65)
    ..cubicTo(49, 58, 53, 54.5, 56, 56.5)
    ..cubicTo(58, 58, 56.5, 60.5, 54.8, 59.3);

  static final List<Path?> _threads = [
    null,
    null,
    Path()
      ..moveTo(4, -3)
      ..quadraticBezierTo(14, -5.5, 25, -3)
      ..moveTo(9, -4.4)
      ..quadraticBezierTo(10, -8, 14, -10),
    Path()
      ..moveTo(4, -3)
      ..quadraticBezierTo(16, -6, 31, -3)
      ..moveTo(8, -4.4)
      ..quadraticBezierTo(8.5, -8.5, 12, -11)
      ..moveTo(22, -4.6)
      ..quadraticBezierTo(23, -8, 26.5, -10),
  ];

  static final Path _foot = Path()
    ..addOval(
      Rect.fromCenter(
        center: Offset(0, -_footSize.height / 2),
        width: _footSize.width,
        height: _footSize.height,
      ),
    );

  @override
  MascotRig get rig => _rigs[stage - 1];

  @override
  MascotBody get body => _bodies[stage - 1];

  @override
  Path get bodyOutline => _bodyOutlines[stage - 1];

  @override
  Color get outline => const Color(0xFF3C240C);

  @override
  FacePalette get facePalette => _facePalette;

  @override
  double get mouthScale => 0.65;

  @override
  double get mouthDrop => 140;

  @override
  double get restBlush => 0.8;

  @override
  void paintGround(Canvas canvas) {
    if (stage == 1) return;
    final threads = _threads[stage - 1];
    paintFeet(canvas, () {
      if (threads != null) branch(canvas, threads, _glow, _threadWidth);
      for (final baby in _babies[stage - 1]) {
        _paintBaby(canvas, baby);
      }
      part(canvas, _foot, _limb);
    });
  }

  @override
  void paintBody(Canvas canvas) {
    final index = stage - 1;
    final stem = _stemPaths[index];
    final cap = _caps[index];
    final length = rig.armLength;
    paintArms(
      canvas,
      () => part(
        canvas,
        Path()..addOval(oval(Offset(0, length / 2), _armWidths[index], length)),
        _limb,
      ),
    );
    paintTop(canvas, () {
      if (cap == null) {
        branch(canvas, _hypha, _glow, _hyphaWidth);
      } else {
        _paintGills(canvas, cap);
      }
    });
    canvas
      ..drawPath(stem, fill(_stem))
      // The spore glows along its lower rim.
      ..drawPath(_stemShades[index], fill(cap == null ? _glow : _stemShade));
    if (cap == null) paintBodyHighlight(canvas, _stemLight);
    canvas.drawPath(stem, outlinePaint);
    if (cap != null) paintTop(canvas, () => _paintCap(canvas, cap));
  }

  void _paintGills(Canvas canvas, _Cap cap) {
    final centre = Offset(_x, cap.rim + cap.lip / 2);
    final gills = Path()
      ..addOval(oval(centre, (cap.halfWidth - _gillInset) * 2, cap.gills * 2));
    canvas
      ..drawPath(gills, fill(_glow))
      ..save()
      ..clipPath(gills);
    for (final reach in _gillLines) {
      for (final side in const [-1.0, 1.0]) {
        canvas.drawLine(
          centre - Offset(0, cap.gills),
          centre + Offset(side * cap.halfWidth * reach, cap.gills),
          line(_glowShade, _gillLineWidth),
        );
      }
    }
    canvas
      ..restore()
      ..drawPath(gills, outlinePaint);
  }

  void _paintCap(Canvas canvas, _Cap cap) {
    final index = stage - 1;
    final path = _capPaths[index]!;
    final crown = _crowns[index];
    canvas.drawPath(path, fill(_cap));
    if (crown != null) canvas.drawPath(crown, fill(_glow));
    canvas.drawPath(_capShades[index]!, fill(_capShade));
    paintHighlight(
      canvas,
      Offset(_x - cap.halfWidth * 0.5, cap.top + (cap.rim - cap.top) * 0.4),
      _capLight,
    );
    canvas.drawPath(path, outlinePaint);
  }

  void _paintBaby(Canvas canvas, _Baby baby) {
    final (:x, size: s) = baby;
    part(
      canvas,
      Path()..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(x - 2.6 * s, -8.5 * s, x + 2.6 * s, 0),
          Radius.circular(2.4 * s),
        ),
      ),
      _stem,
    );
    part(
      canvas,
      Path()
        ..moveTo(x - 6 * s, -6.5 * s)
        ..cubicTo(
          x - 6 * s,
          -15.5 * s,
          x + 6 * s,
          -15.5 * s,
          x + 6 * s,
          -6.5 * s,
        )
        ..quadraticBezierTo(x, -5 * s, x - 6 * s, -6.5 * s)
        ..close(),
      _cap,
    );
    for (final side in const [-1.0, 1.0]) {
      canvas.drawCircle(
        Offset(x + side * 1.5 * s, -3.4 * s),
        _babyEye,
        fill(outline),
      );
    }
  }
}
