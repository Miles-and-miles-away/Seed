import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_image.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_sheet.dart';
import 'package:seed_app/features/progress/presentation/screens/progress_screen.dart';

/// Compact Eco-Dex preview shown inside the Profile screen. Shows up
/// to [_maxThumbs] most recent discoveries plus a "+N more" chip and
/// a "X / Y discovered" counter. The whole card is tappable and
/// navigates to the Eco-Dex tab on the Progress screen.
class ProfileEcoDexSection extends ConsumerWidget {
  const ProfileEcoDexSection({super.key});

  static const _maxThumbs = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;

    final dataAsync = ref.watch(ecoDexDataProvider);
    final discovered = ref.watch(ecoDexDiscoveredProvider);

    final data = dataAsync.value;
    final byId = {
      for (final entry in data?.entries ?? const <EcoDexEntry>[])
        entry.id: entry,
    };
    // arrayUnion preserves discovery order, so the most recent
    // discoveries sit at the end of the list.
    final recent = discovered.reversed
        .map((id) => byId[id])
        .whereType<EcoDexEntry>()
        .take(_maxThumbs)
        .toList(growable: false);
    final remaining = discovered.length - recent.length;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: borderRadiusLg,
      child: InkWell(
        borderRadius: borderRadiusLg,
        onTap: () => context.go(
          '${appRoutes.progress}?tab=$progressTabEcoDex',
        ),
        child: Padding(
          padding: const EdgeInsets.all(spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.ecoDexTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: spacingLg),
              if (dataAsync.isLoading)
                const _LoadingRow()
              else if (recent.isEmpty)
                Text(
                  l10n.ecoDexEmptyHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              else
                _ThumbRow(
                  recent: recent,
                  remaining: remaining,
                  locale: locale,
                ),
              const SizedBox(height: spacingMd),
              Text(
                l10n.ecoDexProgress(
                  discovered.length,
                  data?.entries.length ?? 0,
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThumbRow extends StatelessWidget {
  const _ThumbRow({
    required this.recent,
    required this.remaining,
    required this.locale,
  });

  final List<EcoDexEntry> recent;
  final int remaining;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        for (final entry in recent)
          Padding(
            padding: const EdgeInsets.only(right: spacingMd),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => EcoDexEntrySheet.show(
                context,
                entry: entry,
                locale: locale,
              ),
              child: Container(
                width: 52,
                height: 52,
                padding: const EdgeInsets.all(spacingXs),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(
                    alpha: opacityMedium,
                  ),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: EcoDexEntryImage(
                    iconName: entry.iconName,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        if (remaining > 0)
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '+$remaining',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

class _LoadingRow extends StatelessWidget {
  const _LoadingRow();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 52,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
