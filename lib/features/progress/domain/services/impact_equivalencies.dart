// ignore_for_file: avoid_classes_with_only_static_members
import 'package:seed_app/features/progress/data/impact_equivalencies_data.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';

/// Pure calculator that turns a total CO2 amount in grams into the
/// real-world equivalencies the Impact dashboard surfaces. The
/// conversion factors and their published sources live in
/// `data/app/impact_equivalencies.json` (see [EquivalencyMetadata])
/// and are loaded via the `impactEquivalenciesData` provider --
/// this class is intentionally stateless and metadata-agnostic so it
/// stays trivially testable.
abstract final class ImpactEquivalencies {
  /// Compute the equivalencies for [totalGrams] using the supplied
  /// [metadata] list. Order of the returned list matches the order
  /// of [metadata] so layouts don't shuffle across rebuilds.
  ///
  /// Negative totals are clamped to zero: if an undo/edit briefly
  /// pushes the running sum below zero, we'd rather display nothing
  /// than negative trees. Values may be fractional; callers decide
  /// how to round per type when displaying.
  static List<ImpactEquivalency> from(
    int totalGrams,
    List<EquivalencyMetadata> metadata,
  ) {
    final g = (totalGrams < 0 ? 0 : totalGrams).toDouble();
    return metadata
        .map(
          (m) => ImpactEquivalency(
            type: m.type,
            value: g / m.gramsPerUnit,
          ),
        )
        .toList(growable: false);
  }
}
