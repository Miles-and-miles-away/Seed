import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../data/models/notification_schedule_model.dart';
import '../../data/models/user_settings_model.dart';
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
        data: (settings) => ListView(
          children: [
            // Notifications Section
            SettingsSection(
              title: l10n.settingsNotifications,
              children: [
                SettingsSwitchTile(
                  title: l10n.settingsNotifications,
                  subtitle: _getReminderSubtitle(context, settings.enabledReminderCount),
                  leading: const Icon(Icons.notifications_outlined),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleNotifications(enabled: value);
                  },
                ),
                SettingsTile(
                  title: l10n.settingsReminderTime,
                  subtitle: _formatReminderTimes(settings.reminderSchedules),
                  leading: const Icon(Icons.schedule_outlined),
                  onTap: () => context.push('/settings/notifications'),
                ),
              ],
            ),

            // Preferences Section
            SettingsSection(
              title: 'Preferences',
              showTopDivider: true,
              children: [
                SettingsTile(
                  title: l10n.settingsLanguage,
                  subtitle: _getLanguageDisplayName(settings.language),
                  leading: const Icon(Icons.language_outlined),
                  onTap: () => context.push('/settings/language'),
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
                  subtitle: 'Email, password, delete account',
                  leading: const Icon(Icons.person_outline),
                  onTap: () => context.push('/settings/account'),
                ),
              ],
            ),

            // About Section
            SettingsSection(
              title: l10n.settingsAbout,
              showTopDivider: true,
              children: [
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data?.version ?? '...';
                    return SettingsTile(
                      title: l10n.settingsAbout,
                      subtitle: 'Version $version',
                      leading: const Icon(Icons.info_outline),
                      onTap: () => context.push('/settings/about'),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error loading settings',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
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

  String _getReminderSubtitle(BuildContext context, int count) {
    if (count == 0) {
      return 'No reminders set';
    } else if (count == 1) {
      return '1 reminder configured';
    } else {
      return '$count reminders configured';
    }
  }

  String _formatReminderTimes(List<NotificationScheduleModel> schedules) {
    if (schedules.isEmpty) {
      return 'Tap to add reminders';
    }

    final enabledSchedules = schedules.where((s) => s.isEnabled).toList();
    if (enabledSchedules.isEmpty) {
      return 'All reminders disabled';
    }

    if (enabledSchedules.length == 1) {
      return enabledSchedules.first.displayTime;
    }

    return '${enabledSchedules.first.displayTime} + ${enabledSchedules.length - 1} more';
  }

  String _getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'ja':
        return '日本語';
      case 'en':
      default:
        return 'English';
    }
  }
}
