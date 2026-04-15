import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/shared/providers/package_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

/// Screen displaying app information, version, and legal links.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  static const _contactEmail = 'support@seedhabit.app';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutSettingsTitle),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            // App info header
            _buildAppHeader(context, theme),

            // Version info
            SettingsSection(
              title: l10n.aboutSettingsVersion,
              showTopDivider: true,
              children: [
                Builder(
                  builder: (context) {
                    final pkgAsync = ref.watch(packageInfoProvider);
                    final version = pkgAsync.value?.version ?? '...';
                    final buildNumber = pkgAsync.value?.buildNumber ?? '';
                    return ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text('$version ($buildNumber)'),
                      subtitle: Text(
                        'Seed - ${l10n.aboutSubtitleTracker}',
                      ),
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
                  onTap: () => context.push(AppRoutes.privacy),
                ),
                SettingsTile(
                  leading: const Icon(Icons.description_outlined),
                  title: l10n.aboutSettingsTerms,
                  onTap: () => context.push(AppRoutes.terms),
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
                  subtitle: '$_contactEmail $externalLinkChar',
                  onTap: () => _launchEmail(context),
                ),
              ],
            ),

            const SizedBox(height: Spacing.xxxl),

            // Footer with SDG acknowledgment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl),
              child: Text(
                l10n.aboutFooterSdg,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: Opacities.moderate,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: Spacing.sm),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.xxl),
              child: Text(
                l10n.aboutFooterMade,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: Opacities.medium,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: Spacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.xxxl),
      child: Column(
        children: [
          // App icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: Radii.borderXl,
            ),
            child: Icon(
              Icons.eco,
              size: Spacing.huge,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            'Seed',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            AppLocalizations.of(context).appTagline,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: Opacities.strong,
              ),
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
        padding: const EdgeInsets.all(Spacing.sm),
        child: Icon(
          Icons.eco,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      applicationLegalese: '\u00a9 ${DateTime.now().year} Seed App',
    );
  }
}
