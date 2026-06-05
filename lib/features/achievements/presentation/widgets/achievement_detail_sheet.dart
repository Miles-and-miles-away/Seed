import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_progress.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_icons.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_progress_bar.dart';

const double _iconCircleSize = 72;

/// Bottom sheet with the full detail for one achievement: how to
/// earn it (the criteria description), the bonus-point reward, and
/// either current progress (locked) or the unlock date (unlocked).
/// Opened by tapping an [AchievementBadge] or an `AchievementCard`.
class AchievementDetailSheet extends StatelessWidget {
  const AchievementDetailSheet({
    required this.definition,
    required this.isUnlocked,
    super.key,
    this.progress,
    this.unlockedAt,
  });

  final AchievementDefinition definition;
  final bool isUnlocked;

  /// Progress toward the criteria. Only rendered when locked.
  final AchievementProgress? progress;

  /// When the user unlocked this achievement. Only rendered when
  /// unlocked; null hides the date line (e.g. legacy records).
  final DateTime? unlockedAt;

  /// Shows the sheet modally. Mirrors the [showModalBottomSheet]
  /// conventions used elsewhere in the app (drag handle, rounded
  /// top corners).
  static void show(
    BuildContext context, {
    required AchievementDefinition definition,
    required bool isUnlocked,
    AchievementProgress? progress,
    DateTime? unlockedAt,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (_) => AchievementDetailSheet(
        definition: definition,
        isUnlocked: isUnlocked,
        progress: progress,
        unlockedAt: unlockedAt,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    // Mirror AchievementBadge's unlocked/locked palette so the sheet
    // reads as a zoomed-in view of the badge that opened it.
    final iconBg = isUnlocked
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final iconFg = isUnlocked
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant.withValues(alpha: opacityMuted);

    final lockedProgress = progress;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          spacingXxl,
          spacingSm,
          spacingXxl,
          spacingXxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: _iconCircleSize,
              height: _iconCircleSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievementIconFor(definition.iconName),
                size: _iconCircleSize * 0.5,
                color: iconFg,
              ),
            ),
            const SizedBox(height: spacingLg),
            Text(
              definition.name(locale),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingSm),
            Text(
              definition.description(locale),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingLg),
            _RewardChip(points: definition.bonusPoints),
            if (isUnlocked && unlockedAt != null) ...[
              const SizedBox(height: spacingLg),
              Text(
                l10n.achievementDetailUnlockedOn(unlockedAt!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (!isUnlocked &&
                lockedProgress != null &&
                lockedProgress.hasProgress) ...[
              const SizedBox(height: spacingXl),
              AchievementProgressBar(progress: lockedProgress),
            ],
          ],
        ),
      ),
    );
  }
}

/// Centered pill showing the bonus-point reward for unlocking.
class _RewardChip extends StatelessWidget {
  const _RewardChip({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Align(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: spacingLg,
          vertical: spacingSm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: borderRadiusXl,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.stars,
              size: 18,
              color: colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: spacingSm),
            Text(
              l10n.achievementDetailReward(points),
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
