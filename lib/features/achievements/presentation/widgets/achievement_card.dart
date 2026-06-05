import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_progress.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_icons.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_progress_bar.dart';

/// Detailed achievement row: icon on the left, name + description
/// stacked, and (for numeric criteria) a progress bar at the bottom.
/// Used in the "Next Up" section and anywhere we need more context
/// than `AchievementBadge` provides.
class AchievementCard extends StatelessWidget {
  const AchievementCard({
    required this.definition,
    required this.progress,
    required this.isUnlocked,
    super.key,
    this.onTap,
  });

  final AchievementDefinition definition;
  final AchievementProgress progress;
  final bool isUnlocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).languageCode;

    final iconBg = isUnlocked
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final iconFg = isUnlocked
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant.withValues(alpha: opacityMuted);

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: borderRadiusLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadiusLg,
        child: Padding(
          padding: const EdgeInsets.all(spacingLg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievementIconFor(definition.iconName),
                  size: 24,
                  color: iconFg,
                ),
              ),
              const SizedBox(width: spacingLg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition.name(locale),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: spacingXxs),
                    Text(
                      definition.description(locale),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (progress.hasProgress) ...[
                      const SizedBox(height: spacingMd),
                      AchievementProgressBar(progress: progress),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
