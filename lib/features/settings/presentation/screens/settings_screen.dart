import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/shared/providers/package_info_provider.dart';
import 'package:seed_app/shared/widgets/widgets.dart';
import '../providers/settings_providers.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import 'language_settings_screen.dart';

/// Main settings screen showing all settings categories.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final settingsAsync = ref.watch(userSettingsProvider);
    final version = ref.watch(packageInfoProvider).value?.version ?? '...';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: settingsAsync.when(
        data: (settings) => SafeArea(
          top: false,
          child: ListView(
            children: [
              // The Notifications section is hidden while the reminder
              // feature is postponed: the scheduler was never wired up,
              // so the toggles only wrote Firestore without any local
              // notification ever firing. Restore it together with the
              // wiring described in notification_providers.dart.

              // Preferences Section
              SettingsSection(
                title: l10n.settingsPreferences,
                children: [
                  SettingsTile(
                    title: l10n.settingsLanguage,
                    subtitle: _languageDisplayName(settings.language),
                    leading: const Icon(Icons.language_outlined),
                    onTap: () => context.push(appRoutes.settingsLanguage),
                  ),
                  SettingsTile(
                    title: l10n.settingsTheme,
                    leading: const Icon(Icons.brightness_6_outlined),
                    showChevron: false,
                    trailing: _ThemeModeSelector(
                      value: ref.watch(themeModeProvider),
                      onChanged: (mode) => ref
                          .read(settingsProvider.notifier)
                          .updateThemeMode(mode),
                    ),
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
                    onTap: () => context.push(appRoutes.settingsAccount),
                  ),
                ],
              ),

              // Support Section
              SettingsSection(
                title: l10n.settingsSupport,
                showTopDivider: true,
                children: [
                  SettingsTile(
                    title: l10n.settingsFeedback,
                    subtitle: l10n.settingsFeedbackSubtitle,
                    leading: const Icon(Icons.mail_outline),
                    onTap: () => context.push(appRoutes.settingsFeedback),
                  ),
                ],
              ),

              // About Section
              SettingsSection(
                title: l10n.settingsAbout,
                showTopDivider: true,
                children: [
                  SettingsTile(
                    title: l10n.settingsAbout,
                    subtitle: l10n.settingsVersionFormat(version),
                    leading: const Icon(Icons.info_outline),
                    onTap: () => context.push(appRoutes.settingsAbout),
                  ),
                ],
              ),

              const SizedBox(height: spacingXxxl),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: ErrorDisplay(
            onRetry: () => ref.invalidate(userSettingsProvider),
          ),
        ),
      ),
    );
  }

  /// Native name for [languageCode]; unknown codes fall back to English.
  String _languageDisplayName(String languageCode) => supportedLanguages
      .firstWhere(
        (l) => l.code == languageCode,
        orElse: () => supportedLanguages.first,
      )
      .nativeName;
}

/// Compact system / light / dark picker for the theme tile. Icon-only
/// so the three options fit beside the tile title at phone widths;
/// the labels ride along as tooltips and semantics.
class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.value, required this.onChanged});

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = {
      ThemeMode.system: l10n.settingsThemeSystem,
      ThemeMode.light: l10n.settingsThemeLight,
      ThemeMode.dark: l10n.settingsThemeDark,
    };
    const icons = {
      ThemeMode.system: Icons.brightness_auto_outlined,
      ThemeMode.light: Icons.light_mode_outlined,
      ThemeMode.dark: Icons.dark_mode_outlined,
    };

    return SegmentedButton<ThemeMode>(
      showSelectedIcon: false,
      segments: [
        for (final mode in ThemeMode.values)
          ButtonSegment(
            value: mode,
            icon: Icon(icons[mode], semanticLabel: labels[mode]),
            tooltip: labels[mode],
          ),
      ],
      selected: {value},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
