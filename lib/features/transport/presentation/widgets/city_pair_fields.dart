import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/transport/data/models/city_model.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';

/// Optional city-pair pickers that estimate leg distances.
///
/// Estimates only: every prefilled distance stays user-editable in
/// the distance field (standing decision). Cities carry sourced JA
/// and ES names where GeoNames publishes them; the label follows the
/// UI locale and search matches every locale name, accent-folded.
class CityPairFields extends ConsumerWidget {
  const CityPairFields({
    required this.from,
    required this.to,
    required this.onChanged,
    super.key,
  });

  /// Selected origin city, if any.
  final City? from;

  /// Selected destination city, if any.
  final City? to;

  /// Called whenever either selection changes.
  final void Function(City? from, City? to) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cities = ref.watch(transportCitiesProvider).value ?? const <City>[];
    // Loading or failed city data only costs the optional prefill;
    // manual distance entry keeps working, so render nothing.
    if (cities.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.transportCityPrefillHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: spacingSm),
        _CityField(
          cities: cities,
          label: l10n.transportFromCity,
          selected: from,
          onSelected: (city) => onChanged(city, to),
        ),
        const SizedBox(height: spacingSm),
        _CityField(
          cities: cities,
          label: l10n.transportToCity,
          selected: to,
          onSelected: (city) => onChanged(from, city),
        ),
      ],
    );
  }
}

class _CityField extends StatelessWidget {
  const _CityField({
    required this.cities,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final List<City> cities;
  final String label;
  final City? selected;
  final ValueChanged<City?> onSelected;

  /// Cities are population-sorted, so `take` surfaces likely picks.
  static const _maxOptions = 8;

  /// Matches every locale name, not just the active one, so a user who
  /// knows a city only as 東京 still finds it in an English UI.
  static bool _matches(City city, String query) => [
    city.name,
    city.nameJa,
    city.nameEs,
  ].nonNulls.any((n) => foldForSearch(n).contains(query));

  @override
  Widget build(BuildContext context) {
    final city = selected;
    final locale = Localizations.localeOf(context).languageCode;
    String cityLabel(City c) => '${c.localizedName(locale)}, ${c.cc}';
    return Autocomplete<City>(
      // initialValue seeds the controller once, at mount. Keying on the
      // locale remounts the field when the language changes, so the
      // visible label cannot drift out of sync with the label the
      // equality check below tests against.
      key: ValueKey(locale),
      // The form step unmounts this field; seeding from the selected
      // city keeps the visible text in sync with the estimate-driving
      // state when the mode step remounts it.
      initialValue: TextEditingValue(text: city == null ? '' : cityLabel(city)),
      displayStringForOption: cityLabel,
      optionsBuilder: (textEditingValue) {
        // Guard the folded needle, not the raw text: folding drops
        // quotes and combining marks, so two of those alone left an
        // empty query that every city contains.
        final query = foldForSearch(textEditingValue.text.trim());
        if (query.length < 2) return const Iterable<City>.empty();
        return cities.where((c) => _matches(c, query)).take(_maxOptions);
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: const Icon(Icons.location_city),
            border: const OutlineInputBorder(),
          ),
          onChanged: (text) {
            // Editing after a pick invalidates it; a stale selection
            // would keep estimates alive for the wrong pair.
            final current = selected;
            if (current != null && text != cityLabel(current)) {
              onSelected(null);
            }
          },
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
    );
  }
}
