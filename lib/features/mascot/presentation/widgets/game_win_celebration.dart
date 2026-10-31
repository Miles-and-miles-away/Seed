import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';

const _mascotSize = 160.0;
const _stay = Duration(seconds: 3);

/// Confetti, and the mascot rising from the bottom edge to smile, for a
/// game won. Plays once when built and lies over the game without
/// taking taps; key it to the round so a new round can play it again.
class GameWinCelebration extends ConsumerStatefulWidget {
  const GameWinCelebration({super.key});

  @override
  ConsumerState<GameWinCelebration> createState() => _GameWinCelebrationState();
}

class _GameWinCelebrationState extends ConsumerState<GameWinCelebration>
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
    ref
        .read(mascotSmileTriggerProvider.notifier)
        .triggerSmile(hold: durationCelebration);
    _stayTimer = Timer(_stay, () {
      if (mounted) _rise!.reverse();
    });
  }

  @override
  void dispose() {
    _stayTimer?.cancel();
    _rise!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asset = ref.watch(activeMascotAssetPathProvider);
    return IgnorePointer(
      child: Stack(
        children: [
          if (!_reduceMotion)
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
                child: const MascotDisplay(size: _mascotSize, showGlow: false),
              ),
            ),
        ],
      ),
    );
  }
}
