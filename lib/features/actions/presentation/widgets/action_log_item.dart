import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/helpers.dart';
import '../../data/models/action_log_model.dart';
import '../../domain/enums/action_category.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category?.icon ?? Icons.eco,
                color: categoryColor,
              ),
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        timeFormat.format(actionLog.loggedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (actionLog.co2Grams > 0) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.eco,
                          size: 12,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 2),
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
                    const SizedBox(height: 4),
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
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
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
