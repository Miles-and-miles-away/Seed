import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';
import 'package:seed_app/shared/widgets/science_sheet.dart';

/// Per-item science sheet (Phase 8.10): the emission factor, the
/// dataset's calculation notes, and tappable source links. Every
/// number here is traceable to a source the user can open.
void showFoodScienceSheet(
  BuildContext context, {
  required FoodItem item,
  required String languageCode,
}) {
  final l10n = AppLocalizations.of(context);
  ScienceSheet.show(
    context,
    title: item.name(languageCode),
    markdown: _body(l10n, item),
  );
}

String _body(AppLocalizations l10n, FoodItem item) {
  final buffer = StringBuffer()
    ..writeln('**${foodItemFactorLabel(l10n, item)}**')
    ..writeln();
  if (item.calculationNotes.isNotEmpty) {
    buffer
      ..writeln('### ${l10n.scienceNotesHeading}')
      ..writeln(item.calculationNotes)
      ..writeln();
  }
  if (item.sources.isNotEmpty) {
    buffer.write(sourcesMarkdown(item.sources, l10n));
  }
  return buffer.toString();
}
