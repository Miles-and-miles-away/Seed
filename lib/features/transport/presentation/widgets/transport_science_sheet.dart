import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';

const _kMaxChildSize = 0.85;
const _kMinChildSize = 0.3;

/// Per-mode science sheet (Phase 8.4): the emission factor, its
/// per-vehicle/per-passenger basis, the data-honesty caveat, the
/// dataset's calculation notes, and tappable source links. Mirrors
/// [ActionScienceBottomSheet]; every number here is traceable to a
/// source the user can open.
class TransportScienceSheet extends StatelessWidget {
  const TransportScienceSheet({
    required this.mode,
    required this.languageCode,
    super.key,
  });

  final TransportMode mode;
  final String languageCode;

  /// Shows the sheet with the app's bottom-sheet conventions.
  static void show(
    BuildContext context, {
    required TransportMode mode,
    required String languageCode,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (_) =>
          TransportScienceSheet(mode: mode, languageCode: languageCode),
    );
  }

  /// Markdown body assembled from the mode and localized labels.
  String _body(AppLocalizations l10n) {
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
        ..writeln('### ${l10n.transportScienceNotesHeading}')
        ..writeln(mode.calculationNotes)
        ..writeln();
    }
    if (mode.sources.isNotEmpty) {
      buffer.writeln('### ${l10n.transportScienceSourcesHeading}');
      for (final source in mode.sources) {
        buffer.writeln('- [${source.name}](${source.url})');
        if (source.quote.isNotEmpty) buffer.writeln('  > ${source.quote}');
        if (source.accessed.isNotEmpty) {
          buffer.writeln('  ${l10n.transportScienceAccessed(source.accessed)}');
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
                mode.name(languageCode),
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
