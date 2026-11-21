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
}
