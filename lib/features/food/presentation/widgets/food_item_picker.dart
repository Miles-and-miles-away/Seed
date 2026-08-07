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
    this.recentIds = const [],
    super.key,
  });

  /// All items, in dataset order.
  final List<FoodItem> items;

  /// Ids picked recently, most recent first. Shown as a section above
  /// the grouped list when the user has not typed anything -- passed in
  /// rather than watched here so the picker stays a pure widget.
  final List<String> recentIds;

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
  ///
  /// Recents lead when there is no query. They are a shortcut, not a
  /// filter: the full grouped list still follows, and an item in
  /// recents also keeps its place in its own group.
  List<Object> _rows() {
    final matches = searchFoodItems(widget.items, _query);
    if (_query.trim().isNotEmpty) return matches;
    final rows = <Object>[];
    if (widget.recentIds.isNotEmpty) {
      final byId = {for (final item in widget.items) item.id: item};
      final recents = [for (final id in widget.recentIds) ?byId[id]];
      if (recents.isNotEmpty) {
        rows
          ..add(_kRecentsHeader)
          ..addAll(recents);
      }
    }
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
                      row == _kRecentsHeader
                          ? l10n.foodPickerRecents
                          : foodGroupLabel(l10n, row),
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

/// Sentinel header id; no dataset group can collide with it because
/// group ids are snake_case.
const _kRecentsHeader = '\u0000recents';

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
    // A row that needs its basis or its boundary stated carries it here
    // rather than only in the science sheet -- the picker is where the
    // number is first read, and a narrower-boundary row shown bare next
    // to the anchors invites a comparison it cannot support.
    final caveats = [
      foodWeightBasisLabel(l10n, item),
      foodBoundaryNoteLabel(l10n, item),
    ].nonNulls.join(' ');
    final factor = foodItemFactorLabel(l10n, item);
    return ListTile(
      isThreeLine: caveats.isNotEmpty,
      leading: Icon(foodGroupIcon(item.group)),
      title: Text(item.name(locale)),
      subtitle: Text(caveats.isEmpty ? factor : '$factor\n$caveats'),
      trailing: IconButton(
        icon: const Icon(Icons.info_outline),
        tooltip: l10n.foodItemScienceTooltip,
        onPressed: () => onInfo(item),
      ),
      onTap: () => onSelected(item),
    );
  }
}
