import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/domain/services/impact_equivalencies.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/transport/data/models/journey_leg_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/domain/services/transport_calculator.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_choice_providers.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/comparison_widgets.dart';

/// Side-by-side comparison of the staged journey options (Phase 8.3).
///
/// Bars scale to the worst option; the best is highlighted. The delta
/// line says "emits X less CO2e", never "saves" (data review copy
/// rule -- nothing was saved, these are hypothetical alternatives).
/// The winning option's reduction is illustrated with the Phase 6
/// tree-year equivalency.
class JourneyComparisonScreen extends ConsumerStatefulWidget {
  const JourneyComparisonScreen({
    required this.options,
    required this.modesById,
    super.key,
  });

  /// Staged journeys (each a list of legs), in the order added.
  final List<List<JourneyLeg>> options;

  /// Resolved modes for totals and labels.
  final Map<String, TransportMode> modesById;

  @override
  ConsumerState<JourneyComparisonScreen> createState() =>
      _JourneyComparisonScreenState();
}

class _JourneyComparisonScreenState
    extends ConsumerState<JourneyComparisonScreen> {
  late final List<double> _totals = [
    for (final legs in widget.options)
      TransportCalculator.journeyCo2eGrams(widget.modesById, legs),
  ];
  late final ComparisonSummary? _summary = compareTotals(_totals);

  /// The option the user actually took (defaults to greenest) and the
  /// alternative they avoided (defaults to worst). User-editable when
  /// there are 3 options, so the banked saving is an affirmed choice,
  /// not an assumed best-vs-worst extreme (Option C).
  int _chosenIndex = 0;
  int _baselineIndex = 0;

  @override
  void initState() {
    super.initState();
    final summary = _summary;
    if (summary != null) {
      _chosenIndex = summary.bestIndex;
      _baselineIndex = summary.worstIndex;
    }
    _logComparisonRun();
  }

  /// Avoided emissions the bank credits: what the user says they would
  /// have emitted (baseline) minus what they took (chosen).
  double get _bankDelta => _totals[_baselineIndex] - _totals[_chosenIndex];

  /// A bank is honest only for two distinct options with a positive
  /// saving (a greener-than-chosen baseline would credit nothing).
  bool get _canBank => _chosenIndex != _baselineIndex && _bankDelta > 0;

  void _logComparisonRun() {
    final summary = _summary;
    if (summary == null) return;
    final modeIds = <String>{
      for (final legs in widget.options)
        for (final leg in legs) leg.modeId,
    }.toList();
    ref
        .read(analyticsServiceProvider)
        .logTransportComparisonRun(
          modeIds: modeIds,
          legCounts: [for (final legs in widget.options) legs.length],
          winningModeId: _dominantModeId(widget.options[summary.bestIndex]),
        );
  }

  String _dominantModeId(List<JourneyLeg> legs) {
    if (legs.isEmpty) return '';
    var dominant = legs.first;
    for (final leg in legs) {
      if (leg.distanceKm > dominant.distanceKm) dominant = leg;
    }
    return dominant.modeId;
  }

  /// Banks the greener choice: the avoided emissions (the option the
  /// user took vs the alternative they affirm they avoided) logged as
  /// a real transport action (8.6). Clears the comparison and returns
  /// to the calculator on success.
  Future<void> _logChoice(
    AppLocalizations l10n,
    String chosenLabel,
    String baselineLabel,
    double deltaGrams,
  ) async {
    final amount = formatCO2Compact(deltaGrams.round());
    final ok = await ref
        .read(transportChoiceLoggerProvider.notifier)
        .logChoice(
          name: l10n.transportCustomActionName(chosenLabel, baselineLabel),
          co2Grams: deltaGrams.round(),
        );
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (ok) {
      ref.read(journeyComparisonProvider.notifier).clear();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.transportChoiceLoggedMessage(amount))),
      );
      Navigator.of(context).pop();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    }
  }

  /// Distinct data-honesty sublabels across an option's modes.
  List<String> _basisNotes(AppLocalizations l10n, List<JourneyLeg> legs) {
    final notes = <String>{};
    for (final leg in legs) {
      final mode = widget.modesById[leg.modeId];
      if (mode == null) continue;
      final note = transportModeBasisNote(l10n, mode);
      if (note != null) notes.add(note);
    }
    return notes.toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final summary = _summary;
    final worst = summary == null ? 0.0 : _totals[summary.worstIndex];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.transportComparisonTitle)),
      body: ListView(
        padding: const EdgeInsets.all(spacingLg),
        children: [
          for (var i = 0; i < widget.options.length; i++)
            ComparisonOptionBar(
              label: journeyOptionLabel(
                l10n,
                widget.options[i],
                widget.modesById,
              ),
              grams: _totals[i],
              fraction: worst <= 0 ? 0 : _totals[i] / worst,
              isBest: summary != null && i == summary.bestIndex,
              basisNotes: _basisNotes(l10n, widget.options[i]),
            ),
          if (summary != null && summary.deltaGrams > 0) ...[
            const SizedBox(height: spacingLg),
            _buildDeltaCard(l10n, summary),
            const SizedBox(height: spacingLg),
            _buildLogChoice(l10n, summary),
          ],
        ],
      ),
    );
  }

  /// Delta headline plus the Phase 6 tree-year equivalency of the saving.
  Widget _buildDeltaCard(AppLocalizations l10n, ComparisonSummary summary) {
    final trees = ref
        .watch(impactEquivalenciesDataProvider)
        .whenOrNull(
          data: (metadata) => computeImpactEquivalencies(
            summary.deltaGrams.round(),
            metadata,
          ).where((e) => e.type == EquivalencyType.trees).firstOrNull?.value,
        );
    return ComparisonDeltaCard(
      headline: l10n.transportComparisonDelta(
        journeyOptionLabel(
          l10n,
          widget.options[summary.bestIndex],
          widget.modesById,
        ),
        formatCO2Compact(summary.deltaGrams.round()),
        journeyOptionLabel(
          l10n,
          widget.options[summary.worstIndex],
          widget.modesById,
        ),
        summary.deltaPercent.round(),
      ),
      equivalencyText: (trees != null && trees >= 0.05)
          ? l10n.transportComparisonTreesEquiv(trees.toStringAsFixed(1))
          : null,
    );
  }

  Widget _buildLogChoice(AppLocalizations l10n, ComparisonSummary summary) {
    final theme = Theme.of(context);
    final labels = [
      for (var i = 0; i < widget.options.length; i++)
        journeyOptionLabel(l10n, widget.options[i], widget.modesById),
    ];
    final chosenLabel = labels[_chosenIndex];
    final baselineLabel = labels[_baselineIndex];
    final busy = ref.watch(transportChoiceLoggerProvider).isLoading;
    // Two options leave only one sensible pairing, so skip the pickers
    // and bank the best-vs-worst delta directly.
    final showSelectors = widget.options.length >= 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSelectors) ...[
          ChoiceSelector(
            title: l10n.transportChoseLabel,
            labels: labels,
            selected: _chosenIndex,
            onChanged: (i) => setState(() => _chosenIndex = i),
          ),
          const SizedBox(height: spacingSm),
          ChoiceSelector(
            title: l10n.transportInsteadOfLabel,
            labels: labels,
            selected: _baselineIndex,
            onChanged: (i) => setState(() => _baselineIndex = i),
          ),
          const SizedBox(height: spacingMd),
        ],
        Text(
          _canBank
              ? l10n.transportLogChoiceBody(
                  formatCO2Compact(_bankDelta.round()),
                )
              : l10n.transportChoiceDistinctHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: spacingSm),
        FilledButton.icon(
          onPressed: (busy || !_canBank)
              ? null
              : () => _logChoice(l10n, chosenLabel, baselineLabel, _bankDelta),
          icon: const Icon(Icons.eco),
          label: Text(l10n.transportLogChoiceCta(chosenLabel)),
        ),
      ],
    );
  }
}
