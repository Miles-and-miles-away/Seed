import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/shared/models/emission_source_model.dart';

const _kMaxChildSize = 0.85;
const _kMinChildSize = 0.3;

/// The markdown source list every science sheet ends with: a bullet
/// per citation, its quote as a blockquote, and the access date.
String sourcesMarkdown(List<EmissionSource> sources, AppLocalizations l10n) {
  final buffer = StringBuffer()..writeln('### ${l10n.scienceSourcesHeading}');
  for (final source in sources) {
    buffer.writeln('- [${source.name}](${source.url})');
    if (source.quote.isNotEmpty) buffer.writeln('  > ${source.quote}');
    if (source.accessed.isNotEmpty) {
      buffer.writeln('  ${l10n.scienceAccessed(source.accessed)}');
    }
  }
  return buffer.toString();
}

/// Draggable sheet holding one dataset entry's markdown explanation.
///
/// The chrome only -- each calculator assembles its own [markdown],
/// because what is worth saying about a transport mode, a food item
/// and a home-energy behaviour genuinely differs.
class ScienceSheet extends StatelessWidget {
  const ScienceSheet({required this.title, required this.markdown, super.key});

  final String title;
  final String markdown;

  /// Shows the sheet with the app's bottom-sheet conventions.
  static void show(
    BuildContext context, {
    required String title,
    required String markdown,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (_) => ScienceSheet(title: title, markdown: markdown),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      maxChildSize: _kMaxChildSize,
      minChildSize: _kMinChildSize,
      expand: false,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacingXxl),
            child: Text(
              title,
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
              data: appendExternalLinkArrow(markdown),
              padding: const EdgeInsets.all(spacingXxl),
              config: markdownConfigFor(
                context,
              ).copy(configs: [externalLinkConfig(context)]),
            ),
          ),
        ],
      ),
    );
  }
}
