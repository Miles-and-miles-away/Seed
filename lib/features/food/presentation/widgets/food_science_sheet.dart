import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';

const _kMaxChildSize = 0.85;
const _kMinChildSize = 0.3;

/// Per-item science sheet (Phase 8.10): the emission factor, the
/// dataset's calculation notes, and tappable source links. Mirrors
/// [TransportScienceSheet]; every number here is traceable to a source
/// the user can open.
class FoodScienceSheet extends StatelessWidget {
  const FoodScienceSheet({
    required this.item,
    required this.languageCode,
    super.key,
  });

  final FoodItem item;
  final String languageCode;

  /// Shows the sheet with the app's bottom-sheet conventions.
  static void show(
    BuildContext context, {
    required FoodItem item,
    required String languageCode,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (_) => FoodScienceSheet(item: item, languageCode: languageCode),
    );
  }

  /// Markdown body assembled from the item and localized labels.
  String _body(AppLocalizations l10n) {
    final buffer = StringBuffer()
      ..writeln('**${foodItemFactorLabel(l10n, item)}**')
      ..writeln();
    if (item.calculationNotes.isNotEmpty) {
      buffer
        ..writeln('### ${l10n.foodScienceNotesHeading}')
        ..writeln(item.calculationNotes)
        ..writeln();
    }
    if (item.sources.isNotEmpty) {
      buffer.writeln('### ${l10n.foodScienceSourcesHeading}');
      for (final source in item.sources) {
        buffer.writeln('- [${source.name}](${source.url})');
        if (source.quote.isNotEmpty) buffer.writeln('  > ${source.quote}');
        if (source.accessed.isNotEmpty) {
          buffer.writeln('  ${l10n.foodScienceAccessed(source.accessed)}');
        }
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mdConfig = isDark
        ? MarkdownConfig.darkConfig
        : MarkdownConfig.defaultConfig;
    final linkColor = theme.colorScheme.primary;

    return DraggableScrollableSheet(
      maxChildSize: _kMaxChildSize,
      minChildSize: _kMinChildSize,
      expand: false,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: spacingXxl),
              child: Text(
                item.name(languageCode),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: spacingLg),
            const Divider(height: 1),
            Expanded(
              child: MarkdownWidget(
                data: appendExternalLinkArrow(_body(l10n)),
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
            ),
          ],
        );
      },
    );
  }
}
