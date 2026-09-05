import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

/// Preview card for the next evolution stage: darkened art, levels to go,
/// and a progress bar toward the required mascot level.
class NextEvolutionCard extends StatelessWidget {
  const NextEvolutionCard({
    required this.nextStage,
    required this.mascotLevel,
    super.key,
  });

  final EvolutionStageModel nextStage;
  final int mascotLevel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final stageName = nextStage.name(locale);
    final levelsNeeded = nextStage.level - mascotLevel;
    final progress = mascotLevel / nextStage.level;

    return Container(
      padding: const EdgeInsets.all(spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: opacityHalf),
            colorScheme.secondaryContainer.withValues(alpha: opacityHalf),
          ],
        ),
        borderRadius: borderRadiusLg,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(spacingSm),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: borderRadiusMd,
            ),
            child: Opacity(
              opacity: opacityModerate,
              child: MascotImage(
                assetPath: nextStage.assetPath,
                artboardName: nextStage.artboardName,
              ),
            ),
          ),
          const SizedBox(width: spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stageName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: spacingXs),
                Text(
                  l10n.mascotLevelsToGo(levelsNeeded),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: spacingSm),
                ClipRRect(
                  borderRadius: borderRadiusXs,
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                ),
                const SizedBox(height: spacingXs),
                Text(
                  l10n.mascotLevelProgress(mascotLevel, nextStage.level),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
