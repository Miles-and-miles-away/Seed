import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';
import '../widgets/reminder_list_tile.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

/// Screen for managing notification settings.
///
/// Allows users to:
/// - Enable/disable all notifications
/// - Toggle smart reminders (only notify if no action logged today)
/// - Add, edit, and remove reminder times (up to 5)
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final settingsAsync = ref.watch(userSettingsProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final smartRemindersEnabled = ref.watch(smartRemindersEnabledProvider);
    final canAddReminder = ref.watch(canAddReminderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          children: [
            // Master Toggle Section
            SettingsSection(
              title: 'Notifications',
              children: [
                SettingsSwitchTile(
                  title: 'Enable Notifications',
                  subtitle: 'Receive daily reminders to log actions',
                  leading: const Icon(Icons.notifications_outlined),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .toggleNotifications(enabled: value);
                  },
                ),
              ],
            ),

            // Smart Reminders Section
            SettingsSection(
              title: 'Smart Reminders',
              showTopDivider: true,
              children: [
                SettingsSwitchTile(
                  title: 'Only remind if no action today',
                  subtitle: "Skip reminders on days you've already logged",
                  leading: const Icon(Icons.auto_awesome_outlined),
                  value: smartRemindersEnabled,
                  enabled: notificationsEnabled,
                  onChanged: (value) {
                    ref
                        .read(settingsProvider.notifier)
                        .toggleSmartReminders(enabled: value);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    "When enabled, reminders will only appear if you haven't "
                    'logged any sustainable actions that day.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),

            // Reminder Times Section
            SettingsSection(
              title: 'Reminder Times',
              showTopDivider: true,
              children: [
                if (settings.reminderSchedules.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.alarm_off,
                          size: 48,
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No reminders set',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add a reminder to get notified',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...settings.reminderSchedules.map(
                    (schedule) => ReminderListTile(
                      schedule: schedule,
                      onToggle: (enabled) {
                        ref.read(settingsProvider.notifier).toggleReminder(
                              schedule.id,
                              enabled: enabled,
                            );
                      },
                      onDelete: () => _confirmDeleteReminder(
                        context,
                        ref,
                        schedule.id,
                        schedule.displayTime,
                      ),
                      onTap: () => _showTimePicker(
                        context,
                        ref,
                        existingScheduleId: schedule.id,
                        initialTime: TimeOfDay(
                          hour: schedule.hour,
                          minute: schedule.minute,
                        ),
                      ),
                    ),
                  ),

                // Add Reminder Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: OutlinedButton.icon(
                    onPressed: canAddReminder && notificationsEnabled
                        ? () => _showTimePicker(context, ref)
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Reminder Time'),
                  ),
                ),

                // Max reminders info
                if (!canAddReminder)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Maximum 5 reminders allowed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(
    BuildContext context,
    WidgetRef ref, {
    String? existingScheduleId,
    TimeOfDay? initialTime,
  }) async {
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime ?? const TimeOfDay(hour: 9, minute: 0),
      helpText: existingScheduleId != null
          ? 'Edit reminder time'
          : 'Select reminder time',
    );

    if (time == null) return;
    if (!context.mounted) return;

    if (existingScheduleId != null) {
      // Update existing reminder
      await ref.read(settingsProvider.notifier).updateReminderTime(
            existingScheduleId,
            time,
          );
    } else {
      // Add new reminder
      final label = await _showLabelDialog(context);
      if (!context.mounted) return;

      await ref.read(settingsProvider.notifier).addReminder(
            time,
            label: label,
          );
    }
  }

  Future<String?> _showLabelDialog(BuildContext context) async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder Label'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Morning, After work...',
            labelText: 'Label (optional)',
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Skip'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    controller.dispose();
    return result;
  }

  Future<void> _confirmDeleteReminder(
    BuildContext context,
    WidgetRef ref,
    String scheduleId,
    String displayTime,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reminder?'),
        content: Text('Remove the $displayTime reminder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref.read(settingsProvider.notifier).removeReminder(scheduleId);
    }
  }
}
