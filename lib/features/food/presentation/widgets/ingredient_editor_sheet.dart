import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/data/models/meal_ingredient_model.dart';
import 'package:seed_app/features/food/data/models/serving_preset_model.dart';
import 'package:seed_app/features/food/presentation/providers/food_providers.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';
import 'package:seed_app/features/food/presentation/widgets/food_item_picker.dart';
import 'package:seed_app/features/food/presentation/widgets/food_science_sheet.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Keeps the quantity input to digits with at most one decimal
/// separator; ',' is allowed because locale keypads emit it.
final _gramsInputFormatter = FilteringTextInputFormatter.allow(
  RegExp(r'^\d*[.,]?\d*'),
);

/// Full-precision seed for the editable grams field; drops a trailing
/// ".0" so whole values read cleanly.
String _gramsSeedText(double grams) {
  final text = grams.toString();
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}

/// Bottom sheet for adding or editing a meal ingredient (Phase 8.8).
///
/// Two steps in one sheet: a grouped item picker, then a quantity form
/// with serving-preset chips over an editable grams field. Pops with
/// the resulting [MealIngredient], or null when dismissed.
class IngredientEditorSheet extends ConsumerStatefulWidget {
  const IngredientEditorSheet({
    this.initialIngredient,
    this.initialItem,
    super.key,
  });

  /// Ingredient being edited, or null when adding a new one.
  final MealIngredient? initialIngredient;

  /// Resolved item of [initialIngredient]; skips the picker step when set.
  final FoodItem? initialItem;

  static Future<MealIngredient?> show(
    BuildContext context, {
    MealIngredient? initialIngredient,
    FoodItem? initialItem,
  }) {
    return showModalBottomSheet<MealIngredient>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
      builder: (_) => IngredientEditorSheet(
        initialIngredient: initialIngredient,
        initialItem: initialItem,
      ),
    );
  }

  @override
  ConsumerState<IngredientEditorSheet> createState() =>
      _IngredientEditorSheetState();
}

class _IngredientEditorSheetState extends ConsumerState<IngredientEditorSheet> {
  final _gramsController = TextEditingController();
  FoodItem? _item;
  String? _selectedPresetId;
  bool _gramsInvalid = false;

  @override
  void initState() {
    super.initState();
    _item = widget.initialItem;
    final ingredient = widget.initialIngredient;
    if (ingredient != null) {
      _gramsController.text = _gramsSeedText(ingredient.grams);
    }
  }

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }

  void _selectItem(FoodItem item) {
    setState(() {
      _item = item;
      _gramsInvalid = false;
      _selectedPresetId = null;
    });
  }

  void _applyPreset(ServingPreset preset) {
    setState(() {
      _gramsController.text = _gramsSeedText(preset.grams);
      _selectedPresetId = preset.id;
      _gramsInvalid = false;
    });
  }

  void _save() {
    final item = _item;
    if (item == null) return;
    // Locale keypads emit ',' as the decimal separator; normalize
    // before parsing so "12,5" reads as 12.5.
    final text = _gramsController.text.trim().replaceAll(',', '.');
    final grams = double.tryParse(text);
    // tryParse accepts "NaN" and "Infinity"; reject those too.
    if (grams == null || grams.isNaN || grams.isInfinite || grams < 0) {
      setState(() => _gramsInvalid = true);
      return;
    }
    Navigator.pop(context, MealIngredient(itemId: item.id, grams: grams));
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(foodItemsProvider);
    final item = _item;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: itemsAsync.when(
          data: (items) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              spacingLg,
              0,
              spacingLg,
              spacingLg,
            ),
            child: item == null ? _buildItemStep(items) : _buildFormStep(item),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(spacingXxl),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => const Padding(
            padding: EdgeInsets.all(spacingXxl),
            child: Center(child: ErrorDisplay()),
          ),
        ),
      ),
    );
  }

  Widget _buildItemStep(List<FoodItem> items) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.foodSelectItem,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: spacingMd),
        FoodItemPicker(
          items: items,
          onSelected: _selectItem,
          onInfo: (item) =>
              FoodScienceSheet.show(context, item: item, languageCode: locale),
        ),
      ],
    );
  }

  Widget _buildFormStep(FoodItem item) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.initialIngredient == null
              ? l10n.foodAddIngredient
              : l10n.foodEditIngredient,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: spacingMd),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(foodGroupIcon(item.group)),
          title: Text(item.name(locale)),
          subtitle: Text(foodItemFactorLabel(l10n, item)),
          trailing: TextButton(
            onPressed: () => setState(() {
              _item = null;
              _selectedPresetId = null;
            }),
            child: Text(l10n.foodChangeItem),
          ),
        ),
        if (item.servings.isNotEmpty) ...[
          const SizedBox(height: spacingSm),
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
        ],
        const SizedBox(height: spacingSm),
        TextField(
          controller: _gramsController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [_gramsInputFormatter],
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
        const SizedBox(height: spacingLg),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.buttonCancel),
              ),
            ),
            const SizedBox(width: spacingMd),
            Expanded(
              child: FilledButton(
                onPressed: _save,
                child: Text(l10n.buttonSave),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
