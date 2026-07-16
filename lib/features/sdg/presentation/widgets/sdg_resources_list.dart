import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/sdg/data/sdg_resources.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

/// Displays a list of external resources for an SDG.
class SdgResourcesList extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final allResources = ref.watch(sdgResourcesDataProvider).value;
    final resources = allResources?[goalNumber] ?? [];

    if (resources.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.link, color: goalColor, size: 20),
            const SizedBox(width: spacingSm),
            Text(
              headerText ?? l10n.sdgResources,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: spacingMd),
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
      padding: const EdgeInsets.only(bottom: spacingSm),
      child: Material(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: borderRadiusMd,
        child: InkWell(
          borderRadius: borderRadiusMd,
          onTap: () => openExternalUrl(context, resource.url),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: spacingLg,
              vertical: 14,
            ),
            child: Row(
              children: [
                Icon(icon, color: goalColor, size: 22),
                const SizedBox(width: spacingMd),
                Expanded(
                  child: Text(
                    '${resource.title(languageCode)} $externalLinkChar',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
