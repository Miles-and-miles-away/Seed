import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Proves the 20% comparison threshold rather than asserting it.
///
/// Poore & Nemecek publish both a mean and a median per product, and
/// the distributions are right-skewed: a minority of high-impact
/// producers pulls the mean above the median. This dataset ships the
/// means (D1). The risk that creates is that two foods sitting close
/// together on means can swap places on medians, so a verdict would be
/// an artefact of the statistic rather than a finding.
///
/// This asserts the property the in-app methodology page claims:
/// above a 20% gap the ordering is the same under either statistic,
/// once the three items whose OWN mean and median differ by 2x or more
/// are excluded -- for those, no gap is safe. Cheese and dark chocolate
/// are 48.8% apart on means and still swap.
///
/// Means: live per-kg grapher, verified 2026-08-04. Medians: the
/// archived pre-June-2022 grapher variables endpoint documented in
/// RESEARCH_FOOD.md section 1, summed over its seven stages (losses
/// excluded). Beef (dairy herd) is omitted -- retired by D5.
void main() {
  // (mean with losses, median without losses) per P&N product row.
  const stats = <String, (double, double)>{
    'Apples': (0.43, 0.3),
    'Bananas': (0.86, 0.8),
    'Barley': (1.18, 1.1),
    'Beef (beef herd)': (99.48, 59.6),
    'Beet Sugar': (1.81, 1.4),
    'Berries & Grapes': (1.53, 1.1),
    'Brassicas': (0.51, 0.4),
    'Cane Sugar': (3.2, 2.6),
    'Cassava': (1.32, 0.9),
    'Cheese': (23.88, 21.2),
    'Citrus Fruit': (0.39, 0.3),
    'Coffee': (28.53, 16.5),
    'Dark Chocolate': (46.65, 18.7),
    'Eggs': (4.67, 4.5),
    'Fish (farmed)': (13.63, 5.1),
    'Groundnuts': (3.23, 2.4),
    'Lamb & Mutton': (39.72, 24.5),
    'Maize': (1.7, 1.1),
    'Milk': (3.15, 2.8),
    'Nuts': (0.43, 0.2),
    'Oatmeal': (2.48, 1.6),
    'Onions & Leeks': (0.5, 0.3),
    'Other Fruit': (1.05, 0.7),
    'Other Pulses': (1.79, 1.6),
    'Other Vegetables': (0.53, 0.5),
    'Peas': (0.98, 0.8),
    'Pig Meat': (12.31, 7.2),
    'Potatoes': (0.46, 0.3),
    'Poultry Meat': (9.87, 6.1),
    'Rice': (4.45, 4.0),
    'Root Vegetables': (0.43, 0.3),
    'Tofu': (3.16, 3.0),
    'Tomatoes': (2.09, 1.4),
    'Wheat & Rye': (1.57, 1.4),
    'Wine': (1.79, 1.4),
  };

  /// Own-ratio >= 2x: the statistic choice dominates the value.
  const sensitive = {'Dark Chocolate', 'Fish (farmed)', 'Nuts'};
  const threshold = 20.0;

  test('no pair above the threshold reverses between mean and median', () {
    final products = stats.keys.where((p) => !sensitive.contains(p)).toList();
    final offenders = <String>[];
    for (var i = 0; i < products.length; i++) {
      for (var j = i + 1; j < products.length; j++) {
        final (meanA, medA) = stats[products[i]]!;
        final (meanB, medB) = stats[products[j]]!;
        if (meanA == meanB || medA == medB) continue;
        final gap =
            (meanA - meanB).abs() / (meanA > meanB ? meanA : meanB) * 100;
        if (gap < threshold) continue;
        if ((meanA > meanB) != (medA > medB)) {
          offenders.add(
            '${products[i]} vs ${products[j]} '
            '(${gap.toStringAsFixed(1)} pct apart on means)',
          );
        }
      }
    }
    expect(offenders, isEmpty, reason: 'reverses above threshold: $offenders');
  });

  test('the sensitive three are exactly those with a ratio >= 2x', () {
    for (final entry in stats.entries) {
      final (mean, median) = entry.value;
      expect(
        mean / median >= 2.0,
        sensitive.contains(entry.key),
        reason: '${entry.key} ratio ${(mean / median).toStringAsFixed(2)}x',
      );
    }
  });

  test('every sensitive product is flagged in the shipped dataset', () {
    // The exclusion is only honest if the app actually refuses to rank
    // them, which it does off this flag.
    const ids = {
      'Dark Chocolate': 'dark_chocolate',
      'Fish (farmed)': 'fish_farmed',
      'Nuts': 'tree_nuts',
    };
    final raw = File('data/app/food_items.json').readAsStringSync();
    final root = json.decode(raw) as Map<String, dynamic>;
    final items = (root['items'] as List<dynamic>).cast<Map<String, dynamic>>();
    final byId = {for (final i in items) i['id'] as String: i};
    for (final product in sensitive) {
      expect(
        byId[ids[product]!]?['statistic_sensitive'],
        isTrue,
        reason: '${ids[product]} must be flagged ($product ratio >= 2x)',
      );
    }
    // Nothing else may claim the flag without a documented ratio.
    final flagged = items
        .where((i) => i['statistic_sensitive'] == true)
        .map((i) => i['id'] as String)
        .toSet();
    expect(flagged, ids.values.toSet());
  });
}
