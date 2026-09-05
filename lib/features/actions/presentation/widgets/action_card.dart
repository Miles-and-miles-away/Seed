import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/constants/action_icons.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

/// The shared grid-tile look for anything logged from the Action log:
/// accent bar, icon, title and a small badge. Kept generic so entries
/// that are not library actions (the carbon calculators) match exactly.
class ActionTile extends StatelessWidget {
  const ActionTile({
    required this.accentColor,
    required this.contentColor,
    required this.icon,
    required this.title,
    required this.badgeLabel,
    required this.onTap,
    this.badgeIcon,
    this.footer,
    super.key,
  });

  final Color accentColor;
  final Color contentColor;
  final IconData icon;
  final String title;
  final String badgeLabel;
  final IconData? badgeIcon;
  final Widget? footer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 4, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(spacingLg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 36, color: contentColor),
                    const SizedBox(height: spacingSm),
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: spacingXs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacingSm,
                        vertical: spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: contentColor.withValues(alpha: opacityFaint),
                        borderRadius: borderRadiusMd,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (badgeIcon != null) ...[
                            Icon(badgeIcon, size: 12, color: contentColor),
                            const SizedBox(width: spacingXs),
                          ],
                          Flexible(
                            child: Text(
                              badgeLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                // Darkened: the raw category colour on
                                // a tint of itself is about 1.5:1, so
                                // the label washed out. The accent bar
                                // and the icon keep the colour as it is.
                                color: readableTextColor(
                                  contentColor,
                                  theme.brightness,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (footer != null) ...[const SizedBox(height: 6), footer!],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A card widget displaying an action that can be logged.
class ActionCard extends ConsumerWidget {
  const ActionCard({
    required this.action,
    required this.languageCode,
    required this.onTap,
    super.key,
  });

  final ActionModel action;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final category = ActionCategory.fromString(action.category);
    final categoryColor = category?.color ?? theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context);
    final goalMap = ref.watch(sdgGoalsDataProvider).value?.goalMap ?? {};

    final isLearnOnly = action.isLearnOnly;

    return ActionTile(
      accentColor: categoryColor,
      contentColor: isLearnOnly ? theme.colorScheme.outline : categoryColor,
      icon: getActionIcon(action.iconName),
      title: action.name(languageCode),
      badgeLabel: isLearnOnly
          ? l10n.learnOnlyBadge
          : l10n.pointsLabel(action.points),
      badgeIcon: isLearnOnly ? Icons.menu_book : null,
      footer: action.relatedSdgs.isEmpty
          ? null
          : _buildSdgBadges(action.relatedSdgs, goalMap),
      onTap: onTap,
    );
  }

  /// Builds a row of small SDG badges showing which goals this action supports.
  Widget _buildSdgBadges(List<String> sdgNumbers, Map<int, SdgGoal> goalMap) {
    // Parse and sort SDG numbers, limit to 4 visible badges
    final parsedNumbers =
        sdgNumbers
            .map(int.tryParse)
            .whereType<int>()
            .where((n) => n >= 1 && n <= 17)
            .toList()
          ..sort();

    final visibleCount = parsedNumbers.length > 4 ? 3 : parsedNumbers.length;
    final remainingCount = parsedNumbers.length - visibleCount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < visibleCount; i++) ...[
          if (i > 0) const SizedBox(width: 3),
          _buildSdgBadge(parsedNumbers[i], goalMap),
        ],
        if (remainingCount > 0) ...[
          const SizedBox(width: 3),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+$remainingCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Builds a single SDG badge with the goal number and color.
  Widget _buildSdgBadge(int sdgNumber, Map<int, SdgGoal> goalMap) {
    final sdg = goalMap[sdgNumber];
    final color = sdg?.color ?? Colors.grey;

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '$sdgNumber',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
