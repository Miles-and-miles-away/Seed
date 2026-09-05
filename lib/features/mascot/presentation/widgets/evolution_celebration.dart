import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';
import '../providers/mascot_providers.dart';
import 'mascot_image.dart';

/// Full-screen celebration overlay shown when the mascot evolves to a new stage.
///
/// Features:
/// - Dramatic entrance animation
/// - Confetti/sparkle particle effects
/// - Before/after mascot comparison
/// - Stage name reveal
/// - Dismiss button
class EvolutionCelebration extends ConsumerStatefulWidget {
  const EvolutionCelebration({required this.onDismiss, super.key});

  /// Callback when the celebration is dismissed.
  final VoidCallback onDismiss;

  @override
  ConsumerState<EvolutionCelebration> createState() =>
      _EvolutionCelebrationState();
}

class _EvolutionCelebrationState extends ConsumerState<EvolutionCelebration> {
  late List<ConfettiParticle> _particles;
  bool _showContent = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(50, (_) => ConfettiParticle.random());
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
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

  Future<void> _handleDismiss() async {
    // Mark evolution as seen before dismissing
    await ref.read(mascotProvider.notifier).markEvolutionSeen();
    if (mounted) widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final assetPath = ref.watch(activeMascotAssetPathProvider);
    final artboardName = ref.watch(
      activeStageDataProvider.select((stage) => stage?.artboardName),
    );
    final stageName = ref.watch(stageLocalizedNameProvider(locale));
    final species = ref.watch(activeSpeciesProvider);
    final currentStage = ref.watch(activeMascotStageProvider);
    final mascotName = ref.watch(
      activeMascotProvider.select((a) => a.value?.name),
    );

    // Get the previous stage asset path
    String? previousAssetPath;
    String? previousArtboardName;
    if (species != null && currentStage > 1) {
      final previousStageIndex = currentStage - 2; // 0-indexed
      if (previousStageIndex < species.evolutionStages.length) {
        previousAssetPath =
            species.evolutionStages[previousStageIndex].assetPath;
        previousArtboardName =
            species.evolutionStages[previousStageIndex].artboardName;
      }
    }

    return CelebrationOverlay(
      children: [
        ConfettiLayer(
          painter: (progress) => ConfettiPainter(
            particles: _particles,
            colors: [
              AppColors.gold,
              colorScheme.primary,
              colorScheme.secondary,
              AppColors.success,
              AppColors.celebrationPink,
            ],
            progress: progress,
          ),
        ),

        // Main content
        if (_showContent)
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                CelebrationTitle(l10n.evolutionTitle, delay: 100.ms),

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
                        Opacity(
                          opacity: opacityHalf,
                          child: MascotImage(
                            assetPath: previousAssetPath,
                            artboardName: previousArtboardName,
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
                            MascotImage(
                                  assetPath: assetPath,
                                  artboardName: artboardName,
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
                          colors: [AppColors.gold, AppColors.celebrationOrange],
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
                          const Icon(Icons.star, color: Colors.white, size: 24),
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
                    )
                    .animate()
                    .fadeIn(delay: 1000.ms, duration: 400.ms)
                    .scale(
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
                    child: CelebrationButton(
                      label: l10n.evolutionContinue,
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

/// Shows the evolution celebration as an overlay.
///
/// Call this method when [hasNewEvolutionProvider] returns true.
Future<void> showEvolutionCelebration(BuildContext context) {
  return showCelebrationOverlay(
    context,
    (onDismiss) => EvolutionCelebration(onDismiss: onDismiss),
  );
}
