import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Methodology & sources page (Phase 8.10): the credibility layer.
///
/// Static localized prose (scope, spread, organic/local honesty, the
/// do-not-sum-with-transport warning) plus a source list derived from
/// the dataset itself, so it can never drift from the factors actually
/// shipped. Markdown-rendered with tappable links.
class FoodMethodologyScreen extends ConsumerWidget {
  const FoodMethodologyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final itemsAsync = ref.watch(foodItemsProvider);
    final isDark = theme.brightness == Brightness.dark;
    final mdConfig = isDark
        ? MarkdownConfig.darkConfig
        : MarkdownConfig.defaultConfig;
    final linkColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.foodMethodologyTitle)),
      body: itemsAsync.when(
        data: (items) => MarkdownWidget(
          data: appendExternalLinkArrow(_methodologyMarkdown(l10n, items)),
          padding: const EdgeInsets.all(spacingXxl),
          config: mdConfig.copy(
            configs: [
              LinkConfig(
                style: TextStyle(
                  color: linkColor,
                  decoration: TextDecoration.underline,
                  decorationColor: linkColor,
                ),
                onTap: (url) => openExternalUrl(context, url),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: ErrorDisplay()),
      ),
    );
  }

  /// Localized prose plus a deduplicated, data-derived source list.
  String _methodologyMarkdown(AppLocalizations l10n, List<FoodItem> items) {
    final buffer = StringBuffer()
      ..writeln(l10n.foodMethodologyBody)
      ..writeln()
      ..writeln('### ${l10n.foodScienceSourcesHeading}');
    // Union of every shipped source, first name seen per URL wins.
    final sources = <String, String>{};
    for (final item in items) {
      for (final source in item.sources) {
        sources.putIfAbsent(source.url, () => source.name);
      }
    }
    for (final entry in sources.entries) {
      buffer.writeln('- [${entry.value}](${entry.key})');
    }
    return buffer.toString();
  }
}
