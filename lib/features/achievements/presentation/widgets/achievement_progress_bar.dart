import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_progress.dart';

/// Linear progress bar with a `current / target` label. Renders
/// nothing when `progress.hasProgress` is false so binary criteria
/// (special) cleanly opt out without the caller branching.
class AchievementProgressBar extends StatelessWidget {
  const AchievementProgressBar({
    required this.progress,
    super.key,
  });

  final AchievementProgress progress;

  @override
  Widget build(BuildContext context) {
    if (!progress.hasProgress) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: borderRadiusXs,
          child: LinearProgressIndicator(
            value: progress.fraction,
            minHeight: 6,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
        const SizedBox(height: spacingXs),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${progress.current} / ${progress.target}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
