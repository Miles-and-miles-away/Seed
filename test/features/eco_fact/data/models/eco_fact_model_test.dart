import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';

void main() {
  group('EcoFact', () {
    const fullJson = {
      'dayOfYear': 42,
      'category': 'mythBuster',
      'factEn': 'English fact',
      'factJa': 'Japanese fact',
      'factEs': 'Spanish fact',
      'sourceEn': 'English source',
      'sourceJa': 'Japanese source',
      'sourceEs': 'Spanish source',
      'sourceUrl': 'https://example.com',
      'relatedSdgs': [7, 13],
      'unWorldDay': 'Earth Day',
    };

    const minimalJson = {
      'dayOfYear': 1,
      'category': 'comparison',
      'factEn': 'A fact',
      'sourceEn': 'A source',
    };

    group('fromJson', () {
      test('parses full JSON correctly', () {
        final fact = EcoFact.fromJson(fullJson);

        expect(fact.dayOfYear, 42);
        expect(fact.category, 'mythBuster');
        expect(fact.factEn, 'English fact');
        expect(fact.factJa, 'Japanese fact');
        expect(fact.factEs, 'Spanish fact');
        expect(fact.sourceEn, 'English source');
        expect(fact.sourceJa, 'Japanese source');
        expect(fact.sourceEs, 'Spanish source');
        expect(fact.sourceUrl, 'https://example.com');
        expect(fact.relatedSdgs, [7, 13]);
        expect(fact.unWorldDay, 'Earth Day');
      });

      test('handles minimal JSON with defaults', () {
        final fact = EcoFact.fromJson(minimalJson);

        expect(fact.dayOfYear, 1);
        expect(fact.category, 'comparison');
        expect(fact.factEn, 'A fact');
        expect(fact.factJa, '');
        expect(fact.factEs, '');
        expect(fact.sourceJa, '');
        expect(fact.sourceEs, '');
        expect(fact.sourceUrl, '');
        expect(fact.relatedSdgs, isEmpty);
        expect(fact.unWorldDay, isNull);
      });

      test('handles null relatedSdgs', () {
        final json = {
          ...minimalJson,
          'relatedSdgs': null,
        };
        final fact = EcoFact.fromJson(json);
        expect(fact.relatedSdgs, isEmpty);
      });
    });

    group('getFact', () {
      test('returns English for en locale', () {
        final fact = EcoFact.fromJson(fullJson);
        expect(fact.getFact('en'), 'English fact');
      });

      test('returns Japanese for ja locale', () {
        final fact = EcoFact.fromJson(fullJson);
        expect(fact.getFact('ja'), 'Japanese fact');
      });

      test('returns Spanish for es locale', () {
        final fact = EcoFact.fromJson(fullJson);
        expect(fact.getFact('es'), 'Spanish fact');
      });

      test('falls back to English for ja when empty', () {
        final fact = EcoFact.fromJson(minimalJson);
        expect(fact.getFact('ja'), 'A fact');
      });

      test('falls back to English for unknown locale', () {
        final fact = EcoFact.fromJson(fullJson);
        expect(fact.getFact('fr'), 'English fact');
      });
    });

    group('getSource', () {
      test('returns locale-specific source', () {
        final fact = EcoFact.fromJson(fullJson);
        expect(fact.getSource('ja'), 'Japanese source');
      });

      test('falls back to English when empty', () {
        final fact = EcoFact.fromJson(minimalJson);
        expect(fact.getSource('es'), 'A source');
      });
    });

    test('construction with named params', () {
      const fact = EcoFact(
        dayOfYear: 100,
        category: 'positiveNews',
        factEn: 'Good news',
        sourceEn: 'A source',
      );

      expect(fact.dayOfYear, 100);
      expect(fact.category, 'positiveNews');
      expect(fact.factJa, '');
      expect(fact.relatedSdgs, isEmpty);
    });
  });
}
