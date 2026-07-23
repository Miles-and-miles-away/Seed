import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Methodology & sources page (Phase 8.4): the credibility layer.
///
/// Static localized prose (scope, occupancy, radiative forcing, why
/// category averages, the coach 2026 caveat, grid-factor context)
/// plus a source list derived from the dataset itself, so it can
/// never drift from the factors actually shipped. Markdown-rendered
/// with tappable links, like the privacy policy screen.
class TransportMethodologyScreen extends ConsumerWidget {
  const TransportMethodologyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final modesAsync = ref.watch(transportModesProvider);
    final gridFactor = ref
        .watch(transportMetadataProvider)
        .value?['grid_factor_g_per_kwh'];
    final isDark = theme.brightness == Brightness.dark;
    final mdConfig = isDark
        ? MarkdownConfig.darkConfig
        : MarkdownConfig.defaultConfig;
    final linkColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transportMethodologyTitle)),
      body: modesAsync.when(
        data: (modes) => MarkdownWidget(
          data: appendExternalLinkArrow(
            _methodologyMarkdown(l10n, modes, gridFactor),
          ),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: ErrorDisplay()),
      ),
    );
  }

  /// Localized prose plus a deduplicated, data-derived source list.
  String _methodologyMarkdown(
    AppLocalizations l10n,
    List<TransportMode> modes,
    Object? gridFactor,
  ) {
    final grid = (gridFactor as num?)?.round() ?? 386;
    final buffer = StringBuffer()
      ..writeln(l10n.transportMethodologyBody(grid))
      ..writeln()
      ..writeln('### ${l10n.transportScienceSourcesHeading}');
    // Union of every shipped source, first name seen per URL wins.
    final sources = <String, String>{};
    for (final mode in modes) {
      for (final source in mode.sources) {
        sources.putIfAbsent(source.url, () => source.name);
      }
    }
    for (final entry in sources.entries) {
      buffer.writeln('- [${entry.value}](${entry.key})');
    }
    return buffer.toString();
  }
}
