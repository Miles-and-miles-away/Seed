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

String _body(AppLocalizations l10n, FoodItem item) => scienceMarkdown(
  l10n,
  factorLine: foodItemFactorLabel(l10n, item),
  notes: item.calculationNotes,
  sources: item.sources,
);
