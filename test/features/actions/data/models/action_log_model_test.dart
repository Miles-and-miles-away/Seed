import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/firestore_converters.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';

void main() {
  group('ActionLogModel', () {
    final testDate = DateTime(2024, 1, 15, 10, 30);

    group('construction', () {
      test('creates model with required fields', () {
        final model = ActionLogModel(
          id: 'log1',
          actionId: 'action1',
          actionName: 'Recycle Can',
          category: 'recycling',
          points: 5,
          loggedAt: testDate,
        );

        expect(model.id, 'log1');
        expect(model.actionId, 'action1');
        expect(model.actionName, 'Recycle Can');
        expect(model.category, 'recycling');
        expect(model.points, 5);
        expect(model.loggedAt, testDate);
      });

      test('has correct default values', () {
        final model = ActionLogModel(
          id: 'log1',
          actionId: 'action1',
          actionName: 'Test',
          category: 'recycling',
          points: 10,
          loggedAt: testDate,
        );

        expect(model.co2Grams, 0);
        expect(model.note, isNull);
        expect(model.relatedSdgs, isEmpty);
      });

      test('creates model with all fields', () {
        final model = ActionLogModel(
          id: 'log1',
          actionId: 'action1',
          actionName: 'Bike to Work',
          category: 'transport',
          points: 20,
          co2Grams: 500,
          loggedAt: testDate,
          note: 'Commuted 10km',
          relatedSdgs: ['11', '13'],
        );

        expect(model.co2Grams, 500);
        expect(model.note, 'Commuted 10km');
        expect(model.relatedSdgs, ['11', '13']);
      });
    });

    group('fromJson with RequiredTimestampConverter', () {
      test('creates model from JSON with Timestamp', () {
        final timestamp = Timestamp.fromDate(testDate);
        final json = {
          'id': 'log1',
          'actionId': 'action1',
          'actionName': 'Test Action',
          'category': 'recycling',
          'points': 10,
          'co2Grams': 100,
          'loggedAt': timestamp,
          'note': 'Test note',
          'relatedSdgs': ['12'],
        };

        final model = ActionLogModel.fromJson(json);

        expect(model.id, 'log1');
        expect(model.actionId, 'action1');
        expect(model.actionName, 'Test Action');
        expect(model.loggedAt, testDate);
        expect(model.note, 'Test note');
      });
    });

    group('toJson', () {
      test('converts model to JSON with Timestamp', () {
        final model = ActionLogModel(
          id: 'log1',
          actionId: 'action1',
          actionName: 'Test',
          category: 'recycling',
          points: 10,
          loggedAt: testDate,
        );

        final json = model.toJson();

        expect(json['id'], 'log1');
        expect(json['actionId'], 'action1');
        expect(json['actionName'], 'Test');
        expect(json['category'], 'recycling');
        expect(json['points'], 10);
        expect(json['loggedAt'], isA<Timestamp>());
      });
    });

    group('equality', () {
      test('two models with same values are equal', () {
        final model1 = ActionLogModel(
          id: 'log1',
          actionId: 'action1',
          actionName: 'Test',
          category: 'recycling',
          points: 10,
          loggedAt: testDate,
        );

        final model2 = ActionLogModel(
          id: 'log1',
          actionId: 'action1',
          actionName: 'Test',
          category: 'recycling',
          points: 10,
          loggedAt: testDate,
        );

        expect(model1, equals(model2));
      });

      test('two models with different IDs are not equal', () {
        final model1 = ActionLogModel(
          id: 'log1',
          actionId: 'action1',
          actionName: 'Test',
          category: 'recycling',
          points: 10,
          loggedAt: testDate,
        );

        final model2 = ActionLogModel(
          id: 'log2',
          actionId: 'action1',
          actionName: 'Test',
          category: 'recycling',
          points: 10,
          loggedAt: testDate,
        );

        expect(model1, isNot(equals(model2)));
      });
    });
  });

  group('RequiredTimestampConverter', () {
    const converter = RequiredTimestampConverter();
    final testDate = DateTime(2024, 6, 15, 14, 30, 45);

    test('fromJson converts Timestamp to DateTime', () {
      final timestamp = Timestamp.fromDate(testDate);
      final result = converter.fromJson(timestamp);

      expect(result, testDate);
    });

    test('toJson converts DateTime to Timestamp', () {
      final result = converter.toJson(testDate);

      expect(result, isA<Timestamp>());
      expect(result.toDate(), testDate);
    });

    test('round-trip conversion preserves date', () {
      final timestamp = converter.toJson(testDate);
      final restored = converter.fromJson(timestamp);

      expect(restored, testDate);
    });
  });
}
