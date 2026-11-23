import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/utils/reduce_motion.dart';
import 'package:seed_app/features/mascot/presentation/drawn/coral_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/fungi_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';
import 'package:seed_app/features/mascot/presentation/drawn/sprout_painter.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

/// Species ids that have a code-drawn painter.
const List<String> drawnSpeciesIds = ['seed', 'coral', 'fungi'];

DrawnMascotPainter drawnMascotPainter(
  String speciesId,
  int stage, [
  MascotPose pose = const MascotPose(),
]) => switch (speciesId) {
  'coral' => CoralPainter(stage: stage, pose: pose),
  'fungi' => FungiPainter(stage: stage, pose: pose),
  _ => SproutPainter(stage: stage, pose: pose),
};

/// One code-drawn mascot.
///
/// With [animate] it is the hero: it breathes, blinks, follows the
/// pointer and smiles on [mascotSmileTriggerProvider]. With [wavesOnTap]
/// it also takes taps and waves. With [hopOnLoad] it hops once when it
/// first appears, and with [routine] it moves to that routine in place of
/// breathing. Under reduce motion both become a smile. Without [animate]
/// the widget paints one static frame and owns no ticker.
class DrawnMascot extends ConsumerStatefulWidget {
  const DrawnMascot({
    required this.speciesId,
    required this.stage,
    required this.size,
    this.animate = true,
    this.wavesOnTap = false,
    this.hopOnLoad = false,
    this.routine,
    super.key,
  });

  final String speciesId;
  final int stage;
  final double size;
  final bool animate;

  /// Off by default so that a tap reaches an ancestor, such as a card.
  final bool wavesOnTap;
  final bool hopOnLoad;
  final MascotRoutine? routine;

  @override
  ConsumerState<DrawnMascot> createState() => _DrawnMascotState();
}

class _DrawnMascotState extends ConsumerState<DrawnMascot>
    with SingleTickerProviderStateMixin {
  static const double _followRate = 9;
  static const double _smileHoldSeconds = 1.2;
  static const double _gazeJump = 1.1;
  static const double _maxFrameSeconds = 0.1;

  final _pose = ValueNotifier(const MascotPose());
  final _random = math.Random();
  Ticker? _ticker;
  Duration _lastTick = Duration.zero;
  double _seconds = 0;
  Offset _gazeTarget = Offset.zero;
  Offset _gaze = Offset.zero;
  double _smile = 0;
  double _smileUntil = 0;
  bool _smileHeld = false;
  double _blinkAt = blinkMinGapSeconds;
  double? _waveAt;
  late double? _hopAt = widget.hopOnLoad ? 0 : null;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    if (!widget.animate) return;
    _ticker = createTicker(_onTick)..start();
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onGlobalPointer);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = reduceMotionOf(context);
    // Local, so that other visible mascots do not smile too.
    if (_reduceMotion && _hopAt != null) {
      _hopAt = null;
      _smileUntil = _seconds + _smileHoldSeconds;
    }
  }

  @override
  void dispose() {
    if (widget.animate) {
      GestureBinding.instance.pointerRouter.removeGlobalRoute(_onGlobalPointer);
    }
    _ticker?.dispose();
    _pose.dispose();
    super.dispose();
  }

  bool get _blinking => _seconds >= _blinkAt;

  void _onGlobalPointer(PointerEvent event) {
    if (!mounted) return;
    var target = Offset.zero;
    if (event is PointerDownEvent ||
        event is PointerMoveEvent ||
        event is PointerHoverEvent) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.attached || !box.hasSize) return;
      target =
          mascotGazeTarget(
            event.position,
            box.localToGlobal(box.size.center(Offset.zero)),
            box.size * mascotGazeReach,
          ) /
          mascotLookRange;
    } else if (event is! PointerUpEvent && event is! PointerCancelEvent) {
      return;
    }
    // A blink covers a large jump of the eyes.
    if ((target - _gazeTarget).distance > _gazeJump && !_blinking) {
      _blinkAt = _seconds;
    }
    _gazeTarget = target;
  }

  void _onTick(Duration elapsed) {
    final frame = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    final dt = math.min(frame, _maxFrameSeconds);
    _seconds += dt;

    final follow = 1 - math.exp(-dt * _followRate);
    _gaze = Offset.lerp(_gaze, _gazeTarget, follow)!;
    final routine = widget.routine;
    final smiling =
        _smileHeld ||
        _seconds < _smileUntil ||
        (_reduceMotion && routine != null);
    _smile += ((smiling ? 1 : 0) - _smile) * follow;
    if (_seconds - _blinkAt >= blinkSeconds) {
      final gap = blinkMaxGapSeconds - blinkMinGapSeconds;
      _blinkAt = _seconds + blinkMinGapSeconds + _random.nextDouble() * gap;
    }

    var pose = MascotPose(
      gaze: _gaze,
      smile: _smile,
      eyeOpen: blinkEyeOpen(_seconds - _blinkAt),
    );
    final waveAt = _waveAt;
    if (!_reduceMotion) {
      pose = routine == null
          ? breathe(pose, _seconds)
          : routine(pose, _seconds);
      if (waveAt != null) {
        final progress = (_seconds - waveAt) / waveSeconds;
        if (progress < 1) {
          pose = wave(pose, progress);
        } else {
          _waveAt = null;
        }
      }
      final hopAt = _hopAt;
      if (hopAt != null) {
        final progress = (_seconds - hopAt) / hopSeconds;
        if (progress < 1) {
          pose = hop(pose, progress);
        } else {
          _hopAt = null;
        }
      }
    }
    _pose.value = pose;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate) {
      // An offstage mascot must not queue a smile and replay it on return.
      ref.listen(mascotSmileTriggerProvider, (_, shouldSmile) {
        if (!context.mounted) return;
        _smileHeld = shouldSmile && TickerMode.valuesOf(context).enabled;
        if (_smileHeld) _smileUntil = _seconds + _smileHoldSeconds;
      });
    }
    final mascot = RepaintBoundary(
      child: ValueListenableBuilder(
        valueListenable: _pose,
        builder: (_, pose, _) => CustomPaint(
          size: Size.square(widget.size),
          painter: drawnMascotPainter(widget.speciesId, widget.stage, pose),
        ),
      ),
    );
    if (!widget.animate || !widget.wavesOnTap) return mascot;
    return GestureDetector(onTap: () => _waveAt ??= _seconds, child: mascot);
  }
}
