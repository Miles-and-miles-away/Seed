import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';

const _kMaxChildSize = 0.85;
const _kMinChildSize = 0.3;

/// Per-behavior science sheet (Phase 8.16): the consumption factor, the
/// dataset's calculation notes, and tappable source links. Mirrors the
/// transport and food sheets; every number is traceable to a source the
/// user can open.
class EnergyScienceSheet extends StatelessWidget {
  const EnergyScienceSheet({
    required this.behavior,
    required this.languageCode,
    super.key,
  });

  final EnergyBehavior behavior;
  final String languageCode;

  /// Shows the sheet with the app's bottom-sheet conventions.
  static void show(
    BuildContext context, {
    required EnergyBehavior behavior,
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
          EnergyScienceSheet(behavior: behavior, languageCode: languageCode),
    );
  }

  String _body(AppLocalizations l10n) {
    final buffer = StringBuffer()
      ..writeln('**${energyBehaviorFactorLabel(l10n, behavior)}**')
      ..writeln();
    if (behavior.calculationNotes.isNotEmpty) {
      buffer
        ..writeln('### ${l10n.energyScienceNotesHeading}')
        ..writeln(behavior.calculationNotes)
        ..writeln();
    }
    if (behavior.sources.isNotEmpty) {
      buffer.writeln('### ${l10n.energyScienceSourcesHeading}');
      for (final source in behavior.sources) {
        buffer.writeln('- [${source.name}](${source.url})');
        if (source.quote.isNotEmpty) buffer.writeln('  > ${source.quote}');
        if (source.accessed.isNotEmpty) {
          buffer.writeln('  ${l10n.energyScienceAccessed(source.accessed)}');
        }
      }
    } else {
      // Silence would read as an oversight. Three entries ship without
      // a citation on purpose and each says why in its notes.
      buffer
        ..writeln('### ${l10n.energyScienceSourcesHeading}')
        ..writeln(l10n.energyScienceNoSources);
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
                behavior.name(languageCode),
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
