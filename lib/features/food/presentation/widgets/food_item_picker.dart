import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';

/// Grouped, searchable food-item list for the ingredient editor.
///
/// Builds lazily: the dataset is growing well past the point where a
/// plain `Column` of every tile is viable, and the picker has no other
/// way to reach an item near the end of the list.
///
/// With an empty query the list is grouped in dataset order. While
/// searching it flattens to ranked results, because group headers only
/// get in the way when the user already knows what they want.
class FoodItemPicker extends StatefulWidget {
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
  State<FoodItemPicker> createState() => _FoodItemPickerState();
}

class _FoodItemPickerState extends State<FoodItemPicker> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // Filtering is a local pass over a few hundred items, so it runs
      // on every keystroke -- no debounce needed, unlike the action log
      // where the query round-trips through a provider.
      final next = _controller.text;
      if (next != _query) setState(() => _query = next);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Flattened rows so the whole picker can be one lazy list: a group
  /// header is a `String`, an item row is a [FoodItem].
  List<Object> _rows() {
    final matches = searchFoodItems(widget.items, _query);
    if (_query.trim().isNotEmpty) return matches;
    final rows = <Object>[];
    String? lastGroup;
    for (final item in matches) {
      if (item.group != lastGroup) {
        rows.add(item.group);
        lastGroup = item.group;
      }
      rows.add(item);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rows = _rows();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            spacingLg,
            0,
            spacingLg,
            spacingSm,
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: l10n.foodSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _controller.clear,
                    ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radiusXl),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: spacingLg,
                vertical: spacingMd,
              ),
            ),
          ),
        ),
        if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.all(spacingXl),
            child: Text(
              l10n.foodSearchNoResults,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rows.length,
              itemBuilder: (context, index) {
                final row = rows[index];
                if (row is String) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      spacingLg,
                      spacingMd,
                      spacingLg,
                      0,
                    ),
                    child: Text(
                      foodGroupLabel(l10n, row),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return _ItemTile(
                  item: row as FoodItem,
                  onSelected: widget.onSelected,
                  onInfo: widget.onInfo,
                );
              },
            ),
          ),
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
