import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart' as rive;

import 'package:seed_app/core/constants/ui_constants.dart';
import '../providers/mascot_providers.dart';
import 'mascot_image.dart';

/// Displays the user's mascot with idle animation.
///
/// Features:
/// - Loads the correct SVG based on evolution stage
/// - Idle float animation (subtle up/down movement)
/// - Happy bounce animation (triggered via [mascotAnimationTriggerProvider])
class MascotDisplay extends ConsumerStatefulWidget {
  const MascotDisplay({
    this.size = 200,
    this.onTap,
    this.showGlow = true,
    super.key,
  });

  /// The size (width and height) of the mascot display.
  final double size;

  /// Callback when the mascot is tapped.
  final VoidCallback? onTap;

  /// Whether to show a glow effect behind the mascot.
  final bool showGlow;

  @override
  ConsumerState<MascotDisplay> createState() => _MascotDisplayState();
}

class _MascotDisplayState extends ConsumerState<MascotDisplay> {
  bool _isBouncing = false;

  // Rive face bindings; all stay null for SVG mascots or Rive files
  // without a view model, turning gaze and smile into no-ops.
  rive.ViewModelInstance? _faceVm;
  rive.ViewModelInstanceNumber? _lookX;
  rive.ViewModelInstanceNumber? _lookY;
  rive.ViewModelInstanceTrigger? _smile;
  rive.ViewModelInstanceNumber? _smileHold;

  // Screen size cached in build; pointer callbacks must not depend on
  // inherited widgets.
  Size _screenSize = Size.zero;

  @override
  void initState() {
    super.initState();
    // Eyes follow the pointer anywhere on screen, not just over the
    // mascot, so listen to all pointer traffic rather than local hits.
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onGlobalPointer);
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onGlobalPointer);
    _faceVm?.dispose();
    super.dispose();
  }

  void _onRiveInit(rive.RiveWidgetController controller) {
    _faceVm?.dispose();
    _faceVm = null;
    _lookX = null;
    _lookY = null;
    _smile = null;
    _smileHold = null;
    try {
      _faceVm = controller.dataBind(rive.DataBind.auto());
    } on rive.RiveDataBindException {
      // File has no view model yet; mascot animates but stays inert.
      return;
    }
    final vm = _faceVm!;
    // Properties may live on the root view model or the nested face one
    // (root property `face`, camelCase per Rive naming rules).
    _lookX = vm.number(mascotVmLookX) ?? vm.number('face/$mascotVmLookX');
    _lookY = vm.number(mascotVmLookY) ?? vm.number('face/$mascotVmLookY');
    _smile = vm.trigger(mascotVmSmile) ?? vm.trigger('face/$mascotVmSmile');
    _smileHold =
        vm.number(mascotVmSmileHold) ?? vm.number('face/$mascotVmSmileHold');
  }

  bool get _hasGaze => _lookX != null || _lookY != null;

  // Raw targets only: smoothing, idle wander, and blinks live in the
  // FaceRig script inside the Rive file, where the designer tunes them.
  void _onGlobalPointer(PointerEvent event) {
    if (!_hasGaze || !mounted) return;
    if (event is PointerUpEvent || event is PointerCancelEvent) {
      // Touch lifted: recentre. Mouse re-aims on its next hover event.
      _lookX?.value = 0;
      _lookY?.value = 0;
      return;
    }
    if (event is! PointerDownEvent &&
        event is! PointerMoveEvent &&
        event is! PointerHoverEvent) {
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;
    final center = box.localToGlobal(box.size.center(Offset.zero));
    final gaze = mascotGazeTarget(event.position, center, _screenSize);
    _lookX?.value = gaze.dx;
    _lookY?.value = gaze.dy;
  }

  void _triggerBounce() {
    setState(() => _isBouncing = true);
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        setState(() => _isBouncing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = ref.watch(activeMascotAssetPathProvider);
    final artboardName = ref.watch(
      activeStageDataProvider.select((stage) => stage?.artboardName),
    );

    // Smile trigger (e.g. when the user opens the action log).
    // Offstage mascots (inactive tabs) have frozen tickers and would
    // queue the smile and replay it on return; only the visible one
    // reacts.
    ref.listen(mascotSmileTriggerProvider, (_, shouldSmile) {
      // A defunct element must not touch context or the disposed view model.
      if (!context.mounted) return;
      if (shouldSmile && TickerMode.valuesOf(context).enabled) {
        _smile?.trigger();
        // Raise the hold so FaceRig pushes the next blink past the smile;
        // the provider flips back to false ~100ms later, dropping it to 0.
        _smileHold?.value = 1;
      } else if (!shouldSmile) {
        _smileHold?.value = 0;
      }
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
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    _screenSize = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: widget.onTap,
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
                      // Soft white feathering behind the mascot
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(
                            alpha: opacityModerate,
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
            _buildAnimatedMascot(assetPath, artboardName),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedMascot(String assetPath, String? artboardName) {
    Widget mascot = MascotImage(
      assetPath: assetPath,
      artboardName: artboardName,
      width: widget.size * 0.96,
      height: widget.size * 0.96,
      onRiveInit: _onRiveInit,
    );

    // Apply bounce animation
    if (_isBouncing) {
      mascot = mascot
          .animate()
          .scaleXY(begin: 1, end: 0.9, duration: 100.ms)
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

    // Apply idle float animation (only when not bouncing).
    // Rive mascots author their own idle motion; floating the widget too
    // would double the movement.
    if (!_isBouncing && !assetPath.endsWith('.riv')) {
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
    this.artboardName,
    this.size = 120,
    this.animate = true,
    super.key,
  });

  final String assetPath;

  /// Artboard for multi-artboard `.riv` assets; see [MascotImage].
  final String? artboardName;

  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    Widget mascot = MascotImage(
      assetPath: assetPath,
      artboardName: artboardName,
      width: size,
      height: size,
    );

    // Rive mascots author their own idle motion (see MascotDisplay).
    if (animate && !assetPath.endsWith('.riv')) {
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
