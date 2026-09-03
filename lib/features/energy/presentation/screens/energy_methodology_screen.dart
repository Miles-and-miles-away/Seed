import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/presentation/providers/energy_providers.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_ranked_table.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Methodology & sources page (Phase 8.16): the credibility layer.
///
/// Static localized prose (scope, the one-global-grid-figure
/// disclosure, the 241 g/kWh crossover, the heating hierarchy, the
/// measured-not-rated and standby honesty notes) around the ranked
/// "Where your energy goes" table, then a source list derived from the
/// dataset itself so it can never drift from the shipped factors. The
/// JA and ES bodies are written natively rather than translated (PDR
/// section 6).
class EnergyMethodologyScreen extends ConsumerWidget {
  const EnergyMethodologyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final behaviorsAsync = ref.watch(energyBehaviorsProvider);
    final factorsAsync = ref.watch(energyCarrierFactorsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.energyMethodologyTitle)),
      body: switch ((behaviorsAsync, factorsAsync)) {
        (AsyncData(value: final behaviors), AsyncData(value: final factors)) =>
          _buildBody(context, l10n, behaviors, factors),
        (AsyncError(), _) ||
        (_, AsyncError()) => const Center(child: ErrorDisplay()),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    List<EnergyBehavior> behaviors,
    CarrierFactors factors,
  ) {
    final config = markdownConfigFor(
      context,
    ).copy(configs: [externalLinkConfig(context)]);
    return ListView(
      padding: const EdgeInsets.all(spacingXxl),
      children: [
        MarkdownBlock(
          data: appendExternalLinkArrow(
            l10n.energyMethodologyBody(factors.grid.round()),
          ),
          config: config,
        ),
        const SizedBox(height: spacingXxl),
        EnergyRankedTable(behaviors: behaviors),
        const SizedBox(height: spacingXxl),
        MarkdownBlock(
          data: appendExternalLinkArrow(_sourcesMarkdown(l10n, behaviors)),
          config: config,
        ),
      ],
    );
  }

  /// Deduplicated, data-derived source list (same shape as the
  /// transport and food methodology screens).
  String _sourcesMarkdown(
    AppLocalizations l10n,
    List<EnergyBehavior> behaviors,
  ) {
    final buffer = StringBuffer()..writeln('### ${l10n.scienceSourcesHeading}');
    // Union of every shipped source, first name seen per URL wins.
    final sources = <String, String>{};
    for (final behavior in behaviors) {
      for (final source in behavior.sources) {
        sources.putIfAbsent(source.url, () => source.name);
      }
    }
    for (final entry in sources.entries) {
      buffer.writeln('- [${entry.value}](${entry.key})');
    }
    return buffer.toString();
  }
}
