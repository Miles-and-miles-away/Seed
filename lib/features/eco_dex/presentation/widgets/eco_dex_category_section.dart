import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seed_app/core/constants/ui_constants.dart';

import 'package:seed_app/features/eco_dex/data/models/eco_dex_category_model.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_card.dart';

/// A section showing one category's entries in a grid.
///
/// Builds slivers (header + lazy grid) so off-screen entry cards are
/// never instantiated; must be placed inside a [CustomScrollView].
class EcoDexCategorySection extends ConsumerWidget {
  const EcoDexCategorySection({
    required this.category,
    required this.locale,
    super.key,
  });

  final EcoDexCategory category;
  final String locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final entriesAsync = ref.watch(
      ecoDexEntriesByCategoryProvider(category.id),
    );
    final progressAsync = ref.watch(ecoDexCategoryProgressProvider);

    final entries = entriesAsync.value ?? [];
    final progress = progressAsync.value ?? {};
    final categoryProgress = progress[category.id] ?? (0, 0);

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: spacingSm),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category.name(locale),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${categoryProgress.$1}/${categoryProgress.$2}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: spacingMd,
            crossAxisSpacing: spacingMd,
            childAspectRatio: 0.85,
          ),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            return EcoDexEntryCard(
              entryState: entries[index],
              locale: locale,
            );
          },
        ),
      ],
    );
  }
}
