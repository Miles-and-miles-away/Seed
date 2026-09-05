import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';
import 'package:seed_app/shared/widgets/science_sheet.dart';

/// Per-behavior science sheet (Phase 8.16): the consumption factor,
/// the dataset's calculation notes, and tappable source links. Every
/// number here is traceable to a source the user can open.
void showEnergyScienceSheet(
  BuildContext context, {
  required EnergyBehavior behavior,
  required String languageCode,
}) {
  final l10n = AppLocalizations.of(context);
  ScienceSheet.show(
    context,
    title: behavior.name(languageCode),
    markdown: _body(l10n, behavior),
  );
}

/// Entries shipping without a citation say so on purpose: silence
/// would read as an oversight, and each explains why in its notes.
String _body(AppLocalizations l10n, EnergyBehavior behavior) => scienceMarkdown(
  l10n,
  factorLine: energyBehaviorFactorLabel(l10n, behavior),
  notes: behavior.calculationNotes,
  sources: behavior.sources,
  noSourcesNote: l10n.energyScienceNoSources,
);
