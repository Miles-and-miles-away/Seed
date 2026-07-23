import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';
import 'package:seed_app/features/food/presentation/providers/food_choice_providers.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/domain/services/impact_equivalencies.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Side-by-side comparison of the staged meal options (Phase 8.9).
///
/// Bars scale to the worst option; the best is highlighted. The delta
/// line says "emits X less CO2e", never "saves" (data review copy rule
/// -- nothing was saved, these are hypothetical alternatives). The
/// winning option's reduction is illustrated with the Phase 6 driving
/// (car-km) equivalency, which reads better than tree-years at meal
/// magnitudes. Banking a chosen meal (8.12) reuses the category-agnostic
/// customActions bridge.
class MealComparisonScreen extends ConsumerStatefulWidget {
  const MealComparisonScreen({
    required this.options,
    required this.itemsById,
    super.key,
  });

  /// Staged meals (each a list of ingredients), in the order added.
  final List<List<MealIngredient>> options;

  /// Resolved items for totals and labels.
  final Map<String, FoodItem> itemsById;

  @override
  ConsumerState<MealComparisonScreen> createState() =>
      _MealComparisonScreenState();
}

class _MealComparisonScreenState extends ConsumerState<MealComparisonScreen> {
  late final List<double> _totals = [
    for (final ingredients in widget.options)
      FoodCalculator.mealCo2eGrams(widget.itemsById, ingredients),
  ];
  late final ComparisonSummary? _summary = compareTotals(_totals);

  /// The option the user actually ate (defaults to greenest) and the
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
  /// have emitted (baseline) minus what they ate (chosen).
  double get _bankDelta => _totals[_baselineIndex] - _totals[_chosenIndex];

  /// A bank is honest only for two distinct options with a positive
  /// saving (a greener-than-chosen baseline would credit nothing).
  bool get _canBank => _chosenIndex != _baselineIndex && _bankDelta > 0;

  String _optionLabel(int i) {
    final locale = Localizations.localeOf(context).languageCode;
    return mealOptionLabel(widget.options[i], widget.itemsById, locale);
  }

  void _logComparisonRun() {
    final summary = _summary;
    if (summary == null) return;
    final itemIds = <String>{
      for (final ingredients in widget.options)
        for (final ingredient in ingredients) ingredient.itemId,
    }.toList();
    ref
        .read(analyticsServiceProvider)
        .logFoodComparisonRun(
          itemIds: itemIds,
          ingredientCounts: [
            for (final ingredients in widget.options) ingredients.length,
          ],
          winningItemId: _dominantItemId(widget.options[summary.bestIndex]),
        );
  }

  String _dominantItemId(List<MealIngredient> ingredients) {
    if (ingredients.isEmpty) return '';
    var dominant = ingredients.first;
    var maxGrams = -1.0;
    for (final ingredient in ingredients) {
      final item = widget.itemsById[ingredient.itemId];
      if (item == null) continue;
      final grams = FoodCalculator.ingredientCo2eGrams(item, ingredient);
      if (grams > maxGrams) {
        maxGrams = grams;
        dominant = ingredient;
      }
    }
    return dominant.itemId;
  }

  /// Banks the greener choice: the avoided emissions (the meal the user
  /// ate vs the alternative they affirm they avoided) logged as a real
  /// action (8.12). Clears the comparison and returns to the calculator
  /// on success.
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
      ref.read(mealComparisonProvider.notifier).clear();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.foodChoiceLoggedMessage(amount))),
      );
      Navigator.of(context).pop();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final summary = _summary;
    final worst = summary == null ? 0.0 : _totals[summary.worstIndex];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.foodComparisonTitle)),
      body: ListView(
        padding: const EdgeInsets.all(spacingLg),
        children: [
          for (var i = 0; i < widget.options.length; i++)
            ComparisonOptionBar(
              label: _optionLabel(i),
              grams: _totals[i],
              fraction: worst <= 0 ? 0 : _totals[i] / worst,
              isBest: summary != null && i == summary.bestIndex,
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

  /// Delta headline plus the Phase 6 driving (car-km) equivalency.
  Widget _buildDeltaCard(AppLocalizations l10n, ComparisonSummary summary) {
    final carKm = ref
        .watch(impactEquivalenciesDataProvider)
        .whenOrNull(
          data: (metadata) => computeImpactEquivalencies(
            summary.deltaGrams.round(),
            metadata,
          ).where((e) => e.type == EquivalencyType.carKm).firstOrNull?.value,
        );
    return ComparisonDeltaCard(
      headline: l10n.foodComparisonDelta(
        _optionLabel(summary.bestIndex),
        formatCO2Compact(summary.deltaGrams.round()),
        _optionLabel(summary.worstIndex),
        summary.deltaPercent.round(),
      ),
      equivalencyText: (carKm != null && carKm >= 0.5)
          ? l10n.foodComparisonCarKmEquiv(carKm.round())
          : null,
    );
  }

  Widget _buildLogChoice(AppLocalizations l10n, ComparisonSummary summary) {
    final theme = Theme.of(context);
    final labels = [
      for (var i = 0; i < widget.options.length; i++) _optionLabel(i),
    ];
    final chosenLabel = labels[_chosenIndex];
    final baselineLabel = labels[_baselineIndex];
    final busy = ref.watch(foodChoiceLoggerProvider).isLoading;
    // Two options leave only one sensible pairing, so skip the pickers
    // and bank the best-vs-worst delta directly.
    final showSelectors = widget.options.length >= 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSelectors) ...[
          ChoiceSelector(
            title: l10n.foodChoseLabel,
            labels: labels,
            selected: _chosenIndex,
            onChanged: (i) => setState(() => _chosenIndex = i),
          ),
          const SizedBox(height: spacingSm),
          ChoiceSelector(
            title: l10n.foodInsteadOfLabel,
            labels: labels,
            selected: _baselineIndex,
            onChanged: (i) => setState(() => _baselineIndex = i),
          ),
          const SizedBox(height: spacingMd),
        ],
        Text(
          _canBank
              ? l10n.foodLogChoiceBody(formatCO2Compact(_bankDelta.round()))
              : l10n.foodChoiceDistinctHint,
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
          label: Text(l10n.foodLogChoiceCta(chosenLabel)),
        ),
      ],
    );
  }
}
