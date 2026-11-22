import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/utils/reduce_motion.dart';

/// Celebration card shown when the mascot has reached its final stage,
/// nudging toward the egg when one is in progress.

// The darker gradient stop, so the ink holds across the whole card.
final _ink = inkOnFill(AppColors.celebrationOrange);

class MaxEvolutionCard extends StatelessWidget {
  const MaxEvolutionCard({required this.hasEgg, super.key});

  final bool hasEgg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return RepaintBoundary(
      child:
          Container(
                padding: const EdgeInsets.all(spacingXxl),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.gold, AppColors.celebrationOrange],
                  ),
                  borderRadius: borderRadiusLg,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: opacityMuted),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(spacingMd),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: opacityLight),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.emoji_events, color: _ink, size: 32),
                    ),
                    const SizedBox(width: spacingLg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.maxEvolutionTitle,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _ink,
                            ),
                          ),
                          const SizedBox(height: spacingXs),
                          Text(
                            hasEgg
                                ? l10n.maxEvolutionEggHint
                                : l10n.maxEvolutionSubtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate(
                autoPlay: !reduceMotionOf(context),
                onPlay: (c) => c.repeat(reverse: true),
              )
              .shimmer(
                duration: 2.seconds,
                color: Colors.white.withValues(alpha: opacityMuted),
              ),
    );
  }
}
