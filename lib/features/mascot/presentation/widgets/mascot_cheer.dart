import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/utils/reduce_motion.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';

const _mascotSize = 160.0;
const _jumpMascotSize = 200.0;
const _stay = Duration(seconds: 3);

// A jump at 60 fps: 46 frames of crouch, 12 up, 12 down.
const _hopDuration = Duration(microseconds: 70 * 1000000 ~/ 60);
final _hopLift = TweenSequence<double>([
  TweenSequenceItem(tween: ConstantTween(0), weight: 46),
  TweenSequenceItem(
    tween: Tween<double>(
      begin: 0,
      end: 1,
    ).chain(CurveTween(curve: const Cubic(0.25, 0.1, 0.25, 1))),
    weight: 12,
  ),
  TweenSequenceItem(
    tween: Tween<double>(
      begin: 1,
      end: 0,
    ).chain(CurveTween(curve: const Cubic(0.42, 0, 1, 1))),
    weight: 12,
  ),
]);

/// The mascot rising from the bottom edge to cheer, then sinking back.
/// Plays once when built and lies over the screen without taking taps.
///
/// The default is the game win: confetti and a smile; key it to the round
/// so a new round can play it again. [show] puts the jump cheer over any
/// screen: no confetti, a larger mascot that rises to the bottom third
/// of the free space and jumps to its middle once loaded.
class MascotCheer extends ConsumerStatefulWidget {
  const MascotCheer({super.key}) : _onDone = null, _bottomClearance = 0;

  const MascotCheer._jump({
    required VoidCallback onDone,
    required double bottomClearance,
  }) : _onDone = onDone,
       _bottomClearance = bottomClearance;

  final VoidCallback? _onDone;
  final double _bottomClearance;

  bool get _isJump => _onDone != null;

  static bool _showing = false;

  /// Shows the jump cheer in the root overlay, [bottomClearance] above the
  /// bottom safe area (the bottom nav's height on screens that have it).
  /// A no-op while one is showing, while a celebration is pending, showing
  /// or queued, or without a mascot asset.
  static void show(BuildContext context, {double bottomClearance = 0}) {
    if (_showing) return;
    final container = ProviderScope.containerOf(context, listen: false);
    if (container.read(activeMascotAssetPathProvider) == null ||
        container.read(mascotCelebrationPendingProvider) ||
        celebrationsPending(context).value > 0) {
      return;
    }
    _showing = true;
    late final OverlayEntry entry;
    var done = false;
    void finish() {
      if (done) return;
      done = true;
      _showing = false;
      entry
        ..remove()
        ..dispose();
    }

    entry = OverlayEntry(
      builder: (_) =>
          MascotCheer._jump(onDone: finish, bottomClearance: bottomClearance),
    );
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  @override
  ConsumerState<MascotCheer> createState() => _MascotCheerState();
}

class _MascotCheerState extends ConsumerState<MascotCheer>
    with TickerProviderStateMixin {
  AnimationController? _rise;
  late final CurvedAnimation _curve;
  late final _hop = AnimationController(vsync: this, duration: _hopDuration);
  late bool _reduceMotion;
  Timer? _stayTimer;
  ValueListenable<int>? _celebrations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_rise != null) return;
    _reduceMotion = reduceMotionOf(context);
    if (widget._isJump) {
      _celebrations = celebrationsPending(context)..addListener(_standAside);
    }
    final rise = _rise = AnimationController(
      vsync: this,
      duration: _reduceMotion ? Duration.zero : durationSlower,
    );
    _curve = CurvedAnimation(
      parent: rise,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );
    rise.forward().then((_) => _cheer());
  }

  // A celebration queued after the cheer started takes the stage.
  void _standAside() {
    if (_celebrations!.value > 0) widget._onDone?.call();
  }

  void _cheer() {
    if (!mounted) return;
    if (!widget._isJump) {
      ref
          .read(mascotSmileTriggerProvider.notifier)
          .triggerSmile(hold: durationCelebration);
    }
    _stayTimer = Timer(_stay, () {
      if (!mounted) return;
      _rise!.reverse().then((_) => widget._onDone?.call());
    });
  }

  @override
  void dispose() {
    _stayTimer?.cancel();
    _celebrations?.removeListener(_standAside);
    _curve.dispose();
    _hop.dispose();
    _rise!.dispose();
    widget._onDone?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asset = ref.watch(activeMascotAssetPathProvider);
    final jump = widget._isJump;
    // A celebration that lands after the cheer started takes the stage.
    if (jump && ref.watch(mascotCelebrationPendingProvider)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget._onDone?.call();
      });
      return const SizedBox.shrink();
    }
    final mascot = MascotDisplay(
      size: jump ? _jumpMascotSize : _mascotSize,
      showGlow: false,
      jumpOnLoad: jump,
      onJump: _hop.forward,
    );
    return IgnorePointer(
      child: Stack(
        children: [
          if (!_reduceMotion && !jump)
            const Positioned.fill(child: TimedConfettiLayer()),
          if (asset != null)
            if (jump)
              _centred(mascot, _curve)
            else
              Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(_curve),
                  child: mascot,
                ),
              ),
        ],
      ),
    );
  }

  /// Rises from below the screen to the bottom third of the space left by
  /// the keyboard or the bottom nav, and hops to its middle with the jump.
  Widget _centred(Widget mascot, Animation<double> rise) {
    final bottomInset = math.max(
      MediaQuery.viewInsetsOf(context).bottom,
      MediaQuery.viewPaddingOf(context).bottom + widget._bottomClearance,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: LayoutBuilder(
        builder: (context, box) {
          final lift = box.maxHeight / 6;
          final drop = box.maxHeight / 3 + _jumpMascotSize / 2 + bottomInset;
          return Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([rise, _hop]),
              builder: (_, child) => Transform.translate(
                offset: Offset(
                  0,
                  lift * (1 - _hopLift.evaluate(_hop)) +
                      drop * (1 - rise.value),
                ),
                child: child,
              ),
              child: mascot,
            ),
          );
        },
      ),
    );
  }
}
