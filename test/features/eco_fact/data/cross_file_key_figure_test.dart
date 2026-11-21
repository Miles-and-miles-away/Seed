import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// keyFigureEn values that Eco-Dex entries or SDG goals share with another
/// entry, each group reviewed as different statistics. A new collision
/// fails until a person checks it is not the same statistic restated and
/// lists it here; the same statistic gets a different figure instead.
const _reviewedDistinct = {
  '25%': {
    'fact 7',
    'fact 109',
    'dex food_03',
    'dex food_05',
    'dex selfless_02',
    'dex journey_01',
  },
  '80%': {'fact 11', 'fact 104', 'fact 116', 'fact 190', 'dex oceans_07'},
  '30%': {
    'fact 30',
    'fact 138',
    'fact 171',
    'fact 189',
    'fact 249',
    'fact 312',
    'dex oceans_02',
    'dex energy_09',
    'dex gem_01',
  },
  '50%': {'fact 31', 'fact 110', 'fact 296', 'dex climate_01'},
  '10 times': {'fact 64', 'fact 213', 'dex oceans_01'},
  '6%': {'fact 71', 'dex climate_08'},
  '20%': {
    'fact 72',
    'fact 105',
    'fact 139',
    'fact 187',
    'fact 244',
    'fact 319',
    'dex food_08',
  },
  '10%': {'fact 79', 'fact 320', 'dex energy_07'},
  '60%': {'fact 100', 'fact 340', 'dex circular_02', 'dex circular_10'},
  '32%': {'fact 120', 'dex food_01', 'SDG 15'},
  '75%': {'fact 132', 'fact 188', 'fact 316', 'dex food_09', 'dex gem_02'},
  '12%': {'fact 162', 'dex energy_11', 'dex circular_08'},
  '16%': {'fact 291', 'dex people_03'},
  '41%': {'dex bio_07', 'dex energy_01'},
  '2.1 billion': {'dex people_08', 'dex selfless_01'},
};

List<Map<String, Object?>> _entries(String path) =>
    switch (jsonDecode(File(path).readAsStringSync())) {
      final List<Object?> list => list.cast(),
      {'entries': final List<Object?> entries} => entries.cast(),
      _ => throw FormatException('Unexpected shape', path),
    };

void main() {
  test('figures shared with Eco-Dex or SDG entries are reviewed', () {
    final owners = <String, Set<String>>{};
    void add(String path, String Function(Map<String, Object?>) label) {
      for (final entry in _entries(path)) {
        if (entry['keyFigureEn'] case final String figure) {
          owners.putIfAbsent(figure, () => {}).add(label(entry));
        }
      }
    }

    add('data/app/eco_facts.json', (e) => 'fact ${e['dayOfYear']}');
    add('data/app/eco_dex_entries.json', (e) => 'dex ${e['id']}');
    add('data/app/sdg_goals.json', (e) => 'SDG ${e['number']}');

    final shared = {
      for (final MapEntry(key: figure, value: labels) in owners.entries)
        if (labels.length > 1 && labels.any((l) => !l.startsWith('fact ')))
          figure: labels,
    };
    expect(shared, _reviewedDistinct);
  });
}
