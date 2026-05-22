import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_icons.dart';

/// Compact icon-and-name representation of an achievement. Used in
/// the horizontal scroll on the Profile screen and the Unlocked /
/// Locked grids on the AchievementsScreen.
class AchievementBadge extends StatelessWidget {
  const AchievementBadge({
    required this.definition,
    required this.isUnlocked,
    super.key,
    this.size = 64,
    this.onTap,
  });

  final AchievementDefinition definition;
  final bool isUnlocked;
  final double size;
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
        : colorScheme.onSurfaceVariant.withValues(alpha: Opacities.muted);
    final labelColor = isUnlocked
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant.withValues(alpha: Opacities.moderate);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            achievementIconFor(definition.iconName),
            size: size * 0.5,
            color: iconFg,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        SizedBox(
          width: size + Spacing.md,
          child: Text(
            definition.name(locale),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(color: labelColor),
          ),
        ),
      ],
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: Radii.borderMd,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xs),
        child: content,
      ),
    );
  }
}
