import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/data/models/routine_usage_model.dart';
import 'package:seed_app/features/energy/domain/services/energy_calculator.dart';
import 'package:seed_app/features/energy/presentation/providers/energy_providers.dart';
import 'package:seed_app/features/energy/presentation/screens/energy_methodology_screen.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_behavior_picker.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_science_sheet.dart';
import 'package:seed_app/features/energy/presentation/widgets/usage_editor_sheet.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Side-by-side routine comparison (Phase 8.14/8.15).
///
/// Deliberately the same shape as the transport and food calculators --
/// two option columns totalled live, with the delta underneath -- so
/// the three feel like one feature. The one structural difference is
/// what is missing: there is no "log this choice" button, because
/// energy generates no actions (decision 8.18). A shorter shower has no
/// verifiable counterfactual, and the action library already covers the
/// same behaviours, so banking here would double-count.
class EnergyCalculatorScreen extends ConsumerStatefulWidget {
  const EnergyCalculatorScreen({super.key});

  @override
  ConsumerState<EnergyCalculatorScreen> createState() =>
      _EnergyCalculatorScreenState();
}

class _EnergyCalculatorScreenState
    extends ConsumerState<EnergyCalculatorScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logEnergyCalculatorOpened();
  }

  /// Opens the quantity editor for a new usage in [option], or for
  /// [edit]'s entry when given.
  Future<void> _openEditor(
    EnergyBehavior behavior,
    int option, {
    ({int index, RoutineUsage existing})? edit,
  }) async {
    final units = await UsageEditorSheet.show(
      context,
      behavior: behavior,
      initialUnits: edit?.existing.units,
    );
    if (units == null || !mounted) return;
    final usage = RoutineUsage(behaviorId: behavior.id, units: units);
    final notifier = ref.read(routineOptionsProvider.notifier);
    if (edit == null) {
      notifier.addUsage(option, usage);
    } else {
      notifier.updateUsage(option, edit.index, usage);
    }
  }

  /// Opens the picker for [option]'s column. The column is known from
  /// the button that was tapped, so the editor does not ask again.
  Future<void> _browse(List<EnergyBehavior> behaviors, int option) async {
    final locale = Localizations.localeOf(context).languageCode;
    final behavior = await showModalBottomSheet<EnergyBehavior>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: sheetShape,
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.8,
          ),
          child: EnergyBehaviorPicker(
            behaviors: behaviors,
            recentIds: ref.read(recentEnergyBehaviorIdsProvider),
            onSelected: (behavior) => Navigator.pop(sheetContext, behavior),
            onInfo: (behavior) => showEnergyScienceSheet(
              sheetContext,
              behavior: behavior,
              languageCode: locale,
            ),
          ),
        ),
      ),
    );
    if (behavior == null || !mounted) return;
    ref.read(recentEnergyBehaviorIdsProvider.notifier).record(behavior.id);
    await _openEditor(behavior, option);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final behaviorsAsync = ref.watch(energyBehaviorsProvider);
    final factorsAsync = ref.watch(energyCarrierFactorsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.energyCalculatorTitle),
        actions: [
          methodologyAction(
            context,
            tooltip: l10n.energyMethodologyTitle,
            builder: (_) => const EnergyMethodologyScreen(),
          ),
        ],
      ),
      body: switch ((behaviorsAsync, factorsAsync)) {
        (AsyncData(value: final behaviors), AsyncData(value: final factors)) =>
          _buildBody(behaviors, factors),
        (AsyncError(), _) ||
        (_, AsyncError()) => const Center(child: ErrorDisplay()),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildBody(List<EnergyBehavior> behaviors, CarrierFactors factors) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final byId = EnergyCalculator.byId(behaviors);
    final options = ref.watch(routineOptionsProvider);
    final totals = [
      for (final usages in options)
        EnergyCalculator.routineCo2eGrams(
          byId,
          usages,
          gridFactor: factors.grid,
          gasFactor: factors.gas,
        ),
    ];
    final summary = options.every((u) => u.isNotEmpty)
        ? compareTotals(totals)
        : null;
    // Marking a column "best" is a verdict in its own right, so it
    // answers to the same gate as the headline copy.
    final check = summary == null
        ? null
        : EnergyCalculator.checkVerdict(summary, byId, options);
    final showVerdict = check?.block == EnergyVerdictBlock.none;

    return ComparisonScaffold(
      accentColor: ActionCategory.energy.color,
      totals: totals,
      entries: [
        for (var option = 0; option < optionCount; option++)
          [
            for (var i = 0; i < options[option].length; i++)
              _usageCard(
                l10n,
                locale,
                byId,
                factors,
                option,
                i,
                options[option][i],
              ),
          ],
      ],
      emptyHint: l10n.energyColumnEmptyHint,
      addLabel: l10n.energyAddUsage,
      onAdd: (option) => _browse(behaviors, option),
      bestIndex: showVerdict ? summary?.bestIndex : null,
      result: _buildResult(
        l10n,
        locale,
        byId,
        options,
        factors,
        summary,
        check,
      ),
    );
  }

  Widget _usageCard(
    AppLocalizations l10n,
    String locale,
    Map<String, EnergyBehavior> byId,
    CarrierFactors factors,
    int option,
    int index,
    RoutineUsage usage,
  ) {
    final behavior = byId[usage.behaviorId]!;
    return OptionEntryCard(
      accentColor: ActionCategory.energy.color,
      icon: energyGroupIcon(behavior.comparableGroup),
      name: behavior.name(locale),
      detail: energyUsageDetailLabel(l10n, behavior, usage.units),
      grams: EnergyCalculator.usageCo2eGrams(
        behavior,
        usage,
        gridFactor: factors.grid,
        gasFactor: factors.gas,
      ),
      removeTooltip: l10n.calculatorRemoveEntry,
      onTap: () =>
          _openEditor(behavior, option, edit: (index: index, existing: usage)),
      onRemove: () =>
          ref.read(routineOptionsProvider.notifier).removeUsage(option, index),
    );
  }

  /// The verdict and, where the gating blocks one, the reason.
  ///
  /// The ratio leads and the gram figure follows (decision E7, PDR
  /// rules 26-27): the multiple is computed in kWh so it holds on
  /// every grid, and the phone-charge line divides by the dataset's
  /// own phone_charge row rather than the Phase 6 equivalency
  /// constant, which scales with the grid. Two honest fallbacks keep
  /// the gram-delta sentence instead: a zero-kWh winner (line drying
  /// has no multiple) and a mixed-carrier routine pair, whose CO2e
  /// multiple moves with the grid. Gas kWh is fuel input, so gas
  /// deltas are never converted to phone charges.
  ///
  /// No banking button and no equivalency-to-action here: this screen
  /// teaches and nothing else (decision 8.18).
  Widget _buildResult(
    AppLocalizations l10n,
    String locale,
    Map<String, EnergyBehavior> byId,
    List<List<RoutineUsage>> options,
    CarrierFactors factors,
    ComparisonSummary? summary,
    EnergyVerdictCheck? check,
  ) {
    final theme = Theme.of(context);
    if (summary == null || check == null) {
      return CalculatorHint(l10n.calculatorNeedBothOptions);
    }

    if (check.block != EnergyVerdictBlock.none) {
      // The reason is stated here rather than behind a "Why not?"
      // dialog. A refusal the user has to tap to understand reads as a
      // dead end, and the three reasons are not interchangeable.
      return Container(
        padding: const EdgeInsets.all(spacingLg),
        decoration: BoxDecoration(
          color: ActionCategory.energy.color.withValues(
            alpha: opacityVeryFaint,
          ),
          borderRadius: borderRadiusLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.energyComparisonNoVerdict,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: ActionCategory.energy.textColorOn(
                  theme.brightness,
                  large: true,
                ),
              ),
            ),
            const SizedBox(height: spacingSm),
            CalculatorHint(_noVerdictReason(l10n, check)),
          ],
        ),
      );
    }
    final bestLabel = optionLabel(l10n, summary.bestIndex);
    final worstLabel = optionLabel(l10n, summary.worstIndex);
    final bestKwh = EnergyCalculator.routineKwh(
      byId,
      options[summary.bestIndex],
    );
    final worstKwh = EnergyCalculator.routineKwh(
      byId,
      options[summary.worstIndex],
    );
    final carriers = <EnergyCarrier>{
      for (final option in options)
        for (final usage in option)
          if (byId[usage.behaviorId]!.carrier != EnergyCarrier.none)
            byId[usage.behaviorId]!.carrier,
    };
    final singleCarrier = carriers.length <= 1;
    final electricOnly = !carriers.contains(EnergyCarrier.gas);
    // The exact-values test pins the anchor row's presence; a missing
    // anchor degrades to no equivalency line rather than a crash.
    final anchor = byId['phone_charge'];
    final charges = anchor == null
        ? 0
        : ((worstKwh - bestKwh) / EnergyCalculator.defaultPresetKwh(anchor))
              .round();
    final showCharges = electricOnly && charges >= 1;
    final amount = formatCO2Compact(summary.deltaGrams.round());
    final ratioLeads = singleCarrier && bestKwh > 0;
    final headline = ratioLeads
        ? l10n.energyComparisonRatio(
            worstLabel,
            formatEnergyMultiple(locale, worstKwh / bestKwh),
            bestLabel,
          )
        : l10n.energyComparisonDelta(
            bestLabel,
            amount,
            worstLabel,
            summary.deltaPercent.round(),
          );
    final equivalency = ratioLeads
        ? (showCharges
              ? l10n.energyComparisonSavesEquiv(amount, charges)
              : l10n.energyComparisonSavesOnly(amount))
        : (showCharges ? l10n.energyPhoneChargesEquiv(charges) : null);
    return ComparisonDeltaCard(
      accentColor: ActionCategory.energy.color,
      headline: headline,
      equivalencyText: equivalency,
      basisNotes: [
        // "the multiple holds on any grid" only ships where a multiple
        // is on screen. In the mixed-carrier fallback it is also false:
        // that pair's CO2e multiple is exactly what moves with the grid.
        if (ratioLeads)
          l10n.energyGridBasisNoteRatio(factors.grid.round())
        else
          l10n.energyGridBasisNote(factors.grid.round()),
        l10n.energyNoPointsNote,
      ],
    );
  }

  /// Why the comparison declined to name a winner. The three reasons
  /// are not interchangeable, and the user is owed the real one rather
  /// than a generic refusal.
  String _noVerdictReason(AppLocalizations l10n, EnergyVerdictCheck check) =>
      switch (check.block) {
        EnergyVerdictBlock.differentGroup => l10n.energyVerdictDifferentGroup,
        EnergyVerdictBlock.differentCarrier =>
          l10n.energyVerdictDifferentCarrier,
        _ => l10n.energyVerdictTooClose(check.requiredPercent.round()),
      };
}
