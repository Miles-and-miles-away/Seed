import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import 'package:seed_app/core/utils/reduce_motion.dart';

/// Seconds a [HatchingEgg] wobbles and cracks before its shell splits.
const double eggSplitSeconds = 1.4;

/// Seconds an [EvolutionSmoke] takes to hide the old stage and swap it.
const double smokeSwapSeconds = 1.25;

const double _design = 100;
const double _outlineWidth = 1.5;

/// An egg that wobbles, cracks and splits, then [child] hops out of it.
///
/// [child] mounts when the shell splits, so its routine starts then.
class HatchingEgg extends StatelessWidget {
  const HatchingEgg({required this.size, required this.child, super.key});

  final double size;
  final Widget child;

  static const double _shellSeconds = 0.8;
  static const double _hopSeconds = 0.6;

  @override
  Widget build(BuildContext context) {
    if (reduceMotionOf(context)) return child;
    final unit = size / _design;
    return _Timeline(
      seconds: eggSplitSeconds + _shellSeconds,
      builder: (t) {
        if (t < eggSplitSeconds) {
          return CustomPaint(
            size: Size.square(size),
            painter: _EggPainter(_Shell.whole, t),
          );
        }
        final u = ((t - eggSplitSeconds) / _hopSeconds).clamp(0.0, 1.0);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size.square(size),
              painter: _EggPainter(_Shell.top, t),
            ),
            Transform.translate(
              offset: Offset(0, -20 * unit * math.sin(math.pi * u)),
              child: Transform.scale(
                scale: lerpDouble(0.5, 1, Curves.easeOutBack.transform(u)),
                alignment: Alignment.bottomCenter,
                child: child,
              ),
            ),
            CustomPaint(
              size: Size.square(size),
              painter: _EggPainter(_Shell.bottom, t),
            ),
          ],
        );
      },
    );
  }
}

/// Smoke that hides [before], swaps in [after], then clears.
///
/// [after] mounts behind the full cloud, so its routine starts then.
class EvolutionSmoke extends StatelessWidget {
  const EvolutionSmoke({
    required this.size,
    required this.before,
    required this.after,
    super.key,
  });

  final double size;
  final Widget before;
  final Widget after;

  @override
  Widget build(BuildContext context) {
    if (reduceMotionOf(context)) return after;
    final unit = size / _design;
    return _Timeline(
      seconds: smokeSwapSeconds + _SmokePainter.clearSeconds,
      builder: (t) => Stack(
        clipBehavior: Clip.none,
        children: [
          if (t < smokeSwapSeconds)
            Transform.translate(
              key: const ValueKey('before'),
              offset: Offset(_tremble(t) * unit, 0),
              child: before,
            )
          else
            KeyedSubtree(key: const ValueKey('after'), child: after),
          CustomPaint(size: Size.square(size), painter: _SmokePainter(t)),
        ],
      ),
    );
  }

  static double _tremble(double t) =>
      1.2 * ((t - 0.2) / 0.6).clamp(0.0, 1.0) * math.sin(2 * math.pi * 14 * t);
}

class _Timeline extends StatefulWidget {
  const _Timeline({required this.seconds, required this.builder});

  final double seconds;
  final Widget Function(double seconds) builder;

  @override
  State<_Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<_Timeline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: (widget.seconds * 1000).round()),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (_, _) => widget.builder(_controller.value * widget.seconds),
  );
}

enum _Shell { whole, top, bottom }

final Path _egg = Path()
  ..moveTo(50, 10)
  ..cubicTo(72, 10, 84, 44, 84, 62)
  ..cubicTo(84, 82, 69, 94, 50, 94)
  ..cubicTo(31, 94, 16, 82, 16, 62)
  ..cubicTo(16, 44, 28, 10, 50, 10)
  ..close();

const List<Offset> _crack = [
  Offset(8, 54),
  Offset(19, 48),
  Offset(29, 56),
  Offset(40, 47),
  Offset(50, 56),
  Offset(60, 47),
  Offset(71, 56),
  Offset(81, 48),
  Offset(92, 54),
];

Path _half(double edge) => Path.combine(
  PathOperation.intersect,
  _egg,
  Path()..addPolygon([
    ..._crack,
    Offset(_crack.last.dx, edge),
    Offset(_crack.first.dx, edge),
  ], true),
);

final Path _topShell = _half(0);
final Path _bottomShell = _half(_design);

const List<Offset> _break = [
  Offset(50, 56),
  Offset(46, 67),
  Offset(53, 79),
  Offset(49, 100),
];

Path _bottomHalf(double side) => Path.combine(
  PathOperation.intersect,
  _bottomShell,
  Path()..addPolygon([
    ..._break,
    Offset(50 + side * 50, 100),
    Offset(50 + side * 50, 40),
    const Offset(50, 40),
  ], true),
);

final List<Path> _bottomHalves = [_bottomHalf(-1), _bottomHalf(1)];

class _EggPainter extends CustomPainter {
  const _EggPainter(this.shell, this.t);

  final _Shell shell;
  final double t;

  static const Color _outline = Color(0xFF3A1408);
  static const Color _cream = Color(0xFFFFF4DC);
  static const Color _shade = Color(0xFFEBD8B0);
  static const Color _spot = Color(0xFFE8C98C);
  static const Color _gloss = Color(0x99FFFFFF);
  static const Offset _pivot = Offset(50, 94);
  static const double _burstSeconds = 0.45;
  static const double _shakeSeconds = 0.3;
  static const List<(Offset, double)> _spots = [
    (Offset(38, 30), 4),
    (Offset(63, 38), 3),
    (Offset(30, 70), 5),
    (Offset(66, 76), 4),
    (Offset(53, 64), 3),
  ];
  static const List<(int, Offset)> _shards = [
    (1, Offset(-30, -24)),
    (3, Offset(-12, -34)),
    (5, Offset(14, -32)),
    (7, Offset(30, -22)),
  ];

  double get _wobble {
    final burst = (t / _burstSeconds).floor();
    final local = t - burst * _burstSeconds;
    if (local > _shakeSeconds) return 0;
    return (0.07 + 0.04 * burst) *
        math.sin(math.pi * local / _shakeSeconds) *
        math.sin(2 * math.pi * local / 0.15);
  }

  int get _cracks => t < _shakeSeconds
      ? 0
      : math.min(3, ((t - _shakeSeconds) / _burstSeconds).floor() + 1);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / _design);
    final u = ((t - eggSplitSeconds) / HatchingEgg._shellSeconds).clamp(
      0.0,
      1.0,
    );
    switch (shell) {
      case _Shell.whole:
        canvas
          ..translate(_pivot.dx, _pivot.dy)
          ..rotate(_wobble)
          ..translate(-_pivot.dx, -_pivot.dy);
        _paintShell(canvas, _egg);
        _paintCrack(canvas);
      case _Shell.top:
        if (u >= 1) return;
        canvas
          ..saveLayer(null, Paint()..color = Color.fromRGBO(0, 0, 0, 1 - u))
          ..translate(14 * u, -50 * u)
          ..translate(50, 40)
          ..rotate(0.9 * u)
          ..translate(-50, -40);
        _paintShell(canvas, _topShell);
        canvas.restore();
      case _Shell.bottom:
        final fall = ((u - 0.15) / 0.85).clamp(0.0, 1.0);
        final fade = ((u - 0.5) / 0.4).clamp(0.0, 1.0);
        if (fall == 0) {
          _paintShell(canvas, _bottomShell);
        } else if (fade < 1) {
          for (final (i, side) in const [-1.0, 1.0].indexed) {
            final pivot = Offset(50 + side * 17, 80);
            canvas
              ..saveLayer(
                null,
                Paint()..color = Color.fromRGBO(0, 0, 0, 1 - fade),
              )
              ..translate(
                pivot.dx + side * 22 * fall,
                pivot.dy + 20 * fall * fall,
              )
              ..rotate(side * 0.7 * fall)
              ..translate(-pivot.dx, -pivot.dy);
            _paintShell(canvas, _bottomHalves[i]);
            canvas.restore();
          }
        }
        _paintShards(canvas, u);
    }
  }

  void _paintShell(Canvas canvas, Path piece) {
    canvas
      ..save()
      ..clipPath(piece)
      ..drawPath(_egg, Paint()..color = _shade)
      ..drawPath(_egg.shift(const Offset(-5, -4)), Paint()..color = _cream);
    for (final (centre, radius) in _spots) {
      canvas.drawCircle(centre, radius, Paint()..color = _spot);
    }
    canvas
      ..save()
      ..translate(35, 28)
      ..rotate(-0.6)
      ..drawOval(
        Rect.fromCenter(center: Offset.zero, width: 7, height: 13),
        Paint()..color = _gloss,
      )
      ..restore()
      ..restore()
      ..drawPath(piece, _line(_outline, _outlineWidth));
  }

  void _paintCrack(Canvas canvas) {
    if (_cracks == 0) return;
    final reach = _cracks * 4 ~/ 3;
    final from = math.max(0, 4 - reach);
    final to = math.min(_crack.length - 1, 4 + reach);
    canvas
      ..save()
      ..clipPath(_egg)
      ..drawPath(
        Path()..addPolygon(_crack.sublist(from, to + 1), false),
        _line(_outline, _outlineWidth * 1.2),
      )
      ..restore();
  }

  void _paintShards(Canvas canvas, double u) {
    if (u >= 1) return;
    final alpha = 1 - u;
    for (final (index, velocity) in _shards) {
      final at = _crack[index] + velocity * u + Offset(0, 60 * u * u);
      final shard = Path()
        ..addPolygon([
          at + const Offset(-4.5, -3),
          at + const Offset(4.5, -4.5),
          at + const Offset(1.5, 4.5),
        ], true);
      canvas
        ..drawPath(shard, Paint()..color = _cream.withValues(alpha: alpha))
        ..drawPath(
          shard,
          _line(_outline.withValues(alpha: alpha), _outlineWidth),
        );
    }
  }

  @override
  bool shouldRepaint(_EggPainter old) => old.t != t || old.shell != shell;
}

class _SmokePainter extends CustomPainter {
  const _SmokePainter(this.t);

  final double t;

  static const double clearSeconds = 1;
  static const double _growSeconds = 0.35;
  static const double _firstPuffSeconds = 0.55;
  static const double _staggerSeconds = 0.02;
  static const double _holdSeconds = 0.1;
  static const Offset _centre = Offset(50, 56);
  static const Color _outline = Color(0xFF5E5873);
  static const Color _shade = Color(0xFFD9D4E8);
  static const Color _light = Color(0xFFF7F5FC);
  static const List<(Offset, double)> _puffs = [
    (Offset(50, 86), 15),
    (Offset(30, 86), 15),
    (Offset(70, 86), 15),
    (Offset(12, 86), 13),
    (Offset(88, 86), 13),
    (Offset(50, 56), 26),
    (Offset(22, 64), 17),
    (Offset(78, 64), 17),
    (Offset(12, 42), 15),
    (Offset(88, 42), 15),
    (Offset(32, 36), 18),
    (Offset(68, 36), 18),
    (Offset(13, 16), 17),
    (Offset(87, 16), 17),
    (Offset(50, 16), 17),
    (Offset(32, 10), 13),
    (Offset(68, 10), 13),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final clear =
        ((t - smokeSwapSeconds - _holdSeconds) / (clearSeconds - _holdSeconds))
            .clamp(0.0, 1.0);
    if (clear >= 1) return;
    final puffs = <(Offset, double)>[];
    for (final (i, (centre, radius)) in _puffs.indexed) {
      final start = _firstPuffSeconds + i * _staggerSeconds;
      final grow = ((t - start) / _growSeconds).clamp(0.0, 1.0);
      if (grow == 0) continue;
      final away = centre == _centre
          ? const Offset(0, -1)
          : (centre - _centre) / (centre - _centre).distance;
      final boil = 1 + 0.05 * math.sin(9 * t + i);
      puffs.add((
        centre + away * 14 * clear + Offset(0, -8 * clear),
        radius * Curves.easeOutBack.transform(grow) * boil * (1 + 0.35 * clear),
      ));
    }
    canvas
      ..scale(size.width / _design)
      ..saveLayer(
        null,
        Paint()
          ..color = Color.fromRGBO(
            0,
            0,
            0,
            1 - Curves.easeOut.transform(clear),
          ),
      );
    for (final (centre, radius) in puffs) {
      canvas.drawCircle(
        centre,
        radius + _outlineWidth,
        Paint()..color = _outline,
      );
    }
    for (final (centre, radius) in puffs) {
      canvas.drawCircle(centre, radius, Paint()..color = _shade);
    }
    for (final (centre, radius) in puffs) {
      canvas.drawCircle(
        centre + Offset(-0.12 * radius, -0.16 * radius),
        radius * 0.8,
        Paint()..color = _light,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SmokePainter old) => old.t != t;
}

Paint _line(Color color, double width) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..strokeWidth = width
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;
