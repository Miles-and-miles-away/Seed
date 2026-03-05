import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../providers/mascot_providers.dart';

/// Full-screen celebration shown when a mysterious egg appears.
///
/// Modeled after EvolutionCelebration with the same overlay
/// pattern -- confetti, dramatic entrance, and dismiss button.
class EggDiscoveryCelebration extends ConsumerStatefulWidget {
  const EggDiscoveryCelebration({
    required this.onDismiss,
    super.key,
  });

  final VoidCallback onDismiss;

  @override
  ConsumerState<EggDiscoveryCelebration> createState() =>
      _EggDiscoveryCelebrationState();
}

class _EggDiscoveryCelebrationState
    extends ConsumerState<EggDiscoveryCelebration>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _glowController;
  late List<_Sparkle> _sparkles;
  bool _showContent = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _sparkles = List.generate(30, (_) => _Sparkle.random());

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    unawaited(_particleController.repeat());
    unawaited(
      _glowController.repeat(reverse: true),
    );

    await Future<void>.delayed(
      const Duration(milliseconds: 300),
    );
    if (mounted) setState(() => _showContent = true);

    await Future<void>.delayed(
      const Duration(milliseconds: 1500),
    );
    if (mounted) setState(() => _showButton = true);
  }

  @override
  void dispose() {
    _particleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _handleDismiss() async {
    await ref.read(mascotProvider.notifier).acknowledgeEggDiscovery();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final mascot = ref.watch(activeMascotProvider).value;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Backdrop
          RepaintBoundary(
            child: Container(
              color: Colors.black.withValues(alpha: 0.85),
            ).animate().fadeIn(duration: 300.ms),
          ),

          // Sparkle particles
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _SparklePainter(
                    sparkles: _sparkles,
                    progress: _particleController.value,
                  ),
                );
              },
            ),
          ),

          // Content
          if (_showContent)
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),

                  // Title
                  Text(
                    l10n.eggDiscoveryTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(
                        delay: 100.ms,
                        duration: 400.ms,
                      )
                      .slideY(begin: -0.2, end: 0),

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
                              color: const Color(0xFF90CAF9).withValues(
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
                    child: const Icon(
                      Icons.egg_outlined,
                      size: 120,
                      color: Color(0xFFF5F5DC),
                    )
                        .animate()
                        .fadeIn(
                          delay: 500.ms,
                          duration: 600.ms,
                        )
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                    ),
                    child: Text(
                      l10n.eggDiscoveryMessage(
                        mascot?.name ?? '',
                      ),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(
                          delay: 800.ms,
                          duration: 400.ms,
                        ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                    ),
                    child: Text(
                      l10n.eggDiscoverySubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(
                          delay: 1000.ms,
                          duration: 400.ms,
                        ),
                  ),

                  const Spacer(flex: 2),

                  // Dismiss button
                  if (_showButton)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                      ),
                      child: FilledButton(
                        onPressed: _handleDismiss,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.eggDiscoveryDismiss,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.3, end: 0),
                    ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
        ],
      ),
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

  factory _Sparkle.random() {
    final rng = Random();
    return _Sparkle(
      x: rng.nextDouble(),
      y: rng.nextDouble(),
      size: rng.nextDouble() * 4 + 2,
      speed: rng.nextDouble() * 0.5 + 0.5,
      phase: rng.nextDouble() * pi * 2,
    );
  }

  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;
}

class _SparklePainter extends CustomPainter {
  _SparklePainter({
    required this.sparkles,
    required this.progress,
  });

  final List<_Sparkle> sparkles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sparkles) {
      final alpha = (sin(progress * pi * 2 * s.speed + s.phase) + 1) / 2;
      final paint = Paint()
        ..color = const Color(0xFF90CAF9).withValues(alpha: alpha * 0.6);

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
Future<void> showEggDiscoveryCelebration(
  BuildContext context,
  WidgetRef ref,
) async {
  await showGeneralDialog<void>(
    context: context,
    barrierColor: Colors.transparent,
    pageBuilder: (context, animation, secondaryAnimation) {
      return EggDiscoveryCelebration(
        onDismiss: () => Navigator.of(context).pop(),
      );
    },
    transitionDuration: Duration.zero,
  );
}
