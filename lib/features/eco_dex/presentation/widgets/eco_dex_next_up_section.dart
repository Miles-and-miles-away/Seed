import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/domain/services/eco_dex_progress.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_locked_sheet.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_progress_bar.dart';

/// "Next Up" -- the undiscovered entries with the highest numeric
/// progress, so the user can see what they are about to discover.
/// Entry names stay hidden (the discovery is the surprise); the hint
/// and progress bar show how to get there. Binary conditions and
/// entries with no progress yet are excluded.
class EcoDexNextUpSection extends ConsumerWidget {
  const EcoDexNextUpSection({super.key, this.maxItems = 3});

  final int maxItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final user = ref.watch(currentUserProvider).value;
    final entriesAsync = ref.watch(ecoDexEntriesProvider);
    final entries = entriesAsync.value;

    if (user == null || entries == null) return const SizedBox.shrink();

    final candidates =
        entries
            .where((e) => !e.isDiscovered)
            .map(
              (e) => (
                entry: e.entry,
                progress: ecoDexProgressOf(e.entry.condition, user),
              ),
            )
            // Exclude entries already at 100%: their condition is met but not
            // yet persisted (e.g. a stat-based unlock reached off the log-action
            // path, or a swallowed discovery-write failure). Showing a full bar
            // under "Next Up" would look stuck.
            .where(
              (c) =>
                  c.progress.hasProgress &&
                  c.progress.fraction > 0 &&
                  c.progress.fraction < 1,
            )
            .toList()
          ..sort((a, b) => b.progress.fraction.compareTo(a.progress.fraction));

    final top = candidates.take(maxItems).toList(growable: false);

    if (top.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.ecoDexNextUp,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: spacingMd),
        for (var i = 0; i < top.length; i++) ...[
          if (i > 0) const SizedBox(height: spacingMd),
          _NextUpCard(
            entry: top[i].entry,
            progress: top[i].progress,
            locale: locale,
          ),
        ],
      ],
    );
  }
}

class _NextUpCard extends StatelessWidget {
  const _NextUpCard({
    required this.entry,
    required this.progress,
    required this.locale,
  });

  final EcoDexEntry entry;
  final EcoDexProgress progress;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: borderRadiusLg,
      child: InkWell(
        borderRadius: borderRadiusLg,
        onTap: () =>
            EcoDexLockedSheet.show(context, entry: entry, locale: locale),
        child: Padding(
          padding: const EdgeInsets.all(spacingLg),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 22,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: spacingLg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.hint(locale),
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: spacingSm),
                    EcoDexProgressBar(progress: progress),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
