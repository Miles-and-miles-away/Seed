import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seed_app/core/constants/ui_constants.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Progress header showing overall Eco-Dex completion.
class EcoDexProgressHeader extends ConsumerWidget {
  const EcoDexProgressHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final discoveredCount = ref.watch(ecoDexDiscoveredCountProvider);
    final ecoDexAsync = ref.watch(ecoDexDataProvider);
    final totalCount = ecoDexAsync.value?.entries.length ?? 0;
    final progress = totalCount > 0 ? discoveredCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(spacingLg),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(
          alpha: opacityMuted,
        ),
        borderRadius: borderRadiusLg,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.ecoDexTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.ecoDexProgress(
                        discoveredCount,
                        totalCount,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, size: 18),
                tooltip: l10n.ecoDexInfoTooltip,
                color: theme.colorScheme.onSurfaceVariant,
                visualDensity: VisualDensity.compact,
                onPressed: () => InfoSheet.show(
                  context,
                  title: l10n.ecoDexInfoTitle,
                  body: l10n.ecoDexInfoBody,
                ),
              ),
            ],
          ),
          const SizedBox(height: spacingMd),
          ClipRRect(
            borderRadius: borderRadiusXs,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: spacingSm,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}
