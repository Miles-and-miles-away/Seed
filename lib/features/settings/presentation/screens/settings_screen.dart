import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/settings/data/models/notification_schedule_model.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/shared/providers/package_info_provider.dart';
import '../providers/settings_providers.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

/// Main settings screen showing all settings categories.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final settingsAsync = ref.watch(userSettingsProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: settingsAsync.when(
        data: (settings) => SafeArea(
          top: false,
          child: ListView(
            children: [
              // Notifications Section
              SettingsSection(
                title: l10n.settingsNotifications,
                children: [
                  SettingsSwitchTile(
                    title: l10n.settingsNotifications,
                    subtitle: _getReminderSubtitle(
                      context,
                      settings.enabledReminderCount,
                    ),
                    leading: const Icon(Icons.notifications_outlined),
                    value: notificationsEnabled,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .toggleNotifications(enabled: value);
                    },
                  ),
                  SettingsTile(
                    title: l10n.settingsReminderTime,
                    subtitle: _formatReminderTimes(
                      context,
                      settings.reminderSchedules,
                    ),
                    leading: const Icon(Icons.schedule_outlined),
                    onTap: () => context.push(
                      AppRoutes.settingsNotifications,
                    ),
                  ),
                ],
              ),

              // Preferences Section
              SettingsSection(
                title: l10n.settingsPreferences,
                showTopDivider: true,
                children: [
                  SettingsTile(
                    title: l10n.settingsLanguage,
                    subtitle: _getLanguageDisplayName(settings.language),
                    leading: const Icon(Icons.language_outlined),
                    onTap: () => context.push(AppRoutes.settingsLanguage),
                  ),
                ],
              ),

              // Privacy Section
              SettingsSection(
                title: l10n.settingsAnalytics,
                showTopDivider: true,
                children: [
                  SettingsSwitchTile(
                    title: l10n.settingsAnalytics,
                    subtitle: l10n.settingsAnalyticsSubtitle,
                    leading: const Icon(Icons.analytics_outlined),
                    value: settings.analyticsEnabled,
                    onChanged: (value) {
                      ref
                          .read(settingsProvider.notifier)
                          .toggleAnalytics(enabled: value);
                    },
                  ),
                ],
              ),

              // Account Section
              SettingsSection(
                title: l10n.settingsAccount,
                showTopDivider: true,
                children: [
                  SettingsTile(
                    title: l10n.settingsAccount,
                    subtitle: l10n.settingsAccountSubtitle,
                    leading: const Icon(Icons.person_outline),
                    onTap: () => context.push(AppRoutes.settingsAccount),
                  ),
                ],
              ),

              // About Section
              SettingsSection(
                title: l10n.settingsAbout,
                showTopDivider: true,
                children: [
                  Builder(
                    builder: (context) {
                      final pkgAsync = ref.watch(packageInfoProvider);
                      final version = pkgAsync.value?.version ?? '...';
                      return SettingsTile(
                        title: l10n.settingsAbout,
                        subtitle: l10n.settingsVersionFormat(
                          version,
                        ),
                        leading: const Icon(Icons.info_outline),
                        onTap: () => context.push(AppRoutes.settingsAbout),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: Spacing.xxxl),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.settingsErrorLoading,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                error.toString(),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getReminderSubtitle(
    BuildContext context,
    int count,
  ) {
    final l10n = AppLocalizations.of(context);
    if (count == 0) {
      return l10n.settingsNoReminders;
    } else if (count == 1) {
      return l10n.settingsOneReminder;
    }
    return l10n.settingsRemindersCount(count);
  }

  String _formatReminderTimes(
    BuildContext context,
    List<NotificationScheduleModel> schedules,
  ) {
    final l10n = AppLocalizations.of(context);
    if (schedules.isEmpty) {
      return l10n.settingsTapToAddReminders;
    }

    final enabled = schedules.where((s) => s.isEnabled).toList();
    if (enabled.isEmpty) {
      return l10n.settingsAllRemindersDisabled;
    }

    if (enabled.length == 1) {
      return enabled.first.displayTime;
    }

    return l10n.settingsRemindersPlusMore(
      enabled.first.displayTime,
      enabled.length - 1,
    );
  }

  String _getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'ja':
        return '日本語';
      case 'es':
        return 'Español';
      case 'en':
      default:
        return 'English';
    }
  }
}
