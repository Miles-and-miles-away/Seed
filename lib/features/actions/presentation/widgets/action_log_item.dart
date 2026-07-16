import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';

/// A list item displaying a logged action.
class ActionLogItem extends StatelessWidget {
  const ActionLogItem({required this.actionLog, this.onTap, super.key});

  final ActionLogModel actionLog;

  /// Optional tap handler. When non-null, the card becomes interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = ActionCategory.fromString(actionLog.category);
    final categoryColor = category?.color ?? theme.colorScheme.primary;
    final timeFormat = DateFormat.jm(
      Localizations.localeOf(context).toString(),
    );

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: spacingLg,
        vertical: spacingXs,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(spacingLg),
          child: Row(
            children: [
              // Category icon
              Container(
                width: spacingHuge,
                height: spacingHuge,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: opacityFaint),
                  borderRadius: borderRadiusMd,
                ),
                child: Icon(category?.icon ?? Icons.eco, color: categoryColor),
              ),
              const SizedBox(width: spacingMd),
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
                    const SizedBox(height: spacingXxs),
                    Row(
                      children: [
                        Text(
                          timeFormat.format(actionLog.loggedAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (actionLog.co2Grams > 0) ...[
                          const SizedBox(width: spacingSm),
                          Icon(
                            Icons.eco,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: spacingXxs),
                          Text(
                            formatCO2Compact(actionLog.co2Grams),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (actionLog.note != null &&
                        actionLog.note!.isNotEmpty) ...[
                      const SizedBox(height: spacingXs),
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
                  horizontal: spacingMd,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: opacityFaint),
                  borderRadius: borderRadiusLg,
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
      ),
    );
  }
}
