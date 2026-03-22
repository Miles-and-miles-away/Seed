import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_category_section.dart';
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

    return ecoDexAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: ErrorDisplay()),
      data: (data) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Spacing.lg),
            const EcoDexProgressHeader(),
            const SizedBox(height: Spacing.xl),
            ...data.categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Spacing.xl),
                child: EcoDexCategorySection(
                  category: category,
                  locale: locale,
                ),
              );
            }),
            const SizedBox(height: Spacing.lg),
          ],
        ),
      ),
    );
  }
}
