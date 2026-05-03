// ignore_for_file: avoid_classes_with_only_static_members
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';

/// Pure calculator that turns a total CO2 amount in grams into the
/// fixed set of real-world equivalencies the Impact dashboard
/// surfaces (trees, car km, phone charges, burgers).
///
/// Conversion factors are documented inline with their published
/// sources. Values are deliberately rough — these are illustrative
/// comparisons, not precise carbon accounting.
abstract final class ImpactEquivalencies {
  /// A mature tree absorbs roughly 21 kg of CO2 per year (US EPA).
  static const _gramsPerTreeYear = 21000.0;

  /// Average passenger car emits ~200 g CO2 per kilometer driven
  /// (UK DEFRA 2023 conversion factors).
  static const _gramsPerCarKm = 200.0;

  /// Charging an average smartphone once consumes ~8 g CO2-equivalent
  /// of grid electricity (US EPA Greenhouse Gas Equivalencies).
  static const _gramsPerPhoneCharge = 8.0;

  /// One beef burger represents ~3 kg of CO2-equivalent emissions
  /// across the full food-system lifecycle (Our World in Data).
  static const _gramsPerBurger = 3000.0;

  /// Compute the four equivalencies for [totalGrams]. Always returns
  /// the same four types in the same order so layouts don't shuffle
  /// across rebuilds. Values are non-negative and may be fractional;
  /// callers decide how to round per type when displaying.
  static List<ImpactEquivalency> from(int totalGrams) {
    final g = totalGrams.toDouble();
    return [
      ImpactEquivalency(
        type: EquivalencyType.trees,
        value: g / _gramsPerTreeYear,
      ),
      ImpactEquivalency(
        type: EquivalencyType.carKm,
        value: g / _gramsPerCarKm,
      ),
      ImpactEquivalency(
        type: EquivalencyType.phoneCharges,
        value: g / _gramsPerPhoneCharge,
      ),
      ImpactEquivalency(
        type: EquivalencyType.burgers,
        value: g / _gramsPerBurger,
      ),
    ];
  }
}
