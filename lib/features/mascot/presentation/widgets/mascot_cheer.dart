import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';

const _mascotSize = 160.0;
const _jumpMascotSize = 120.0;
const _stay = Duration(seconds: 3);

/// Clears a floating snackbar, which shares the bottom of the screen.
const _snackBarClearance = 72.0;

/// The mascot rising from the bottom edge to cheer, then sinking back.
/// Plays once when built and lies over the screen without taking taps.
///
/// The default is the game win: confetti and a smile; key it to the round
/// so a new round can play it again. [show] puts the jump cheer over any
/// screen: no confetti, a smaller mascot that jumps once loaded, raised
/// above floating snackbars.
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
  /// A no-op while one is showing, while an evolution or egg celebration
  /// is pending, or without a mascot asset.
  static void show(BuildContext context, {double bottomClearance = 0}) {
    if (_showing) return;
    final container = ProviderScope.containerOf(context, listen: false);
    if (container.read(activeMascotAssetPathProvider) == null ||
        container.read(mascotCelebrationPendingProvider)) {
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
    with SingleTickerProviderStateMixin {
  AnimationController? _rise;
  late bool _reduceMotion;
  Timer? _stayTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_rise != null) return;
    _reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.reduceMotionOf(context);
    final rise = _rise = AnimationController(
      vsync: this,
      duration: _reduceMotion ? Duration.zero : durationSlower,
    );
    rise.forward().then((_) => _cheer());
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
    final bottomInset = jump
        ? math.max(
                MediaQuery.viewInsetsOf(context).bottom,
                MediaQuery.viewPaddingOf(context).bottom +
                    widget._bottomClearance,
              ) +
              _snackBarClearance
        : 0.0;
    return IgnorePointer(
      child: Stack(
        children: [
          if (!_reduceMotion && !jump)
            const Positioned.fill(child: TimedConfettiLayer()),
          if (asset != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(
                      CurvedAnimation(
                        parent: _rise!,
                        curve: Curves.easeOutBack,
                        reverseCurve: Curves.easeIn,
                      ),
                    ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: MascotDisplay(
                    size: jump ? _jumpMascotSize : _mascotSize,
                    showGlow: false,
                    jumpOnLoad: jump,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
