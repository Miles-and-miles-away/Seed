import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/utils/reduce_motion.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';

import '../providers/mascot_providers.dart';
import 'mascot_image.dart';

/// Displays the user's mascot as the hero: idle motion, pointer gaze and
/// the smile from [mascotSmileTriggerProvider].
class MascotDisplay extends ConsumerStatefulWidget {
  const MascotDisplay({
    this.size = 200,
    this.wavesOnTap = false,
    this.showGlow = true,
    this.jumpOnLoad = false,
    this.onJump,
    this.greets = false,
    this.routine,
    super.key,
  });

  /// The size (width and height) of the mascot display.
  final double size;

  /// Whether the mascot waves when it is tapped.
  final bool wavesOnTap;

  /// Whether to show a glow effect behind the mascot.
  final bool showGlow;

  /// Whether this mascot jumps once as soon as it has loaded (a smile
  /// under reduce motion).
  final bool jumpOnLoad;

  /// Called when the load-time jump is triggered (not under reduce motion).
  final VoidCallback? onJump;

  /// Whether this mascot waves the daily greeting when it is due (a smile
  /// under reduce motion). [MascotGreetingBubble] shows the words.
  final bool greets;

  /// See [MascotImage.routine].
  final MascotRoutine? routine;

  @override
  ConsumerState<MascotDisplay> createState() => _MascotDisplayState();
}

class _MascotDisplayState extends ConsumerState<MascotDisplay> {
  bool _drawn = false;
  bool _ready = false;
  int _waves = 0;

  void _onReady() {
    if (!mounted) return;
    if (widget.jumpOnLoad && !reduceMotionOf(context)) widget.onJump?.call();
    _maybeGreet();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Also reruns when TickerMode flips, i.e. Home is uncovered again.
    if (widget.greets && TickerMode.valuesOf(context).enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeGreet());
    }
  }

  @override
  void didUpdateWidget(MascotDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.greets && !oldWidget.greets) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeGreet());
    }
  }

  // Post-frame only: marking the greeting writes provider state.
  void _maybeGreet() {
    if (!widget.greets || !mounted || !_ready) return;
    if (!TickerMode.valuesOf(context).enabled) return;
    if (!ref.read(dailyGreetingDueProvider)) return;
    ref.read(dailyGreetedProvider.notifier).markGreeted();
    setState(() => _waves++);
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = ref.watch(activeMascotAssetPathProvider);

    // The user document can arrive after the mascot has loaded.
    if (widget.greets) {
      ref.listen(dailyGreetingDueProvider, (_, due) {
        if (!due) return;
        WidgetsBinding.instance.addPostFrameCallback((_) => _maybeGreet());
      });
    }

    if (assetPath == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    _drawn = drawnMascotStage(assetPath) != null;
    if (!_ready) {
      _ready = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _onReady());
    }

    final reduceMotion = reduceMotionOf(context);
    final glow = Container(
      width: widget.size * 0.9,
      height: widget.size * 0.9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Soft white feathering behind the mascot
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: opacityModerate),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
    );

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect (wrapped in RepaintBoundary for Impeller compatibility)
          if (widget.showGlow)
            RepaintBoundary(
              child: reduceMotion
                  ? glow
                  : Animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                      effects: [
                        ScaleEffect(
                          begin: const Offset(0.95, 0.95),
                          end: const Offset(1.05, 1.05),
                          duration: durationGlowLoop,
                          curve: Curves.easeInOut,
                        ),
                      ],
                      child: glow,
                    ),
            ),
          _buildAnimatedMascot(assetPath, reduceMotion),
        ],
      ),
    );
  }

  Widget _buildAnimatedMascot(String assetPath, bool reduceMotion) {
    Widget mascot = MascotImage(
      assetPath: assetPath,
      width: widget.size * 0.96,
      height: widget.size * 0.96,
      hero: true,
      wavesOnTap: widget.wavesOnTap,
      hopOnLoad: widget.jumpOnLoad,
      waveCount: _waves,
      routine: widget.routine,
    );

    // Code-drawn mascots have their own idle motion; floating the widget
    // too would double the movement.
    if (!reduceMotion && !_drawn) {
      mascot = Animate(
        onPlay: (controller) => controller.repeat(reverse: true),
        effects: [
          MoveEffect(
            begin: Offset.zero,
            end: const Offset(0, -8),
            duration: 1500.ms,
            curve: Curves.easeInOut,
          ),
        ],
        child: mascot,
      );
    }

    return mascot;
  }
}

/// A small-size mascot avatar (e.g., selection screen, mascot collection).
class MascotAvatar extends StatelessWidget {
  const MascotAvatar({
    required this.assetPath,
    this.size = 120,
    this.animate = true,
    super.key,
  });

  final String assetPath;

  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    Widget mascot = MascotImage(
      assetPath: assetPath,
      width: size,
      height: size,
    );

    // Only SVG mascots need the float (see MascotDisplay).
    if (animate && assetPath.endsWith('.svg')) {
      mascot = Animate(
        onPlay: (controller) => controller.repeat(reverse: true),
        effects: [
          MoveEffect(
            begin: Offset.zero,
            end: const Offset(0, -5),
            duration: 1200.ms,
            curve: Curves.easeInOut,
          ),
        ],
        child: mascot,
      );
    }

    return SizedBox(width: size, height: size, child: mascot);
  }
}
