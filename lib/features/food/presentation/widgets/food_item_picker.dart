import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';

/// Grouped food-item list for the ingredient editor (Phase 8.8).
///
/// Groups render in dataset order. Each tile carries an info button
/// opening the per-item science sheet (8.10).
class FoodItemPicker extends StatelessWidget {
  const FoodItemPicker({
    required this.items,
    required this.onSelected,
    required this.onInfo,
    super.key,
  });

  /// All items, in dataset order.
  final List<FoodItem> items;

  /// Called with the picked item.
  final void Function(FoodItem item) onSelected;

  /// Opens the per-item science sheet.
  final void Function(FoodItem item) onInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final groups = <String, List<FoodItem>>{};
    for (final item in items) {
      groups.putIfAbsent(item.group, () => []).add(item);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in groups.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              spacingLg,
              spacingMd,
              spacingLg,
              0,
            ),
            child: Text(
              foodGroupLabel(l10n, entry.key),
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          for (final item in entry.value)
            _ItemTile(item: item, onSelected: onSelected, onInfo: onInfo),
        ],
      ],
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({
    required this.item,
    required this.onSelected,
    required this.onInfo,
  });

  final FoodItem item;
  final void Function(FoodItem item) onSelected;
  final void Function(FoodItem item) onInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return ListTile(
      leading: Icon(foodGroupIcon(item.group)),
      title: Text(item.name(locale)),
      subtitle: Text(foodItemFactorLabel(l10n, item)),
      trailing: IconButton(
        icon: const Icon(Icons.info_outline),
        tooltip: l10n.foodItemScienceTooltip,
        onPressed: () => onInfo(item),
      ),
      onTap: () => onSelected(item),
    );
  }
}
