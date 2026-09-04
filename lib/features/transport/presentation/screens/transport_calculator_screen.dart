import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/domain/services/impact_equivalencies.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/transport/data/models/city_model.dart';
import 'package:seed_app/features/transport/data/models/journey_leg_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/domain/services/transport_calculator.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_choice_providers.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';
import 'package:seed_app/features/transport/presentation/screens/transport_methodology_screen.dart';
import 'package:seed_app/features/transport/presentation/widgets/leg_editor_sheet.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_mode_picker.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_science_sheet.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Side-by-side journey comparison (Phase 8.2/8.3).
///
/// Two option columns are built at once and totalled live, with the
/// delta, its equivalency and the banking action folded in underneath
/// -- there is no separate comparison screen. Modes are dragged (or
/// tapped) up from the pool at the bottom.
///
/// The calculator itself awards nothing; only the explicit "I chose X"
/// action banks anything (No Fake Points, Phase 8 plan).
class TransportCalculatorScreen extends ConsumerStatefulWidget {
  const TransportCalculatorScreen({super.key});

  @override
  ConsumerState<TransportCalculatorScreen> createState() =>
      _TransportCalculatorScreenState();
}

class _TransportCalculatorScreenState
    extends ConsumerState<TransportCalculatorScreen> {
  /// The cities each leg runs between, mirroring
  /// [journeyOptionsProvider] index for index -- [JourneyLeg] carries
  /// none, and separate origin/destination fields drifted apart on
  /// remove and edit.
  final List<List<({City? from, City? to})>> _legCities = [
    for (var option = 0; option < optionCount; option++)
      <({City? from, City? to})>[],
  ];

  /// Where a column has reached, so a staged journey (Tokyo -> Osaka
  /// -> Kobe) chains without retyping.
  City? _lastStop(int option) =>
      _legCities[option].isEmpty ? null : _legCities[option].last.to;

  /// Where a column's journey began, so the other column can be seeded
  /// with the same trip.
  City? _firstFrom(int option) =>
      _legCities[option].isEmpty ? null : _legCities[option].first.from;

  /// The column whose journey defines the trip being compared: the
  /// first to receive a leg. Only the other column chases its end
  /// (gated seeding) -- the reference's own
  /// next leg gets no destination seed, so a finished journey is
  /// never pulled toward the other side's intermediate stop.
  int? _referenceOption;

  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logTransportCalculatorOpened();
    _adoptSurvivingJourney();
  }

  /// Re-aligns [_legCities] with a journey that outlived this screen.
  ///
  /// The journey provider is keepAlive and this state is not, so
  /// returning to the screen finds legs with no remembered cities.
  /// They seed nothing rather than throwing on the index.
  void _adoptSurvivingJourney() {
    final options = ref.read(journeyOptionsProvider);
    for (var option = 0; option < optionCount; option++) {
      _legCities[option]
        ..clear()
        ..addAll(List.filled(options[option].length, (from: null, to: null)));
    }
    final filled = [
      for (var option = 0; option < optionCount; option++)
        if (options[option].isNotEmpty) option,
    ];
    // Only an unambiguous survivor defines the trip; with both filled
    // the original order is gone, so nothing chases anything.
    _referenceOption = filled.length == 1 ? filled.first : null;
  }

  /// Opens the leg editor for a new leg. A null [option] means the
  /// sheet asks which column to add to.
  ///
  /// New legs are seeded cross-column: an empty column starts where
  /// the other journey started, and the column chasing the reference
  /// journey aims at its end -- so after A enters Tokyo -> Osaka, B
  /// opens on that same pair, and once B detours (Tokyo -> Nagoya) its
  /// next leg opens on Nagoya -> Osaka. The reference column itself
  /// gets no destination seed: its end IS the destination. Within a
  /// column, the previous leg's destination still wins as the origin.
  Future<void> _openEditor(TransportMode mode, int? option) async {
    final other = switch (option) {
      null => null,
      optionA => optionB,
      _ => optionA,
    };
    final from =
        (option == null ? null : _lastStop(option)) ??
        (other == null ? null : _firstFrom(other));
    final target = other != null && other == _referenceOption
        ? _lastStop(other)
        : null;
    final result = await LegEditorSheet.show(
      context,
      mode: mode,
      defaultFrom: from,
      defaultTo: target == from ? null : target,
      fixedOption: option,
    );
    if (result == null || !mounted) return;
    ref.read(journeyOptionsProvider.notifier).addLeg(result.option, result.leg);
    setState(() {
      _referenceOption ??= result.option;
      _legCities[result.option].add((from: result.fromCity, to: result.toCity));
    });
  }

  Future<void> _editLeg(
    TransportMode mode,
    int option,
    int index,
    JourneyLeg leg,
  ) async {
    // The leg's own endpoints: seeding the column's last stop rewrote
    // the origin of the very leg being edited.
    final cities = _legCities[option][index];
    final result = await LegEditorSheet.show(
      context,
      mode: mode,
      initialLeg: leg,
      defaultFrom: cities.from,
      defaultTo: cities.to,
      fixedOption: option,
    );
    if (result == null || !mounted) return;
    ref
        .read(journeyOptionsProvider.notifier)
        .updateLeg(option, index, result.leg);
    setState(() {
      _legCities[option][index] = (from: result.fromCity, to: result.toCity);
    });
  }

  /// Removes a leg and its cities together. Emptying a column hands
  /// the reference on, so a deleted journey stops defining the trip.
  void _removeLeg(int option, int index) {
    ref.read(journeyOptionsProvider.notifier).removeLeg(option, index);
    setState(() {
      _legCities[option].removeAt(index);
      if (_legCities[option].isEmpty && _referenceOption == option) {
        final other = option == optionA ? optionB : optionA;
        _referenceOption = _legCities[other].isEmpty ? null : other;
      }
    });
  }

  /// Opens the picker for [option]'s column. The column is known from
  /// the button that was tapped, so the editor does not ask again.
  Future<void> _browseAll(List<TransportMode> modes, int option) async {
    final locale = Localizations.localeOf(context).languageCode;
    final mode = await showModalBottomSheet<TransportMode>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: spacingLg),
          child: TransportModePicker(
            modes: modes,
            onSelected: (mode, _) => Navigator.pop(sheetContext, mode),
            onInfo: (mode) => showTransportScienceSheet(
              sheetContext,
              mode: mode,
              languageCode: locale,
            ),
          ),
        ),
      ),
    );
    if (mode == null || !mounted) return;
    await _openEditor(mode, option);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final modesAsync = ref.watch(transportModesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transportCalculatorTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.science_outlined),
            tooltip: l10n.transportMethodologyTitle,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const TransportMethodologyScreen(),
              ),
            ),
          ),
        ],
      ),
      body: modesAsync.when(
        data: _buildBody,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: ErrorDisplay()),
      ),
    );
  }

  Widget _buildBody(List<TransportMode> modes) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final modesById = TransportCalculator.byId(modes);
    final options = ref.watch(journeyOptionsProvider);
    final totals = [
      for (final legs in options)
        TransportCalculator.journeyCo2eGrams(modesById, legs),
    ];
    // Transport names the lowest column outright: it has no verdict
    // gate, because a shorter drive is not a statistical tie.
    final summary = options.every((legs) => legs.isNotEmpty)
        ? compareTotals(totals)
        : null;

    return ComparisonScaffold(
      accentColor: ActionCategory.transport.color,
      totals: totals,
      entries: [
        for (var option = 0; option < optionCount; option++)
          [
            for (var i = 0; i < options[option].length; i++)
              _legCard(l10n, locale, modesById, option, i, options[option][i]),
          ],
      ],
      emptyHint: l10n.transportColumnEmptyHint,
      addLabel: l10n.transportAddLeg,
      onAdd: (option) => _browseAll(modes, option),
      bestIndex: summary?.bestIndex,
      result: _buildResult(l10n, locale, modesById, options, summary),
    );
  }

  Widget _legCard(
    AppLocalizations l10n,
    String locale,
    Map<String, TransportMode> modesById,
    int option,
    int index,
    JourneyLeg leg,
  ) {
    final mode = modesById[leg.modeId]!;
    final details = [
      l10n.transportKmValue(formatKmCompact(leg.distanceKm, locale)),
      if (mode.perVehicle) l10n.transportOccupantsValue(leg.occupants),
    ].join(' · ');
    return OptionEntryCard(
      accentColor: ActionCategory.transport.color,
      icon: transportGroupIcon(mode.group),
      name: mode.name(locale),
      detail: details,
      grams: TransportCalculator.legCo2eGrams(mode, leg),
      removeTooltip: l10n.calculatorRemoveEntry,
      onTap: () => _editLeg(mode, option, index, leg),
      onRemove: () => _removeLeg(option, index),
    );
  }

  /// The delta, its equivalency, the data-honesty basis notes, and the
  /// banking action -- everything the old comparison screen carried.
  Widget _buildResult(
    AppLocalizations l10n,
    String locale,
    Map<String, TransportMode> modesById,
    List<List<JourneyLeg>> options,
    ComparisonSummary? summary,
  ) {
    final theme = Theme.of(context);
    if (summary == null || summary.deltaGrams <= 0) {
      return Text(
        l10n.calculatorNeedBothOptions,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }
    // On screen the options are the column names; naming a single
    // leg read as an arbitrary pick from the list. The banked action
    // still gets the full journey description.
    String columnName(int i) =>
        i == optionA ? l10n.calculatorOptionA : l10n.calculatorOptionB;
    final bestLabel = columnName(summary.bestIndex);
    final worstLabel = columnName(summary.worstIndex);
    final trees = ref
        .watch(impactEquivalenciesDataProvider)
        .whenOrNull(
          data: (metadata) => computeImpactEquivalencies(
            summary.deltaGrams.round(),
            metadata,
          ).where((e) => e.type == EquivalencyType.trees).firstOrNull?.value,
        );
    final busy = ref.watch(transportChoiceLoggerProvider).isLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ComparisonDeltaCard(
          accentColor: ActionCategory.transport.color,
          headline: l10n.transportComparisonDelta(
            bestLabel,
            formatCO2Compact(summary.deltaGrams.round()),
            worstLabel,
            summary.deltaPercent.round(),
          ),
          equivalencyText: (trees != null && trees >= 0.05)
              ? l10n.transportComparisonTreesEquiv(trees.toStringAsFixed(1))
              : null,
          basisNotes: _basisNotes(l10n, modesById, options),
        ),
        const SizedBox(height: spacingSm),
        FilledButton.icon(
          onPressed: busy
              ? null
              : () => _logChoice(
                  l10n,
                  journeySummaryLabel(
                    l10n,
                    options[summary.bestIndex],
                    modesById,
                    locale,
                  ),
                  journeySummaryLabel(
                    l10n,
                    options[summary.worstIndex],
                    modesById,
                    locale,
                  ),
                  summary.deltaGrams,
                ),
          icon: const Icon(Icons.eco),
          label: Text(l10n.transportLogChoiceCta(bestLabel)),
        ),
      ],
    );
  }

  /// Distinct data-honesty sublabels across both options' modes.
  List<String> _basisNotes(
    AppLocalizations l10n,
    Map<String, TransportMode> modesById,
    List<List<JourneyLeg>> options,
  ) {
    final notes = <String>{};
    for (final legs in options) {
      for (final leg in legs) {
        final mode = modesById[leg.modeId];
        if (mode == null) continue;
        final note = transportModeBasisNote(l10n, mode);
        if (note != null) notes.add(note);
      }
    }
    return notes.toList();
  }

  /// Banks the avoided emissions (worse option minus the one taken) as
  /// a real transport action (8.6), then clears both columns.
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
      ref.read(journeyOptionsProvider.notifier).clear();
      setState(() {
        for (final cities in _legCities) {
          cities.clear();
        }
        _referenceOption = null;
      });
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.transportChoiceLoggedMessage(amount))),
      );
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    }
  }
}
