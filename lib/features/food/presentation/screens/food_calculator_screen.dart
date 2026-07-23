import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/food/presentation/screens/food_methodology_screen.dart';
import 'package:seed_app/features/food/presentation/screens/meal_comparison_screen.dart';
import 'package:seed_app/features/food/presentation/widgets/ingredient_editor_sheet.dart';
import 'package:seed_app/features/food/presentation/widgets/meal_ingredient_card.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Meal builder screen: build a meal from ingredients and see its CO2e
/// footprint. Educational tool only -- it never awards points or credits
/// CO2 savings (No Fake Points, Phase 8 plan).
///
/// Build a meal, stage it as a comparison option, then compare 2-3 side
/// by side (8.9). A methodology link (8.10) opens the sources page.
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(foodItemsByIdProvider);
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
        data: (itemsById) => _MealBuilderView(itemsById: itemsById),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: ErrorDisplay()),
      ),
    );
  }
}

class _MealBuilderView extends ConsumerWidget {
  const _MealBuilderView({required this.itemsById});

  final Map<String, FoodItem> itemsById;

  Future<void> _addIngredient(BuildContext context, WidgetRef ref) async {
    final ingredient = await IngredientEditorSheet.show(context);
    if (ingredient == null || !context.mounted) return;
    ref.read(mealBuilderProvider.notifier).addIngredient(ingredient);
  }

  Future<void> _editIngredient(
    BuildContext context,
    WidgetRef ref,
    int index,
    MealIngredient ingredient,
  ) async {
    final updated = await IngredientEditorSheet.show(
      context,
      initialIngredient: ingredient,
      initialItem: itemsById[ingredient.itemId],
    );
    if (updated == null || !context.mounted) return;
    ref.read(mealBuilderProvider.notifier).updateIngredient(index, updated);
  }

  /// Snapshots the current meal as a comparison option and clears the
  /// builder so the next option starts fresh.
  void _stageForComparison(BuildContext context, WidgetRef ref) {
    final ingredients = ref.read(mealBuilderProvider);
    ref.read(mealComparisonProvider.notifier).add(ingredients);
    ref.read(mealBuilderProvider.notifier).clear();
    final count = ref.read(mealComparisonProvider).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).foodOptionStaged(count)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openComparison(BuildContext context, WidgetRef ref) {
    final options = ref.read(mealComparisonProvider);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            MealComparisonScreen(options: options, itemsById: itemsById),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ingredients = ref.watch(mealBuilderProvider);
    final comparisonCount = ref.watch(mealComparisonProvider).length;
    if (ingredients.isEmpty) {
      return _EmptyMeal(
        onAddIngredient: () => _addIngredient(context, ref),
        comparisonCount: comparisonCount,
        onCompare: comparisonCount >= 2
            ? () => _openComparison(context, ref)
            : null,
      );
    }
    final total = FoodCalculator.mealCo2eGrams(itemsById, ingredients);
    final atCap = comparisonCount >= comparisonMaxOptions;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(spacingLg),
            children: [
              for (var i = 0; i < ingredients.length; i++)
                MealIngredientCard(
                  ingredient: ingredients[i],
                  item: itemsById[ingredients[i].itemId]!,
                  onTap: () => _editIngredient(context, ref, i, ingredients[i]),
                  onRemove: () => ref
                      .read(mealBuilderProvider.notifier)
                      .removeIngredient(i),
                ),
              const SizedBox(height: spacingSm),
              OutlinedButton.icon(
                onPressed: () => _addIngredient(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.foodAddIngredient),
              ),
              const SizedBox(height: spacingSm),
              FilledButton.tonalIcon(
                onPressed: atCap
                    ? null
                    : () => _stageForComparison(context, ref),
                icon: const Icon(Icons.playlist_add),
                label: Text(
                  atCap
                      ? l10n.foodComparisonFull(comparisonMaxOptions)
                      : l10n.foodAddToComparison,
                ),
              ),
              if (comparisonCount >= 2) ...[
                const SizedBox(height: spacingSm),
                FilledButton.icon(
                  onPressed: () => _openComparison(context, ref),
                  icon: const Icon(Icons.bar_chart),
                  label: Text(l10n.foodCompareOptions(comparisonCount)),
                ),
              ],
            ],
          ),
        ),
        _TotalBar(totalGrams: total),
      ],
    );
  }
}

/// Persistent meal total. Emissions of the built meal, not a saving --
/// comparison deltas (8.9) use "emits X less" copy.
class _TotalBar extends StatelessWidget {
  const _TotalBar({required this.totalGrams});

  final double totalGrams;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.foodTotalLabel,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: spacingSm),
              Flexible(
                child: Text(
                  '${formatCO2Compact(totalGrams.round())} CO2e',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyMeal extends StatelessWidget {
  const _EmptyMeal({
    required this.onAddIngredient,
    required this.comparisonCount,
    this.onCompare,
  });

  final VoidCallback onAddIngredient;
  final int comparisonCount;
  final VoidCallback? onCompare;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(spacingXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: spacingHuge,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: spacingMd),
            Text(
              l10n.foodMealEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: spacingLg),
            FilledButton.icon(
              onPressed: onAddIngredient,
              icon: const Icon(Icons.add),
              label: Text(l10n.foodAddIngredient),
            ),
            if (onCompare != null) ...[
              const SizedBox(height: spacingSm),
              FilledButton.tonalIcon(
                onPressed: onCompare,
                icon: const Icon(Icons.bar_chart),
                label: Text(l10n.foodCompareOptions(comparisonCount)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
