import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/constants/action_icons.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

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

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Category color accent bar
            Container(
              height: 4,
              color: categoryColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Icon(
                      getActionIcon(action.iconName),
                      size: 36,
                      color: action.isLearnOnly
                          ? theme.colorScheme.outline
                          : categoryColor,
                    ),
                    const SizedBox(height: Spacing.sm),
                    // Action name
                    Text(
                      action.name(languageCode),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    // Points badge or Learn Only badge
                    if (action.isLearnOnly)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.12),
                          borderRadius: Radii.borderMd,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.menu_book,
                              size: 12,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(width: Spacing.xs),
                            Text(
                              l10n.learnOnlyBadge,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.outline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(
                            alpha: Opacities.faint,
                          ),
                          borderRadius: Radii.borderMd,
                        ),
                        child: Text(
                          l10n.pointsLabel(action.points),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: categoryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    // SDG badges
                    if (action.relatedSdgs.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      _buildSdgBadges(action.relatedSdgs, goalMap),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a row of small SDG badges showing which goals this action supports.
  Widget _buildSdgBadges(
    List<String> sdgNumbers,
    Map<int, SdgGoal> goalMap,
  ) {
    // Parse and sort SDG numbers, limit to 4 visible badges
    final parsedNumbers = sdgNumbers
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
  Widget _buildSdgBadge(
    int sdgNumber,
    Map<int, SdgGoal> goalMap,
  ) {
    final sdg = goalMap[sdgNumber];
    final color = sdg?.color ?? Colors.grey;

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
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
