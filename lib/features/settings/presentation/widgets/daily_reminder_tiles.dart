import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/action_reminder_sheet.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_tile.dart';

/// The daily challenge reminder switch and its time.
///
/// [onRefused] runs when the OS refuses notifications; by default it
/// shows the blocked snackbar.
class DailyReminderTiles extends ConsumerWidget {
  const DailyReminderTiles({this.onRefused, super.key});

  final VoidCallback? onRefused;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final on = ref.watch(notificationsEnabledProvider);
    final time = ref.watch(reminderTimeProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SettingsSwitchTile(
          title: l10n.notifDailyReminder,
          subtitle: l10n.notifDailyReminderSubtitle,
          leading: const Icon(Icons.notifications_outlined),
          value: on,
          onChanged: (value) async {
            final permitted = await notifier.toggleNotifications(
              enabled: value,
            );
            if (permitted || !context.mounted) return;
            if (onRefused case final refused?) {
              refused();
            } else {
              showNotificationsBlockedSnackBar(context, ref);
            }
          },
        ),
        SettingsTile(
          title: l10n.notifReminderTime,
          subtitle: time.format(context),
          leading: const Icon(Icons.schedule_outlined),
          showChevron: false,
          enabled: on,
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked == null || !context.mounted) return;
            unawaited(notifier.updateReminderTime(picked));
          },
        ),
      ],
    );
  }
}

/// A sheet with the daily challenge reminder, so Home can set it in place.
Future<void> showDailyReminderSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    shape: sheetShape,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: spacingLg),
        child: DailyReminderTiles(
          // The sheet would hide the snackbar, so close it first.
          onRefused: () {
            Navigator.pop(sheetContext);
            if (context.mounted) showNotificationsBlockedSnackBar(context, ref);
          },
        ),
      ),
    ),
  );
}
