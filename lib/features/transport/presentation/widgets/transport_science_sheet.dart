import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';
import 'package:seed_app/shared/widgets/science_sheet.dart';

/// Per-mode science sheet (Phase 8.4): the emission factor, its
/// per-vehicle/per-passenger basis, the data-honesty caveat, the
/// dataset's calculation notes, and tappable source links. Every
/// number here is traceable to a source the user can open.
void showTransportScienceSheet(
  BuildContext context, {
  required TransportMode mode,
  required String languageCode,
}) {
  final l10n = AppLocalizations.of(context);
  ScienceSheet.show(
    context,
    title: mode.name(languageCode),
    markdown: _body(l10n, mode),
  );
}

String _body(AppLocalizations l10n, TransportMode mode) {
  final buffer = StringBuffer()
    ..writeln('**${transportModeFactorLabel(l10n, mode)}**')
    ..writeln();
  final basis = transportModeBasisNote(l10n, mode);
  if (basis != null) {
    buffer
      ..writeln(basis)
      ..writeln();
  }
  if (mode.calculationNotes.isNotEmpty) {
    buffer
      ..writeln('### ${l10n.scienceNotesHeading}')
      ..writeln(mode.calculationNotes)
      ..writeln();
  }
  if (mode.sources.isNotEmpty) {
    buffer.write(sourcesMarkdown(mode.sources, l10n));
  }
  return buffer.toString();
}
