import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/transport/data/models/city_model.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_providers.dart';

/// Optional city-pair pickers that estimate leg distances.
///
/// Estimates only: every prefilled distance stays user-editable in
/// the distance field (standing decision). City names ship EN-only
/// in v1, so search matches the English names.
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

  static String _cityLabel(City city) => '${city.name}, ${city.cc}';

  @override
  Widget build(BuildContext context) {
    final city = selected;
    return Autocomplete<City>(
      // The form step unmounts this field; seeding from the selected
      // city keeps the visible text in sync with the estimate-driving
      // state when the mode step remounts it.
      initialValue: TextEditingValue(
        text: city == null ? '' : _cityLabel(city),
      ),
      displayStringForOption: _cityLabel,
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.length < 2) return const Iterable<City>.empty();
        return cities
            .where((c) => c.name.toLowerCase().contains(query))
            .take(_maxOptions);
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
            if (current != null && text != _cityLabel(current)) {
              onSelected(null);
            }
          },
          onSubmitted: (_) => onFieldSubmitted(),
        );
      },
    );
  }
}
