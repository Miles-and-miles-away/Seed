import 'package:flutter/foundation.dart';

/// Real-world impact equivalencies surfaced beneath the headline total
/// on the Impact dashboard. Each type has its own conversion factor
/// (see `computeImpactEquivalencies`) and presentation rules (icon, label,
/// number format) handled in the widget layer.
enum EquivalencyType {
  /// Mature trees absorbing a year's worth of CO2.
  trees,

  /// Kilometers of average passenger-car driving avoided.
  carKm,

  /// Smartphone charges' worth of grid electricity.
  phoneCharges,

  /// Beef burgers' worth of food-system emissions avoided.
  burgers,
}

/// One impact-equivalency data point: the [type] of comparison and the
/// computed [value] in that type's natural unit (trees, km, charges,
/// burgers). Pure value object — formatting and icons live alongside
/// the widget that renders it.
@immutable
class ImpactEquivalency {
  const ImpactEquivalency({required this.type, required this.value});

  final EquivalencyType type;
  final double value;
}
