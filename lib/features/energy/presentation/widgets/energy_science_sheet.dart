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

String _body(AppLocalizations l10n, EnergyBehavior behavior) {
  final buffer = StringBuffer()
    ..writeln('**${energyBehaviorFactorLabel(l10n, behavior)}**')
    ..writeln();
  if (behavior.calculationNotes.isNotEmpty) {
    buffer
      ..writeln('### ${l10n.scienceNotesHeading}')
      ..writeln(behavior.calculationNotes)
      ..writeln();
  }
  if (behavior.sources.isNotEmpty) {
    buffer.write(sourcesMarkdown(behavior.sources, l10n));
  } else {
    // Silence would read as an oversight. Five entries ship without a
    // citation on purpose and each says why in its notes.
    buffer
      ..writeln('### ${l10n.scienceSourcesHeading}')
      ..writeln(l10n.energyScienceNoSources);
  }
  return buffer.toString();
}
