import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

/// Screen displaying app information, version, and legal links.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _contactEmail = 'support@seed-app.example.com';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutSettingsTitle),
      ),
      body: ListView(
        children: [
          // App info header
          _buildAppHeader(context, theme),

          // Version info
          SettingsSection(
            title: l10n.aboutSettingsVersion,
            showTopDivider: true,
            children: [
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final packageInfo = snapshot.data;
                  final version = packageInfo?.version ?? '...';
                  final buildNumber = packageInfo?.buildNumber ?? '';

                  return ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text('$version ($buildNumber)'),
                    subtitle: Text('Seed - ${l10n.aboutSubtitleTracker}'),
                  );
                },
              ),
            ],
          ),

          // Legal section
          SettingsSection(
            title: l10n.aboutLegal,
            showTopDivider: true,
            children: [
              SettingsTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: l10n.aboutSettingsPrivacy,
                onTap: () => context.push(
                  '/profile/settings/about/privacy',
                ),
              ),
              SettingsTile(
                leading: const Icon(Icons.description_outlined),
                title: l10n.aboutSettingsTerms,
                onTap: () => context.push(
                  '/profile/settings/about/terms',
                ),
              ),
              SettingsTile(
                leading: const Icon(Icons.source_outlined),
                title: l10n.aboutSettingsLicenses,
                onTap: () => _showLicenses(context),
              ),
            ],
          ),

          // Support section
          SettingsSection(
            title: l10n.aboutSupport,
            showTopDivider: true,
            children: [
              SettingsTile(
                leading: const Icon(Icons.mail_outline),
                title: l10n.aboutSettingsContact,
                subtitle: _contactEmail,
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => _launchEmail(context),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Footer with SDG acknowledgment
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l10n.aboutFooterSdg,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l10n.aboutFooterMade,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          // App icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.eco,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Seed',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context).appTagline,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final uri = Uri(
      scheme: 'mailto',
      path: _contactEmail,
      queryParameters: {
        'subject': l10n.aboutEmailSubject,
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Seed',
      applicationIcon: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.eco,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      applicationLegalese: '\u00a9 2026 Seed App',
    );
  }
}
