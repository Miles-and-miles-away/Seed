import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';

void main() {
  const sampleJson = {
    'id': 'climate_01',
    'category': 'climate',
    'nameEn': 'The Greenhouse Effect',
    'nameJa': '温室効果',
    'nameEs': 'El Efecto Invernadero',
    'factEn': 'Earth would be -18C without it.',
    'factJa': '温室効果がなければ地球は-18度です。',
    'factEs': 'La Tierra seria -18C sin el.',
    'sourceUrl': 'https://climate.nasa.gov/faq/19/',
    'iconName': 'climate_01',
    'condition': {'type': 'co2Saved', 'grams': 2000},
    'hintEn': 'Save 2 kg of CO2',
    'hintJa': '2kgのCO2を節約',
    'hintEs': 'Ahorra 2 kg de CO2',
  };

  group('EcoDexEntry.fromJson', () {
    test('parses all fields', () {
      final entry = EcoDexEntry.fromJson(sampleJson);

      expect(entry.id, 'climate_01');
      expect(entry.category, 'climate');
      expect(entry.nameEn, 'The Greenhouse Effect');
      expect(entry.nameJa, '温室効果');
      expect(entry.nameEs, 'El Efecto Invernadero');
      expect(entry.factEn, 'Earth would be -18C without it.');
      expect(entry.sourceUrl, 'https://climate.nasa.gov/faq/19/');
      expect(entry.iconName, 'climate_01');
      expect(entry.hintEn, 'Save 2 kg of CO2');
    });

    test('defaults missing optional strings to empty', () {
      final json = Map<String, dynamic>.from(sampleJson)
        ..remove('factJa')
        ..remove('factEs')
        ..remove('sourceUrl')
        ..remove('hintJa')
        ..remove('hintEs');

      final entry = EcoDexEntry.fromJson(json);
      expect(entry.factJa, '');
      expect(entry.factEs, '');
      expect(entry.sourceUrl, '');
      expect(entry.hintJa, '');
      expect(entry.hintEs, '');
    });
  });

  group('locale-aware getters', () {
    late EcoDexEntry entry;

    setUp(() {
      entry = EcoDexEntry.fromJson(sampleJson);
    });

    group('name()', () {
      test('returns English by default', () {
        expect(entry.name('en'), 'The Greenhouse Effect');
      });

      test('returns Japanese for ja', () {
        expect(entry.name('ja'), '温室効果');
      });

      test('returns Spanish for es', () {
        expect(entry.name('es'), 'El Efecto Invernadero');
      });

      test('falls back to English for unknown locale', () {
        expect(entry.name('fr'), 'The Greenhouse Effect');
      });
    });

    group('fact()', () {
      test('returns English by default', () {
        expect(entry.fact('en'), 'Earth would be -18C without it.');
      });

      test('returns Japanese for ja', () {
        expect(entry.fact('ja'), '温室効果がなければ地球は-18度です。');
      });

      test('falls back to English when ja is empty', () {
        final noJa = EcoDexEntry.fromJson(
          Map<String, dynamic>.from(sampleJson)..['factJa'] = '',
        );
        expect(noJa.fact('ja'), noJa.factEn);
      });

      test('falls back to English when es is empty', () {
        final noEs = EcoDexEntry.fromJson(
          Map<String, dynamic>.from(sampleJson)..['factEs'] = '',
        );
        expect(noEs.fact('es'), noEs.factEn);
      });
    });

    group('hint()', () {
      test('returns English by default', () {
        expect(entry.hint('en'), 'Save 2 kg of CO2');
      });

      test('returns Japanese for ja', () {
        expect(entry.hint('ja'), '2kgのCO2を節約');
      });

      test('falls back to English when ja is empty', () {
        final noJa = EcoDexEntry.fromJson(
          Map<String, dynamic>.from(sampleJson)..['hintJa'] = '',
        );
        expect(noJa.hint('ja'), noJa.hintEn);
      });
    });
  });
}
