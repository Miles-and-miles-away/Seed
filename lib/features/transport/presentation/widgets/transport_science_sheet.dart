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

String _body(AppLocalizations l10n, TransportMode mode) => scienceMarkdown(
  l10n,
  factorLine: transportModeFactorLabel(l10n, mode),
  basisNote: transportModeBasisNote(l10n, mode),
  notes: mode.calculationNotes,
  sources: mode.sources,
);
