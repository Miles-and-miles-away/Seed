import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

    final settingsAsync = ref.watch(userSettingsProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final smartRemindersEnabled = ref.watch(smartRemindersEnabledProvider);
    final canAddReminder = ref.watch(canAddReminderProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifSettingsTitle),
      ),
      body: settingsAsync.when(
        data: (settings) => SafeArea(
          top: false,
          child: ListView(
            children: [
              // Master Toggle Section
              SettingsSection(
                title: l10n.notifSectionNotifications,
                children: [
                  SettingsSwitchTile(
                    title: l10n.notifEnableTitle,
                    subtitle: l10n.notifEnableSubtitle,
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
                title: l10n.notifSmartTitle,
                showTopDivider: true,
                children: [
                  SettingsSwitchTile(
                    title: l10n.notifSmartOnlyTitle,
                    subtitle: l10n.notifSmartOnlySubtitle,
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
                      l10n.notifSmartDescription,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),

              // Reminder Times Section
              SettingsSection(
                title: l10n.notifReminderTimesTitle,
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
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.notifNoReminders,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.notifAddReminder,
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
                      label: Text(l10n.notifAddReminderTime),
                    ),
                  ),

                  // Max reminders info
                  if (!canAddReminder)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n.notifMaxReminders,
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
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('${l10n.errorGeneric} $error'),
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
    final l10n = AppLocalizations.of(context);
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime ?? const TimeOfDay(hour: 9, minute: 0),
      helpText: existingScheduleId != null
          ? l10n.notifEditTime
          : l10n.notifSelectTime,
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

  Future<String?> _showLabelDialog(
    BuildContext context,
  ) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.notifLabelTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.notifLabelHint,
            labelText: l10n.notifLabelOptional,
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          maxLength: 20,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.buttonSkip),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              ctx,
              controller.text.trim(),
            ),
            child: Text(l10n.notifAdd),
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
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.notifDeleteTitle),
        content: Text(
          l10n.notifDeleteMessage(displayTime),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.buttonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l10n.buttonDelete),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref.read(settingsProvider.notifier).removeReminder(scheduleId);
    }
  }
}
