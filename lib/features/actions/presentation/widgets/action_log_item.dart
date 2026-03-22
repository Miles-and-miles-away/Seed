import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';

/// A list item displaying a logged action.
class ActionLogItem extends StatelessWidget {
  const ActionLogItem({
    required this.actionLog,
    super.key,
  });

  final ActionLogModel actionLog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = ActionCategory.fromString(actionLog.category);
    final categoryColor = category?.color ?? theme.colorScheme.primary;
    final timeFormat = DateFormat.jm();

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.xs,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Row(
          children: [
            // Category icon
            Container(
              width: Spacing.huge,
              height: Spacing.huge,
              decoration: BoxDecoration(
                color: categoryColor.withValues(
                  alpha: Opacities.faint,
                ),
                borderRadius: Radii.borderMd,
              ),
              child: Icon(
                category?.icon ?? Icons.eco,
                color: categoryColor,
              ),
            ),
            const SizedBox(width: Spacing.md),
            // Action details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actionLog.actionName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Row(
                    children: [
                      Text(
                        timeFormat.format(actionLog.loggedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (actionLog.co2Grams > 0) ...[
                        const SizedBox(width: Spacing.sm),
                        Icon(
                          Icons.eco,
                          size: 12,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: Spacing.xxs),
                        Text(
                          formatCO2Compact(actionLog.co2Grams),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (actionLog.note != null && actionLog.note!.isNotEmpty) ...[
                    const SizedBox(height: Spacing.xs),
                    Text(
                      actionLog.note!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Points badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: categoryColor.withValues(
                  alpha: Opacities.faint,
                ),
                borderRadius: Radii.borderLg,
              ),
              child: Text(
                '${actionLog.points}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: categoryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
