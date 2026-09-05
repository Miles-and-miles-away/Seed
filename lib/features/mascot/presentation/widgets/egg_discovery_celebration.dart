import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';
import '../providers/mascot_providers.dart';

/// Full-screen celebration shown when a mysterious egg appears.
///
/// Modeled after EvolutionCelebration with the same overlay
/// pattern -- confetti, dramatic entrance, and dismiss button.
class EggDiscoveryCelebration extends ConsumerStatefulWidget {
  const EggDiscoveryCelebration({required this.onDismiss, super.key});

  final VoidCallback onDismiss;

  @override
  ConsumerState<EggDiscoveryCelebration> createState() =>
      _EggDiscoveryCelebrationState();
}

class _EggDiscoveryCelebrationState
    extends ConsumerState<EggDiscoveryCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late List<_Sparkle> _sparkles;
  bool _showContent = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: durationGlowLoop,
    );

    _sparkles = List.generate(30, (_) => _Sparkle.random());

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    unawaited(_glowController.repeat(reverse: true));

    await Future<void>.delayed(durationNormal);
    if (mounted) setState(() => _showContent = true);

    await Future<void>.delayed(durationShowcase);
    if (mounted) setState(() => _showButton = true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _handleDismiss() async {
    await ref.read(mascotProvider.notifier).acknowledgeEggDiscovery();
    if (mounted) widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final mascot = ref.watch(activeMascotProvider).value;

    return CelebrationOverlay(
      children: [
        ConfettiLayer(
          painter: (progress) =>
              _SparklePainter(sparkles: _sparkles, progress: progress),
        ),

        // Content
        if (_showContent)
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                CelebrationTitle(l10n.eggDiscoveryTitle, delay: 100.ms),

                const Spacer(),

                // Egg with pulsing glow
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    final glowAlpha = 0.3 + _glowController.value * 0.3;
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.glowBlue.withValues(
                              alpha: glowAlpha,
                            ),
                            blurRadius: 60,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  child:
                      const Icon(
                            Icons.egg_outlined,
                            size: 120,
                            color: AppColors.eggBeige,
                          )
                          .animate()
                          .fadeIn(delay: 500.ms, duration: 600.ms)
                          .scale(
                            begin: const Offset(0.3, 0.3),
                            end: const Offset(1, 1),
                            curve: Curves.elasticOut,
                            duration: 800.ms,
                          ),
                ),

                const Spacer(),

                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: spacingXxxl),
                  child: Text(
                    l10n.eggDiscoveryMessage(mascot?.name ?? ''),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
                ),

                const SizedBox(height: spacingMd),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: spacingHuge),
                  child: Text(
                    l10n.eggDiscoverySubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
                ),

                const Spacer(flex: 2),

                // Dismiss button
                if (_showButton)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: spacingHuge,
                    ),
                    child: CelebrationButton(
                      label: l10n.eggDiscoveryDismiss,
                      onPressed: _handleDismiss,
                    ),
                  ),

                const SizedBox(height: spacingHuge),
              ],
            ),
          ),
      ],
    );
  }
}

// Sparkle particle for egg discovery
class _Sparkle {
  _Sparkle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });

  factory _Sparkle.random() => _Sparkle(
    x: _rng.nextDouble(),
    y: _rng.nextDouble(),
    size: _rng.nextDouble() * 4 + 2,
    speed: _rng.nextDouble() * 0.5 + 0.5,
    phase: _rng.nextDouble() * pi * 2,
  );

  static final _rng = Random();

  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;
}

class _SparklePainter extends CustomPainter {
  _SparklePainter({required this.sparkles, required this.progress});

  final List<_Sparkle> sparkles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sparkles) {
      final alpha = (sin(progress * pi * 2 * s.speed + s.phase) + 1) / 2;
      final paint = Paint()
        ..color = AppColors.glowBlue.withValues(alpha: alpha * 0.6);

      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter old) => true;
}

/// Shows the egg discovery celebration as a dialog overlay.
Future<void> showEggDiscoveryCelebration(BuildContext context, WidgetRef ref) {
  return showCelebrationOverlay(
    context,
    (onDismiss) => EggDiscoveryCelebration(onDismiss: onDismiss),
  );
}
