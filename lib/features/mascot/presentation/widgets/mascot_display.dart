import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart' as rive;

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import '../providers/mascot_providers.dart';
import 'mascot_image.dart';

/// Controller for triggering mascot animations from external widgets.
class MascotAnimationController extends ChangeNotifier {
  bool _shouldBounce = false;
  bool _disposed = false;

  /// Whether a bounce animation should be triggered.
  bool get shouldBounce => _shouldBounce;

  /// Triggers the happy bounce animation.
  void triggerBounce() {
    _shouldBounce = true;
    notifyListeners();
    // Reset after animation completes; the controller may have been
    // disposed with its widget before the delay elapses.
    Future.delayed(durationSlow, () {
      if (_disposed) return;
      _shouldBounce = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Displays the user's mascot with idle animation.
///
/// Features:
/// - Loads the correct SVG based on evolution stage
/// - Idle float animation (subtle up/down movement)
/// - Tap feedback animation
/// - Happy bounce animation (triggered via controller)
class MascotDisplay extends ConsumerStatefulWidget {
  const MascotDisplay({
    this.size = 200,
    this.animationController,
    this.onTap,
    this.showGlow = true,
    super.key,
  });

  /// The size (width and height) of the mascot display.
  final double size;

  /// Controller for triggering animations from external widgets.
  final MascotAnimationController? animationController;

  /// Callback when the mascot is tapped.
  final VoidCallback? onTap;

  /// Whether to show a glow effect behind the mascot.
  final bool showGlow;

  @override
  ConsumerState<MascotDisplay> createState() => _MascotDisplayState();
}

class _MascotDisplayState extends ConsumerState<MascotDisplay>
    with SingleTickerProviderStateMixin {
  bool _isBouncing = false;
  bool _isTapped = false;

  // Rive face bindings; all stay null for SVG mascots or Rive files
  // without a view model, turning gaze and smile into no-ops.
  rive.ViewModelInstance? _faceVm;
  rive.ViewModelInstanceNumber? _lookX;
  rive.ViewModelInstanceNumber? _lookY;
  rive.ViewModelInstanceTrigger? _smile;

  @override
  void initState() {
    super.initState();
    widget.animationController?.addListener(_onAnimationControllerChange);
  }

  @override
  void didUpdateWidget(covariant MascotDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationController != widget.animationController) {
      oldWidget.animationController
          ?.removeListener(_onAnimationControllerChange);
      widget.animationController?.addListener(_onAnimationControllerChange);
    }
  }

  @override
  void dispose() {
    widget.animationController?.removeListener(_onAnimationControllerChange);
    _faceVm?.dispose();
    super.dispose();
  }

  void _onRiveInit(rive.RiveWidgetController controller) {
    _faceVm?.dispose();
    _faceVm = null;
    _lookX = null;
    _lookY = null;
    _smile = null;
    try {
      _faceVm = controller.dataBind(rive.DataBind.auto());
    } on rive.RiveDataBindException {
      // File has no view model yet; mascot animates but stays inert.
      return;
    }
    final vm = _faceVm!;
    // Properties may live on the root view model or the nested Face one.
    _lookX = vm.number(mascotVmLookX) ?? vm.number('Face/$mascotVmLookX');
    _lookY = vm.number(mascotVmLookY) ?? vm.number('Face/$mascotVmLookY');
    _smile = vm.trigger(mascotVmSmile) ?? vm.trigger('Face/$mascotVmSmile');
  }

  bool get _hasGaze => _lookX != null || _lookY != null;

  // Raw targets only: smoothing, idle wander, and blinks live in the
  // FaceRig script inside the Rive file, where the designer tunes them.
  void _onPointer(PointerEvent event) {
    if (!_hasGaze) return;
    final half = widget.size / 2;
    _lookX?.value = ((event.localPosition.dx - half) / half).clamp(-1.0, 1.0) *
        mascotLookRange;
    _lookY?.value = ((event.localPosition.dy - half) / half).clamp(-1.0, 1.0) *
        mascotLookRange;
  }

  void _onPointerEnd(PointerEvent event) {
    _lookX?.value = 0;
    _lookY?.value = 0;
  }

  void _onAnimationControllerChange() {
    if ((widget.animationController?.shouldBounce ?? false) && !_isBouncing) {
      _triggerBounce();
    }
  }

  void _triggerBounce() {
    setState(() => _isBouncing = true);
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        setState(() => _isBouncing = false);
      }
    });
  }

  void _onTapDown(TapDownDetails _) {
    setState(() => _isTapped = true);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isTapped = false);
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() => _isTapped = false);
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = ref.watch(activeMascotAssetPathProvider);
    final glowColor = ref.watch(
      activeMascotStageProvider.select(_getGlowColor),
    );

    // Smile trigger (e.g. when the user opens the action log)
    ref.listen(mascotSmileTriggerProvider, (_, shouldSmile) {
      if (shouldSmile) _smile?.trigger();
    });

    // Watch for external bounce triggers (e.g., after logging an action)
    final shouldBounceFromProvider = ref.watch(mascotAnimationTriggerProvider);
    if (shouldBounceFromProvider && !_isBouncing) {
      // Trigger bounce on next frame to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _triggerBounce();
      });
    }

    if (assetPath == null) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      // Raw pointer events (not a drag gesture) so the eyes can follow
      // the finger without stealing scroll from ancestor scrollables.
      child: Listener(
        onPointerDown: _onPointer,
        onPointerMove: _onPointer,
        onPointerUp: _onPointerEnd,
        onPointerCancel: _onPointerEnd,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect (wrapped in RepaintBoundary for Impeller compatibility)
              if (widget.showGlow)
                RepaintBoundary(
                  child: Animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                    effects: [
                      ScaleEffect(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1.05, 1.05),
                        duration: 2.seconds,
                        curve: Curves.easeInOut,
                      ),
                    ],
                    child: Container(
                      width: widget.size * 0.9,
                      height: widget.size * 0.9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: glowColor.withValues(
                              alpha: opacityMuted,
                            ),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Mascot with animations
              _buildAnimatedMascot(assetPath),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedMascot(String assetPath) {
    Widget mascot = MascotImage(
      assetPath: assetPath,
      width: widget.size * 0.8,
      height: widget.size * 0.8,
      onRiveInit: _onRiveInit,
    );

    // Apply tap feedback
    if (_isTapped) {
      mascot = Transform.scale(
        scale: 0.95,
        child: mascot,
      );
    }

    // Apply bounce animation
    if (_isBouncing) {
      mascot = mascot
          .animate()
          .scaleXY(
            begin: 1,
            end: 0.9,
            duration: 100.ms,
          )
          .then()
          .scaleXY(
            begin: 0.9,
            end: 1.15,
            duration: 150.ms,
            curve: Curves.easeOut,
          )
          .then()
          .scaleXY(
            begin: 1.15,
            end: 1,
            duration: 200.ms,
            curve: Curves.bounceOut,
          );
    }

    // Apply idle float animation (only when not bouncing or tapped)
    if (!_isBouncing && !_isTapped) {
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

  static const _glowColors = {
    1: AppColors.glowEarth,
    2: AppColors.glowFresh,
    3: AppColors.glowVibrant,
    4: AppColors.gold,
  };

  static Color _getGlowColor(int stage) =>
      _glowColors[stage] ?? _glowColors[1]!;
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

    if (animate) {
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

    return SizedBox(
      width: size,
      height: size,
      child: mascot,
    );
  }
}
