import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_category_section.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_next_up_section.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_progress_header.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Main Eco-Dex encyclopedia screen with category sections.
class EcoDexScreen extends ConsumerWidget {
  const EcoDexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.localeName;
    final ecoDexAsync = ref.watch(ecoDexDataProvider);

    // Slivers keep entry-card construction lazy: only the grid tiles
    // near the viewport are built, instead of every entry at once.
    return ecoDexAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => Center(
        child: ErrorDisplay(
          onRetry: () => ref.invalidate(ecoDexDataProvider),
        ),
      ),
      data: (data) => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: spacingLg),
            sliver: SliverMainAxisGroup(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: spacingLg),
                ),
                const SliverToBoxAdapter(child: EcoDexProgressHeader()),
                const SliverToBoxAdapter(
                  child: SizedBox(height: spacingXl),
                ),
                const SliverToBoxAdapter(child: EcoDexNextUpSection()),
                const SliverToBoxAdapter(
                  child: SizedBox(height: spacingXl),
                ),
                for (final category in data.categories)
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: spacingXl),
                    sliver: EcoDexCategorySection(
                      category: category,
                      locale: locale,
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: spacingLg),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
