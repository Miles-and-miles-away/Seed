import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/dataset_helpers.dart';

void main() {
  final templates = rawDatasetById(
    'data/app/challenge_templates.json',
    'multiDay',
  );
  final entries = rawDatasetList('data/app/eco_dex_entries.json', 'entries');

  test('a challenge hint names its challenge title in every language', () {
    final wrong = <String>[];
    var checked = 0;
    for (final entry in entries) {
      final condition = entry['condition'] as Map<String, dynamic>;
      if (condition['type'] != 'multiDayChallenge') continue;
      checked++;
      final template = templates[condition['templateId']]!;
      for (final lang in const ['En', 'Ja', 'Es']) {
        final title = template['title$lang'] as String;
        final hint = entry['hint$lang'] as String;
        if (!hint.contains(title)) wrong.add('${entry['id']} hint$lang: $hint');
      }
    }
    expect(checked, isPositive);
    expect(wrong, isEmpty);
  });

  test('a zero-CO2 hint names zero-CO2 actions in every language', () {
    const markers = {'En': 'zero-CO2', 'Ja': 'CO2ゼロ', 'Es': 'sin CO2'};
    final wrong = <String>[];
    var checked = 0;
    for (final entry in entries) {
      final condition = entry['condition'] as Map<String, dynamic>;
      if (condition['type'] != 'uniqueZeroCo2Actions') continue;
      checked++;
      for (final MapEntry(key: lang, value: marker) in markers.entries) {
        final hint = entry['hint$lang'] as String;
        if (!hint.contains(marker)) wrong.add('${entry['id']}.hint$lang');
      }
    }
    expect(checked, isPositive);
    expect(wrong, isEmpty);
  });
}
