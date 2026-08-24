import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';

/// Celebration card shown when the mascot has reached its final stage,
/// nudging toward the egg when one is in progress.
class MaxEvolutionCard extends StatelessWidget {
  const MaxEvolutionCard({required this.hasEgg, super.key});

  final bool hasEgg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
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
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 32,
                ),
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: spacingXs),
                    Text(
                      hasEgg
                          ? l10n.maxEvolutionEggHint
                          : l10n.maxEvolutionSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(
          duration: 2.seconds,
          color: Colors.white.withValues(alpha: opacityMuted),
        );
  }
}
