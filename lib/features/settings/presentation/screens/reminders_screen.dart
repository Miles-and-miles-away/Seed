import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/constants/action_icons.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/action_reminder_sheet.dart';
import 'package:seed_app/features/settings/presentation/widgets/daily_reminder_tiles.dart';
import 'package:seed_app/features/settings/presentation/widgets/settings_tile.dart';
import 'package:seed_app/shared/providers/notification_providers.dart';

/// The daily challenge reminder and the user's action reminders.
class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final notifier = ref.read(settingsProvider.notifier);
    final dailyOn = ref.watch(notificationsEnabledProvider);
    final actionsOn = ref.watch(actionRemindersEnabledProvider);
    final blocked =
        (dailyOn || actionsOn) &&
        ref.watch(notificationPermissionStatusProvider).value == false;
    final language = ref.watch(currentLanguageProvider);
    final reminders = ref.watch(actionRemindersProvider);
    final reminded = [
      for (final action
          in ref.watch(actionLibraryProvider).value ?? <ActionModel>[])
        if (reminders[action.id] case final reminder?) (action, reminder),
    ]..sort((a, b) => a.$1.name(language).compareTo(b.$1.name(language)));
    final logged = {
      ...?ref.watch(todayActionsProvider).value?.map((log) => log.actionId),
    };
    final note = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.remindersTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            if (blocked)
              SettingsTile(
                title: l10n.notifBlockedTitle,
                subtitle: l10n.notifBlockedSubtitle,
                leading: const Icon(Icons.notifications_off_outlined),
                dangerous: true,
                onTap: ref.read(notificationServiceProvider).openSettings,
              ),
            const DailyReminderTiles(),
            const Divider(height: 1),
            SettingsSwitchTile(
              title: l10n.notifActionReminders,
              leading: const Icon(Icons.notifications_active_outlined),
              value: actionsOn,
              onChanged: (value) => _toggle(
                context,
                ref,
                notifier.toggleActionReminders(enabled: value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                spacingLg,
                0,
                spacingLg,
                spacingSm,
              ),
              child: Text(
                l10n.reminderListIntro(AppConstants.maxActionReminders),
                style: note,
              ),
            ),
            if (reminded.isEmpty)
              Padding(
                padding: const EdgeInsets.all(spacingXxl),
                child: Text(
                  l10n.reminderListEmpty,
                  style: note,
                  textAlign: TextAlign.center,
                ),
              ),
            for (final (action, reminder) in reminded)
              SettingsTile(
                title: action.name(language),
                subtitle: actionReminderSummary(context, reminder),
                leading: Icon(getActionIcon(action.iconName)),
                onTap: () => showActionReminderSheet(
                  context,
                  ref,
                  action: action,
                  languageCode: language,
                  doneToday: logged.contains(action.id),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Awaits a reminder [toggle], telling the user when the OS refused.
  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    Future<bool> toggle,
  ) async {
    if (!await toggle && context.mounted) {
      showNotificationsBlockedSnackBar(context, ref);
    }
  }
}
