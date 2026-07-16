import 'package:flutter/foundation.dart';

import 'package:seed_app/core/utils/json_asset_loader.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';

/// Source metadata for a single equivalency: the conversion factor
/// in grams of CO2 per natural unit (tree-year, km, charge, burger)
/// plus the published reference backing it. Loaded from
/// `data/app/impact_equivalencies.json` so factors and source URLs
/// live alongside the rest of the app's content data
/// (`sdg_resources.json`, `eco_facts.json`, etc.) rather than being
/// duplicated between code and ARB strings.
///
/// Note on CO2 vs CO2e: the source figures mix pure CO2 (tree
/// absorption) with CO2-equivalent (fuel combustion, grid mix, food
/// lifecycle). We treat them as comparable for an illustrative
/// dashboard rather than precise carbon accounting; the info sheet
/// surfaces this caveat to the user.
@immutable
class EquivalencyMetadata {
  const EquivalencyMetadata({
    required this.type,
    required this.gramsPerUnit,
    required this.sourceName,
    required this.sourceUrl,
  });

  factory EquivalencyMetadata.fromJson(Map<String, dynamic> json) {
    return EquivalencyMetadata(
      type: EquivalencyType.values.byName(json['type'] as String),
      gramsPerUnit: (json['gramsPerUnit'] as num).toDouble(),
      sourceName: json['sourceName'] as String,
      sourceUrl: json['sourceUrl'] as String,
    );
  }

  final EquivalencyType type;
  final double gramsPerUnit;
  final String sourceName;
  final String sourceUrl;
}

/// Loads all impact equivalencies from the bundled JSON asset.
/// Returned in JSON order, which matches the display order of the
/// equivalency row and info sheet.
Future<List<EquivalencyMetadata>> loadImpactEquivalencies() => loadJsonList(
  'data/app/impact_equivalencies.json',
  EquivalencyMetadata.fromJson,
);
