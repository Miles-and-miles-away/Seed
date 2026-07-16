import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';
import '../providers/settings_providers.dart';

/// Dialog shown when the user reaches a weekly streak milestone.
///
/// Features:
/// - Celebration animation with confetti
/// - Mascot display
/// - Week count and days display
/// - Encouraging message
class StreakMilestoneDialog extends ConsumerStatefulWidget {
  const StreakMilestoneDialog({
    required this.weekNumber,
    required this.totalDays,
    required this.onDismiss,
    super.key,
  });

  /// The milestone week number achieved (1, 2, 3, etc.).
  final int weekNumber;

  /// The total streak days.
  final int totalDays;

  /// Callback when the dialog is dismissed.
  final VoidCallback onDismiss;

  @override
  ConsumerState<StreakMilestoneDialog> createState() =>
      _StreakMilestoneDialogState();
}

class _StreakMilestoneDialogState extends ConsumerState<StreakMilestoneDialog>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late List<ConfettiParticle> _particles;
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
    _particles = List.generate(40, (_) => ConfettiParticle.random());

    // Start animations in sequence
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    // Start particles immediately
    unawaited(_particleController.repeat());

    // Show content after brief delay
    await Future<void>.delayed(durationNormal);
    if (mounted) {
      setState(() => _showContent = true);
    }

    // Show button after content animation
    await Future<void>.delayed(durationCelebration);
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
    // Mark milestone as seen
    await ref
        .read(settingsProvider.notifier)
        .markMilestoneSeen(widget.weekNumber);
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final assetPath = ref.watch(activeMascotAssetPathProvider);
    final artboardName = ref.watch(
      activeStageDataProvider.select((stage) => stage?.artboardName),
    );

    return CelebrationOverlay(
      children: [
        // Confetti particles
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: ConfettiPainter(
                  particles: _particles,
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(spacingXxxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                          l10n.streakMilestoneTitle,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 400.ms)
                        .slideY(begin: -0.2, end: 0),

                    const SizedBox(height: spacingXxxl),

                    // Mascot with glow
                    if (assetPath != null)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow effect
                          Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gold.withValues(
                                        alpha: opacityMedium,
                                      ),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 300.ms, duration: 500.ms)
                              .scale(
                                begin: const Offset(0.5, 0.5),
                                end: const Offset(1, 1),
                              ),

                          // Mascot (bouncing)
                          MascotImage(
                                assetPath: assetPath,
                                artboardName: artboardName,
                                width: 140,
                                height: 140,
                              )
                              .animate()
                              .fadeIn(delay: 400.ms, duration: 400.ms)
                              .scale(
                                begin: const Offset(0.3, 0.3),
                                end: const Offset(1, 1),
                                curve: Curves.elasticOut,
                                duration: 800.ms,
                              )
                              .then() // Chain animation
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .moveY(
                                begin: 0,
                                end: -8,
                                duration: 600.ms,
                                curve: Curves.easeInOut,
                              ),
                        ],
                      ),

                    const SizedBox(height: spacingXxxl),

                    // Week streak badge
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
                                Icons.local_fire_department,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(width: spacingSm),
                              Text(
                                l10n.streakMilestoneWeeks(widget.weekNumber),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 400.ms)
                        .scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                        ),

                    const SizedBox(height: spacingLg),

                    // Days count
                    Text(
                      l10n.streakMilestoneDays(widget.totalDays),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 900.ms, duration: 400.ms),

                    const SizedBox(height: spacingSm),

                    // Encouraging message
                    Text(
                      l10n.streakMilestoneKeepGoing,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),

                    const SizedBox(height: spacingXxxl),

                    // Continue button
                    if (_showButton)
                      FilledButton(
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
                            child: Text(l10n.streakMilestoneContinue),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Shows the streak milestone celebration dialog.
///
/// Call this method when a weekly milestone is crossed.
Future<void> showStreakMilestoneCelebration(
  BuildContext context, {
  required int weekNumber,
  required int totalDays,
}) {
  return showCelebrationOverlay(
    context,
    (onDismiss) => StreakMilestoneDialog(
      weekNumber: weekNumber,
      totalDays: totalDays,
      onDismiss: onDismiss,
    ),
  );
}
