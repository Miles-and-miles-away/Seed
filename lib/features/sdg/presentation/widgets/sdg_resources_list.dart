import 'package:flutter/material.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/sdg/data/sdg_resources.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays a list of external resources for an SDG.
class SdgResourcesList extends StatelessWidget {
  const SdgResourcesList({
    required this.goalNumber,
    required this.goalColor,
    required this.languageCode,
    this.headerText,
    super.key,
  });

  final int goalNumber;
  final Color goalColor;
  final String languageCode;
  final String? headerText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final resources = sdgResources[goalNumber] ?? [];

    if (resources.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.link,
              color: goalColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              headerText ?? l10n.sdgResources,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...resources.map(
          (resource) => _ResourceTile(
            resource: resource,
            languageCode: languageCode,
            goalColor: goalColor,
          ),
        ),
      ],
    );
  }
}

class _ResourceTile extends StatelessWidget {
  const _ResourceTile({
    required this.resource,
    required this.languageCode,
    required this.goalColor,
  });

  final SdgResource resource;
  final String languageCode;
  final Color goalColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icon = switch (resource.type) {
      SdgResourceType.official => Icons.language,
      SdgResourceType.action => Icons.volunteer_activism,
      SdgResourceType.education => Icons.school,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _launchUrl(resource.url),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Icon(icon, color: goalColor, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    resource.title(languageCode),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
