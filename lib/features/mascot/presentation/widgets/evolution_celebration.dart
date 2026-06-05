import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import '../providers/mascot_providers.dart';

/// Full-screen celebration overlay shown when the mascot evolves to a new stage.
///
/// Features:
/// - Dramatic entrance animation
/// - Confetti/sparkle particle effects
/// - Before/after mascot comparison
/// - Stage name reveal
/// - Dismiss button
class EvolutionCelebration extends ConsumerStatefulWidget {
  const EvolutionCelebration({
    required this.onDismiss,
    super.key,
  });

  /// Callback when the celebration is dismissed.
  final VoidCallback onDismiss;

  @override
  ConsumerState<EvolutionCelebration> createState() =>
      _EvolutionCelebrationState();
}

class _EvolutionCelebrationState extends ConsumerState<EvolutionCelebration>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late List<_Particle> _particles;
  bool _showContent = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: durationParticleLoop,
    );

    // Generate confetti particles
    _particles = List.generate(50, (_) => _Particle.random());

    // Start animations in sequence
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    // Start particles immediately
    unawaited(_particleController.repeat());

    // Show content after brief delay for dramatic effect
    await Future<void>.delayed(durationNormal);
    if (mounted) {
      setState(() => _showContent = true);
    }

    await Future<void>.delayed(durationShowcase);
    if (mounted) {
      setState(() => _showButton = true);
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  Future<void> _handleDismiss() async {
    // Mark evolution as seen before dismissing
    await ref.read(mascotProvider.notifier).markEvolutionSeen();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final assetPath = ref.watch(mascotAssetPathProvider);
    final stageName = ref.watch(
      stageLocalizedNameProvider(locale),
    );
    final species = ref.watch(currentSpeciesProvider);
    final currentStage = ref.watch(currentMascotStageProvider);
    final mascotName = ref.watch(
      currentMascotProvider.select((a) => a.value?.name),
    );

    // Get the previous stage asset path
    String? previousAssetPath;
    if (species != null && currentStage > 1) {
      final previousStageIndex = currentStage - 2; // 0-indexed
      if (previousStageIndex >= 0 &&
          previousStageIndex < species.evolutionStages.length) {
        previousAssetPath =
            species.evolutionStages[previousStageIndex].assetPath;
      }
    }

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Backdrop (wrapped in RepaintBoundary for Impeller compatibility)
          RepaintBoundary(
            child: Container(
              color: Colors.black.withValues(
                alpha: opacityNearOpaque,
              ),
            ).animate().fadeIn(duration: 300.ms),
          ),

          // Confetti particles (wrapped in RepaintBoundary for Impeller compatibility)
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _ConfettiPainter(
                    particles: _particles,
                    progress: _particleController.value,
                    colors: [
                      AppColors.gold,
                      colorScheme.primary,
                      colorScheme.secondary,
                      AppColors.success,
                      AppColors.celebrationPink,
                    ],
                  ),
                );
              },
            ),
          ),

          // Main content
          if (_showContent)
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),

                  // Title
                  Text(
                    l10n.evolutionTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms)
                      .slideY(begin: -0.2, end: 0),

                  const SizedBox(height: spacingSm),

                  // Mascot name
                  Text(
                    mascotName ?? '',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                  const Spacer(),

                  // Evolution transition
                  SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Previous stage (faded)
                        if (previousAssetPath != null) ...[
                          ColorFiltered(
                            colorFilter: const ColorFilter.matrix(<double>[
                              1,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                              0,
                              0,
                              0,
                              0,
                              1,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0.5,
                              0,
                            ]),
                            child: SvgPicture.asset(
                              previousAssetPath,
                              width: 100,
                              height: 100,
                            ),
                          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                          const SizedBox(width: spacingLg),
                          Icon(
                            Icons.arrow_forward,
                            color: colorScheme.primary,
                            size: 32,
                          )
                              .animate()
                              .fadeIn(delay: 500.ms, duration: 400.ms)
                              .slideX(begin: -0.5, end: 0),
                          const SizedBox(width: spacingLg),
                        ],

                        // New stage (prominent)
                        if (assetPath != null)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glow effect
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gold.withValues(
                                        alpha: opacityHalf,
                                      ),
                                      blurRadius: 60,
                                      spreadRadius: 20,
                                    ),
                                  ],
                                ),
                              )
                                  .animate()
                                  .fadeIn(delay: 600.ms, duration: 600.ms)
                                  .scale(
                                    begin: const Offset(0.5, 0.5),
                                    end: const Offset(1, 1),
                                  ),

                              // Mascot
                              SvgPicture.asset(
                                assetPath,
                                width: 160,
                                height: 160,
                              )
                                  .animate()
                                  .fadeIn(delay: 700.ms, duration: 500.ms)
                                  .scale(
                                    begin: const Offset(0.3, 0.3),
                                    end: const Offset(1, 1),
                                    curve: Curves.elasticOut,
                                    duration: 800.ms,
                                  ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Stage badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: spacingXxl,
                      vertical: spacingMd,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.gold,
                          AppColors.celebrationOrange,
                        ],
                      ),
                      borderRadius: borderRadiusXxl,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(
                            alpha: opacityMedium,
                          ),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: spacingSm),
                        Text(
                          stageName ?? l10n.stageFallback(currentStage),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 1000.ms, duration: 400.ms).scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                        curve: Curves.elasticOut,
                      ),

                  const SizedBox(height: spacingLg),

                  // Subtitle
                  Text(
                    l10n.evolutionSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 1100.ms, duration: 400.ms),

                  const Spacer(flex: 2),

                  // Continue button
                  if (_showButton)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacingHuge,
                      ),
                      child: FilledButton(
                        onPressed: _handleDismiss,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: spacingHuge,
                            vertical: spacingLg,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: borderRadiusLg,
                          ),
                        ),
                        child: Text(l10n.evolutionContinue),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.3, end: 0),
                    ),

                  const SizedBox(height: spacingHuge),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A single confetti particle.
class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.colorIndex,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
  });

  factory _Particle.random() {
    final random = Random();
    return _Particle(
      x: random.nextDouble(),
      y: -random.nextDouble() * 0.5, // Start above screen
      size: random.nextDouble() * 10 + 5,
      speed: random.nextDouble() * 0.5 + 0.3,
      colorIndex: random.nextInt(5),
      rotation: random.nextDouble() * pi * 2,
      rotationSpeed: (random.nextDouble() - 0.5) * 0.2,
      shape: random.nextInt(3), // 0: rect, 1: circle, 2: star
    );
  }

  final double x;
  double y;
  final double size;
  final double speed;
  final int colorIndex;
  double rotation;
  final double rotationSpeed;
  final int shape;
}

/// Paints the confetti particles.
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.particles,
    required this.progress,
    required this.colors,
  });

  final List<_Particle> particles;
  final double progress;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Update particle position and rotation
      particle
        ..y += particle.speed * 0.02
        ..rotation += particle.rotationSpeed;

      // Reset if past bottom
      if (particle.y > 1.2) {
        particle.y = -0.1;
      }

      final x = particle.x * size.width;
      final y = particle.y * size.height;

      final paint = Paint()
        ..color = colors[particle.colorIndex].withValues(
          alpha: opacityHeavy,
        );

      canvas
        ..save()
        ..translate(x, y)
        ..rotate(particle.rotation);

      switch (particle.shape) {
        case 0: // Rectangle
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.6,
            ),
            paint,
          );
        case 1: // Circle
          canvas.drawCircle(Offset.zero, particle.size * 0.5, paint);
        case 2: // Star
          _drawStar(canvas, particle.size * 0.5, paint);
      }

      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, double radius, Paint paint) {
    final path = Path();
    const points = 5;
    const innerRadius = 0.4;

    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius * innerRadius;
      final angle = (i * pi / points) - (pi / 2);
      final x = r * cos(angle);
      final y = r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

/// Shows the evolution celebration as an overlay.
///
/// Call this method when [hasNewEvolutionProvider] returns true.
Future<void> showEvolutionCelebration(BuildContext context) async {
  await showGeneralDialog<void>(
    context: context,
    barrierColor: Colors.transparent,
    pageBuilder: (context, animation, secondaryAnimation) {
      return EvolutionCelebration(
        onDismiss: () => Navigator.of(context).pop(),
      );
    },
    transitionDuration: Duration.zero,
  );
}
