import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/data/models/routine_usage_model.dart';
import 'package:seed_app/features/energy/domain/services/energy_calculator.dart';
import 'package:seed_app/features/energy/presentation/providers/energy_providers.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_behavior_picker.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_science_sheet.dart';
import 'package:seed_app/features/energy/presentation/widgets/usage_editor_sheet.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';
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
  Future<void> _addUsage(EnergyBehavior behavior, int option) async {
    final units = await UsageEditorSheet.show(context, behavior: behavior);
    if (units == null || !mounted) return;
    ref
        .read(routineOptionsProvider.notifier)
        .addUsage(option, RoutineUsage(behaviorId: behavior.id, units: units));
  }

  Future<void> _editUsage(
    EnergyBehavior behavior,
    int option,
    int index,
    RoutineUsage usage,
  ) async {
    final units = await UsageEditorSheet.show(
      context,
      behavior: behavior,
      initialUnits: usage.units,
    );
    if (units == null || !mounted) return;
    ref
        .read(routineOptionsProvider.notifier)
        .updateUsage(
          option,
          index,
          RoutineUsage(behaviorId: behavior.id, units: units),
        );
  }

  /// Opens the picker for [option]'s column. The column is known from
  /// the button that was tapped, so the editor does not ask again.
  Future<void> _browse(List<EnergyBehavior> behaviors, int option) async {
    final locale = Localizations.localeOf(context).languageCode;
    final behavior = await showModalBottomSheet<EnergyBehavior>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
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
    await _addUsage(behavior, option);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final behaviorsAsync = ref.watch(energyBehaviorsProvider);
    final factorsAsync = ref.watch(energyCarrierFactorsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.energyCalculatorTitle)),
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
      result: _buildResult(l10n, summary, check),
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
      onTap: () => _editUsage(behavior, option, index, usage),
      onRemove: () =>
          ref.read(routineOptionsProvider.notifier).removeUsage(option, index),
    );
  }

  /// The delta and, where the gating blocks a verdict, the reason.
  ///
  /// No banking button and no equivalency-to-action here: this screen
  /// teaches and nothing else (decision 8.18).
  Widget _buildResult(
    AppLocalizations l10n,
    ComparisonSummary? summary,
    EnergyVerdictCheck? check,
  ) {
    final theme = Theme.of(context);
    final hint = Text(
      l10n.calculatorNeedBothOptions,
      textAlign: TextAlign.center,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
    if (summary == null || check == null) return hint;

    if (check.block != EnergyVerdictBlock.none) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.energyComparisonNoVerdict,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: () => _explainNoVerdict(l10n, check),
            child: Text(l10n.energyVerdictWhyCta),
          ),
        ],
      );
    }
    final bestLabel = summary.bestIndex == optionA
        ? l10n.calculatorOptionA
        : l10n.calculatorOptionB;
    final worstLabel = summary.worstIndex == optionA
        ? l10n.calculatorOptionA
        : l10n.calculatorOptionB;
    return ComparisonDeltaCard(
      headline: l10n.energyComparisonDelta(
        bestLabel,
        formatCO2Compact(summary.deltaGrams.round()),
        worstLabel,
        summary.deltaPercent.round(),
      ),
      basisNotes: [l10n.energyNoPointsNote],
    );
  }

  /// Explains why the comparison declined to name a winner. The three
  /// reasons are not interchangeable, and the user is owed the real one
  /// rather than a generic refusal.
  void _explainNoVerdict(AppLocalizations l10n, EnergyVerdictCheck check) {
    final body = switch (check.block) {
      EnergyVerdictBlock.differentGroup => l10n.energyVerdictDifferentGroup,
      EnergyVerdictBlock.differentCarrier => l10n.energyVerdictDifferentCarrier,
      _ => l10n.energyVerdictTooClose(check.requiredPercent.round()),
    };
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.energyComparisonNoVerdict),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.buttonClose),
          ),
        ],
      ),
    );
  }
}
