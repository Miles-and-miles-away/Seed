import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';
import 'package:seed_app/features/food/presentation/providers/food_choice_providers.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/food/presentation/screens/food_methodology_screen.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';
import 'package:seed_app/features/food/presentation/widgets/food_item_picker.dart';
import 'package:seed_app/features/food/presentation/widgets/food_science_sheet.dart';
import 'package:seed_app/features/food/presentation/widgets/ingredient_editor_sheet.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/domain/services/impact_equivalencies.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Side-by-side meal comparison (Phase 8.8/8.9).
///
/// Mirrors the transport calculator: two option columns built at once
/// and totalled live, with the delta, its equivalency and the banking
/// action folded in underneath. Simpler -- no occupancy, no cities.
///
/// The calculator itself awards nothing; only the explicit "I chose X"
/// action banks anything (No Fake Points, Phase 8 plan).
class FoodCalculatorScreen extends ConsumerStatefulWidget {
  const FoodCalculatorScreen({super.key});

  @override
  ConsumerState<FoodCalculatorScreen> createState() =>
      _FoodCalculatorScreenState();
}

class _FoodCalculatorScreenState extends ConsumerState<FoodCalculatorScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(analyticsServiceProvider).logFoodCalculatorOpened();
  }

  /// Opens the quantity editor for a new ingredient. A null [option]
  /// means the sheet asks which column to add to.
  Future<void> _openEditor(FoodItem item, int? option) async {
    final result = await IngredientEditorSheet.show(
      context,
      item: item,
      fixedOption: option,
    );
    if (result == null || !mounted) return;
    ref
        .read(mealOptionsProvider.notifier)
        .addIngredient(result.option, result.ingredient);
  }

  Future<void> _editIngredient(
    FoodItem item,
    int option,
    int index,
    MealIngredient ingredient,
  ) async {
    final result = await IngredientEditorSheet.show(
      context,
      item: item,
      initialIngredient: ingredient,
      fixedOption: option,
    );
    if (result == null || !mounted) return;
    ref
        .read(mealOptionsProvider.notifier)
        .updateIngredient(option, index, result.ingredient);
  }

  /// Opens the picker for [option]'s column. The column is known from
  /// the button that was tapped, so the editor does not ask again.
  Future<void> _browseAll(List<FoodItem> items, int option) async {
    final locale = Localizations.localeOf(context).languageCode;
    final item = await showModalBottomSheet<FoodItem>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (sheetContext) => SafeArea(
        // Bounded so the picker's own lazy list does the scrolling.
        // Leaves the keyboard room: the search field is the first
        // thing most users reach for.
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.8,
            ),
            child: FoodItemPicker(
              items: items,
              recentIds: ref.read(recentFoodItemIdsProvider),
              onSelected: (item) => Navigator.pop(sheetContext, item),
              onInfo: (item) => showFoodScienceSheet(
                sheetContext,
                item: item,
                languageCode: locale,
              ),
            ),
          ),
        ),
      ),
    );
    if (item == null || !mounted) return;
    ref.read(recentFoodItemIdsProvider.notifier).record(item.id);
    await _openEditor(item, option);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(foodItemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.foodCalculatorTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.science_outlined),
            tooltip: l10n.foodMethodologyTitle,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const FoodMethodologyScreen(),
              ),
            ),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: _buildBody,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: ErrorDisplay()),
      ),
    );
  }

  Widget _buildBody(List<FoodItem> items) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final itemsById = FoodCalculator.byId(items);
    final options = ref.watch(mealOptionsProvider);
    final totals = [
      for (final ingredients in options)
        FoodCalculator.mealCo2eGrams(itemsById, ingredients),
    ];
    final summary = options.every((i) => i.isNotEmpty)
        ? compareTotals(totals)
        : null;
    // Marking a column "best" is a verdict in its own right, so it
    // answers to the same gate as the headline copy.
    final check = summary == null
        ? null
        : FoodCalculator.checkVerdict(summary, itemsById, options);
    final showVerdict = check?.block == VerdictBlock.none;

    return ComparisonScaffold(
      totals: totals,
      entries: [
        for (var option = 0; option < optionCount; option++)
          [
            for (var i = 0; i < options[option].length; i++)
              _ingredientCard(
                l10n,
                locale,
                itemsById,
                option,
                i,
                options[option][i],
              ),
          ],
      ],
      emptyHint: l10n.foodColumnEmptyHint,
      addLabel: l10n.foodAddIngredient,
      onAdd: (option) => _browseAll(items, option),
      bestIndex: showVerdict ? summary?.bestIndex : null,
      result: _buildResult(l10n, locale, itemsById, options, summary, check),
    );
  }

  Widget _ingredientCard(
    AppLocalizations l10n,
    String locale,
    Map<String, FoodItem> itemsById,
    int option,
    int index,
    MealIngredient ingredient,
  ) {
    final item = itemsById[ingredient.itemId]!;
    return OptionEntryCard(
      icon: foodGroupIcon(item.group),
      name: item.name(locale),
      detail: l10n.foodGramsValue(ingredient.grams.round().toString()),
      grams: FoodCalculator.ingredientCo2eGrams(item, ingredient),
      removeTooltip: l10n.calculatorRemoveEntry,
      onTap: () => _editIngredient(item, option, index, ingredient),
      onRemove: () => ref
          .read(mealOptionsProvider.notifier)
          .removeIngredient(option, index),
    );
  }

  /// The delta, its equivalency and the banking action -- everything
  /// the old comparison screen carried.
  Widget _buildResult(
    AppLocalizations l10n,
    String locale,
    Map<String, FoodItem> itemsById,
    List<List<MealIngredient>> options,
    ComparisonSummary? summary,
    VerdictCheck? check,
  ) {
    final theme = Theme.of(context);
    if (summary == null || check == null || summary.deltaGrams <= 0) {
      return Text(
        l10n.calculatorNeedBothOptions,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }
    // On screen the options are the column names; naming a single
    // ingredient read as an arbitrary pick from the list. The banked
    // action still gets the full meal description.
    String columnName(int i) =>
        i == optionA ? l10n.calculatorOptionA : l10n.calculatorOptionB;
    final bestLabel = columnName(summary.bestIndex);
    final worstLabel = columnName(summary.worstIndex);
    final carKm = ref
        .watch(impactEquivalenciesDataProvider)
        .whenOrNull(
          data: (metadata) => computeImpactEquivalencies(
            summary.deltaGrams.round(),
            metadata,
          ).where((e) => e.type == EquivalencyType.carKm).firstOrNull?.value,
        );
    final busy = ref.watch(foodChoiceLoggerProvider).isLoading;
    // Below the bar there is no winner to name and nothing honest to
    // bank -- but the user is owed the reason, not just a refusal, so
    // the explanation is one tap away rather than buried in the
    // methodology page.
    if (check.block != VerdictBlock.none) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.foodComparisonTooClose,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: () => _explainNoVerdict(l10n, locale, check),
            child: Text(l10n.foodVerdictWhyCta),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ComparisonDeltaCard(
          headline: l10n.foodComparisonDelta(
            bestLabel,
            formatCO2Compact(summary.deltaGrams.round()),
            worstLabel,
            summary.deltaPercent.round(),
          ),
          equivalencyText: (carKm != null && carKm >= 1)
              ? l10n.foodComparisonCarKmEquiv(carKm.round())
              : null,
        ),
        const SizedBox(height: spacingSm),
        FilledButton.icon(
          onPressed: busy
              ? null
              : () => _logChoice(
                  l10n,
                  mealSummaryLabel(
                    options[summary.bestIndex],
                    itemsById,
                    locale,
                  ),
                  mealSummaryLabel(
                    options[summary.worstIndex],
                    itemsById,
                    locale,
                  ),
                  summary.deltaGrams,
                ),
          icon: const Icon(Icons.eco),
          label: Text(l10n.foodLogChoiceCta(bestLabel)),
        ),
      ],
    );
  }

  /// Explains why the comparison declined to name a winner.
  ///
  /// Five different reasons, and they are not interchangeable: two
  /// close meals, two incompatible sources, one ingredient whose own
  /// evidence is too wide to rank on, a gap that rests on items sharing
  /// a derivation, or a winner that swaps when that derivation is held
  /// to one value.
  void _explainNoVerdict(
    AppLocalizations l10n,
    String locale,
    VerdictCheck check,
  ) {
    final percent = check.requiredPercent.round();
    final body = switch (check.block) {
      VerdictBlock.crossSource => l10n.foodVerdictCrossSource(percent),
      VerdictBlock.tiedBasis => l10n.foodVerdictTiedBasis(percent),
      VerdictBlock.tiedBasisFlips => l10n.foodVerdictTiedBasisFlips,
      VerdictBlock.uncertainItem => l10n.foodVerdictUncertainItem(
        check.item?.name(locale) ?? '',
        check.item?.statisticRatio?.toStringAsFixed(1) ?? '',
        percent,
      ),
      _ => l10n.foodVerdictTooClose(percent),
    };
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.foodVerdictBlockedTitle),
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

  /// Banks the avoided emissions (worse meal minus the one eaten) as a
  /// real food action (8.12), then clears both columns.
  Future<void> _logChoice(
    AppLocalizations l10n,
    String chosenLabel,
    String baselineLabel,
    double deltaGrams,
  ) async {
    final amount = formatCO2Compact(deltaGrams.round());
    final ok = await ref
        .read(foodChoiceLoggerProvider.notifier)
        .logChoice(
          name: l10n.foodCustomActionName(chosenLabel, baselineLabel),
          co2Grams: deltaGrams.round(),
        );
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (ok) {
      ref.read(mealOptionsProvider.notifier).clear();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.foodChoiceLoggedMessage(amount))),
      );
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    }
  }
}
