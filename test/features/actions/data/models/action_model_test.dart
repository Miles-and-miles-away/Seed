import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';

void main() {
  group('ActionModel', () {
    group('construction', () {
      test('creates model with required fields', () {
        const model = ActionModel(
          id: 'action1',
          nameEn: 'Recycle Aluminum Can',
          nameJa: 'アルミ缶リサイクル',
          category: 'recycling',
          points: 5,
        );

        expect(model.id, 'action1');
        expect(model.nameEn, 'Recycle Aluminum Can');
        expect(model.nameJa, 'アルミ缶リサイクル');
        expect(model.category, 'recycling');
        expect(model.points, 5);
      });

      test('has correct default values', () {
        const model = ActionModel(
          id: 'action1',
          nameEn: 'Test Action',
          nameJa: 'テスト',
          category: 'recycling',
          points: 10,
        );

        expect(model.descriptionEn, '');
        expect(model.descriptionJa, '');
        expect(model.co2Grams, 0);
        expect(model.iconName, 'eco');
        expect(model.relatedSdgs, isEmpty);
        expect(model.isActive, isTrue);
        expect(model.sortOrder, 0);
      });

      test('creates model with all fields', () {
        const model = ActionModel(
          id: 'action1',
          nameEn: 'Recycle Aluminum Can',
          nameJa: 'アルミ缶リサイクル',
          descriptionEn: 'Recycle an aluminum can',
          descriptionJa: 'アルミ缶をリサイクルする',
          category: 'recycling',
          points: 5,
          co2Grams: 150,
          iconName: 'recycling',
          relatedSdgs: ['12', '13'],
          isActive: true,
          sortOrder: 1,
        );

        expect(model.descriptionEn, 'Recycle an aluminum can');
        expect(model.descriptionJa, 'アルミ缶をリサイクルする');
        expect(model.co2Grams, 150);
        expect(model.iconName, 'recycling');
        expect(model.relatedSdgs, ['12', '13']);
        expect(model.isActive, isTrue);
        expect(model.sortOrder, 1);
      });
    });

    group('fromJson', () {
      test('creates model from JSON map', () {
        final json = {
          'id': 'action1',
          'nameEn': 'Bike to Work',
          'nameJa': '自転車通勤',
          'descriptionEn': 'Commute by bike',
          'descriptionJa': '自転車で通勤する',
          'category': 'transport',
          'points': 20,
          'co2Grams': 500,
          'iconName': 'bike',
          'relatedSdgs': ['11', '13'],
          'isActive': true,
          'sortOrder': 2,
        };

        final model = ActionModel.fromJson(json);

        expect(model.id, 'action1');
        expect(model.nameEn, 'Bike to Work');
        expect(model.nameJa, '自転車通勤');
        expect(model.category, 'transport');
        expect(model.points, 20);
        expect(model.co2Grams, 500);
        expect(model.iconName, 'bike');
        expect(model.relatedSdgs, ['11', '13']);
      });

      test('handles missing optional fields', () {
        final json = {
          'id': 'action1',
          'nameEn': 'Test',
          'nameJa': 'テスト',
          'category': 'recycling',
          'points': 10,
        };

        final model = ActionModel.fromJson(json);

        expect(model.descriptionEn, '');
        expect(model.descriptionJa, '');
        expect(model.co2Grams, 0);
        expect(model.iconName, 'eco');
      });
    });

    group('toJson', () {
      test('converts model to JSON map', () {
        const model = ActionModel(
          id: 'action1',
          nameEn: 'Test Action',
          nameJa: 'テスト',
          category: 'recycling',
          points: 10,
          co2Grams: 100,
        );

        final json = model.toJson();

        expect(json['id'], 'action1');
        expect(json['nameEn'], 'Test Action');
        expect(json['nameJa'], 'テスト');
        expect(json['category'], 'recycling');
        expect(json['points'], 10);
        expect(json['co2Grams'], 100);
      });
    });

    group('equality', () {
      test('two models with same values are equal', () {
        const model1 = ActionModel(
          id: 'action1',
          nameEn: 'Test',
          nameJa: 'テスト',
          category: 'recycling',
          points: 10,
        );

        const model2 = ActionModel(
          id: 'action1',
          nameEn: 'Test',
          nameJa: 'テスト',
          category: 'recycling',
          points: 10,
        );

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('two models with different values are not equal', () {
        const model1 = ActionModel(
          id: 'action1',
          nameEn: 'Test',
          nameJa: 'テスト',
          category: 'recycling',
          points: 10,
        );

        const model2 = ActionModel(
          id: 'action2',
          nameEn: 'Test',
          nameJa: 'テスト',
          category: 'recycling',
          points: 10,
        );

        expect(model1, isNot(equals(model2)));
      });
    });
  });

  group('ActionModelLocalization', () {
    const model = ActionModel(
      id: 'action1',
      nameEn: 'Recycle Can',
      nameJa: '缶リサイクル',
      descriptionEn: 'Recycle a can',
      descriptionJa: '缶をリサイクルする',
      category: 'recycling',
      points: 5,
    );

    group('name', () {
      test('returns English name for en language code', () {
        expect(model.name('en'), 'Recycle Can');
      });

      test('returns Japanese name for ja language code', () {
        expect(model.name('ja'), '缶リサイクル');
      });

      test('returns English name for other language codes', () {
        expect(model.name('fr'), 'Recycle Can');
        expect(model.name('de'), 'Recycle Can');
      });
    });

    group('description', () {
      test('returns English description for en language code', () {
        expect(model.description('en'), 'Recycle a can');
      });

      test('returns Japanese description for ja language code', () {
        expect(model.description('ja'), '缶をリサイクルする');
      });

      test('returns English description for other language codes', () {
        expect(model.description('fr'), 'Recycle a can');
      });
    });
  });
}
