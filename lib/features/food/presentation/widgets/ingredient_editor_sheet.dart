import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/decimal_input.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/data/models/serving_preset_model.dart';
import 'package:seed_app/features/food/domain/services/food_calculator.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';
import 'package:seed_app/shared/widgets/editor_sheet_actions.dart';

/// An ingredient together with the option column it belongs to.
class IngredientPlacement {
  const IngredientPlacement(this.ingredient, this.option);

  final MealIngredient ingredient;
  final int option;
}

/// Bottom sheet for entering an ingredient's quantity (Phase 8.8).
///
/// The item is already chosen (dragged or tapped from the pool), so
/// this sheet is only serving presets and the grams field. When
/// [fixedOption] is null it ends in "Add to A" / "Add to B" buttons --
/// the tap path's equivalent of choosing a drop target, and the route
/// that works without dragging.
class IngredientEditorSheet extends StatefulWidget {
  const IngredientEditorSheet({
    required this.item,
    this.initialIngredient,
    this.fixedOption,
    super.key,
  });

  /// The item this ingredient uses.
  final FoodItem item;

  /// Ingredient being edited, or null when adding a new one.
  final MealIngredient? initialIngredient;

  /// The column this ingredient is bound to, or null to ask.
  final int? fixedOption;

  static Future<IngredientPlacement?> show(
    BuildContext context, {
    required FoodItem item,
    MealIngredient? initialIngredient,
    int? fixedOption,
  }) {
    return showModalBottomSheet<IngredientPlacement>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: sheetShape,
      builder: (_) => IngredientEditorSheet(
        item: item,
        initialIngredient: initialIngredient,
        fixedOption: fixedOption,
      ),
    );
  }

  @override
  State<IngredientEditorSheet> createState() => _IngredientEditorSheetState();
}

class _IngredientEditorSheetState extends State<IngredientEditorSheet> {
  final _gramsController = TextEditingController();
  String? _selectedPresetId;
  bool _gramsInvalid = false;

  @override
  void initState() {
    super.initState();
    final ingredient = widget.initialIngredient;
    if (ingredient != null) {
      _gramsController.text = decimalSeedText(ingredient.grams);
      return;
    }
    // Dose-dominated items open on their default serving rather than an
    // empty grams field: coffee is ~10 g of grounds against a 28.53
    // kg/kg factor, so "250" typed as if it were millilitres overstates
    // the cup by around 25x. Seeding the realistic dose makes the
    // preset the path of least resistance.
    final preset = widget.item.defaultServing;
    if (widget.item.isPresetOnly && preset != null) {
      _gramsController.text = decimalSeedText(preset.grams);
      _selectedPresetId = preset.id;
    }
  }

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }

  void _applyPreset(ServingPreset preset) {
    setState(() {
      _gramsController.text = decimalSeedText(preset.grams);
      _selectedPresetId = preset.id;
      _gramsInvalid = false;
    });
  }

  /// The ingredient as currently entered, for the preview and save.
  MealIngredient? get _draftIngredient {
    final grams = parseDecimalInput(_gramsController.text);
    return grams == null
        ? null
        : MealIngredient(itemId: widget.item.id, grams: grams);
  }

  void _save(int option) {
    final ingredient = _draftIngredient;
    if (ingredient == null) {
      setState(() => _gramsInvalid = true);
      return;
    }
    Navigator.pop(context, IngredientPlacement(ingredient, option));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final item = widget.item;
    final draft = _draftIngredient;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            spacingLg,
            0,
            spacingLg,
            spacingLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(foodGroupIcon(item.group)),
                title: Text(
                  item.name(locale),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(foodItemFactorLabel(l10n, item)),
              ),
              // What to put on the scale. The factor's basis and the
              // preset's basis have to agree, and where the dataset
              // measures something other than what a shopper weighs
              // (drained, shelled, dry) saying so is the difference
              // between a right answer and a 2.5x one.
              if (foodWeightBasisLabel(l10n, item) case final basis?) ...[
                Text(
                  basis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: spacingSm),
              ],
              if (item.servings.isNotEmpty) ...[
                Wrap(
                  spacing: spacingSm,
                  children: [
                    for (final preset in item.servings)
                      ChoiceChip(
                        label: Text(preset.name(locale)),
                        selected: _selectedPresetId == preset.id,
                        onSelected: (_) => _applyPreset(preset),
                      ),
                  ],
                ),
                const SizedBox(height: spacingSm),
              ],
              TextField(
                controller: _gramsController,
                // Preset-only items are seeded with their default dose;
                // grabbing focus there invites overtyping the very
                // number that protects the user.
                autofocus: !item.isPresetOnly,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [decimalInputFormatter],
                decoration: InputDecoration(
                  labelText: l10n.foodQuantityLabel,
                  border: const OutlineInputBorder(),
                  errorText: _gramsInvalid ? l10n.foodQuantityInvalid : null,
                ),
                onChanged: (_) => setState(() {
                  _gramsInvalid = false;
                  _selectedPresetId = null;
                }),
              ),
              // The factor line above is per kg; this is the footprint
              // of the quantity actually entered.
              if (draft != null)
                EntryPreviewLine(
                  FoodCalculator.ingredientCo2eGrams(item, draft).round(),
                ),
              const SizedBox(height: spacingLg),
              EditorSheetActions(
                fixedOption: widget.fixedOption,
                onSave: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
