import 'package:flutter/material.dart';

import '../../data/models/notification_schedule_model.dart';

/// A tile displaying a single reminder with toggle and delete options.
class ReminderListTile extends StatelessWidget {
  const ReminderListTile({
    required this.schedule,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
    super.key,
  });

  /// The notification schedule to display.
  final NotificationScheduleModel schedule;

  /// Called when the toggle switch is changed.
  final ValueChanged<bool> onToggle;

  /// Called when the delete button is tapped.
  final VoidCallback onDelete;

  /// Called when the tile is tapped (to edit time).
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key(schedule.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: colorScheme.error,
        child: Icon(
          Icons.delete_outline,
          color: colorScheme.onError,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.alarm,
          color: schedule.isEnabled
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        title: Text(
          schedule.displayTime,
          style: theme.textTheme.titleMedium?.copyWith(
            color: schedule.isEnabled
                ? null
                : colorScheme.onSurface.withValues(alpha: 0.38),
          ),
        ),
        subtitle: schedule.label.isNotEmpty
            ? Text(
                schedule.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch.adaptive(
              value: schedule.isEnabled,
              onChanged: onToggle,
              activeTrackColor: colorScheme.primary,
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.error.withValues(alpha: 0.7),
              ),
              onPressed: onDelete,
              tooltip: 'Delete reminder',
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
