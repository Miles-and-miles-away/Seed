import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_icons.dart';

const int _maxLabelLines = 2;

// Fallbacks matching M3 labelSmall, only used if a custom theme
// leaves the style undefined.
const double _fallbackLabelFontSize = 11;
const double _fallbackLabelHeightFactor = 16 / 11;

/// Compact icon-and-name representation of an achievement. Used in
/// the horizontal scroll on the Profile screen and the Unlocked /
/// Locked grids on the AchievementsScreen.
class AchievementBadge extends StatelessWidget {
  const AchievementBadge({
    required this.definition,
    required this.isUnlocked,
    super.key,
    this.size = defaultSize,
    this.onTap,
  });

  /// Icon-circle diameter used when callers don't override [size].
  static const double defaultSize = 64;

  final AchievementDefinition definition;
  final bool isUnlocked;
  final double size;
  final VoidCallback? onTap;

  /// Height a badge of [size] needs to render fully: icon circle,
  /// gap, and up to [_maxLabelLines] label lines at the ambient
  /// theme and text scale. Grid layouts should size cells with this
  /// instead of hard-coding a height, so the cell math can never
  /// drift from the badge's actual layout (e.g. under accessibility
  /// text scaling). The extra pixel of slack absorbs sub-pixel
  /// rounding in text layout.
  static double extentFor(BuildContext context, {double size = defaultSize}) {
    final style = Theme.of(context).textTheme.labelSmall;
    final fontSize = style?.fontSize ?? _fallbackLabelFontSize;
    final heightFactor = style?.height ?? _fallbackLabelHeightFactor;
    final lineHeight =
        MediaQuery.textScalerOf(context).scale(fontSize) * heightFactor;
    return size + spacingSm + _maxLabelLines * lineHeight + 1;
  }

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
    final labelColor = isUnlocked
        ? colorScheme.onSurface
        : colorScheme.onSurfaceVariant.withValues(alpha: opacityModerate);

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
        const SizedBox(height: spacingSm),
        SizedBox(
          width: size + spacingMd,
          child: Text(
            definition.name(locale),
            textAlign: TextAlign.center,
            maxLines: _maxLabelLines,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(color: labelColor),
          ),
        ),
      ],
    );

    // No padding around the tappable content: grid cells are sized
    // to the bare badge, and inflating it caused bottom overflow.
    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadiusMd,
      child: content,
    );
  }
}
