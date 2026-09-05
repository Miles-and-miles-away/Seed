import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/firestore_converters.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';

void main() {
  group('MascotModel', () {
    group('construction', () {
      test('creates model with required fields', () {
        const model = MascotModel(id: 'test-id', speciesId: 'seed');

        expect(model.speciesId, 'seed');
        expect(model.id, 'test-id');
      });

      test('has correct default values', () {
        const model = MascotModel(id: 'test-id', speciesId: 'seed');

        expect(model.name, '');
        expect(model.mascotPoints, 0);
        expect(model.mascotLevel, 1);
        expect(model.isFullyEvolved, false);
        expect(model.equippedItems, isEmpty);
        expect(model.createdAt, isNull);
        expect(model.lastSeenStage, 1);
      });

      test('creates model with all fields', () {
        final createdAt = DateTime(2024, 6, 15);
        final model = MascotModel(
          id: 'test-id',
          speciesId: 'seed',
          name: 'Sprouty',
          mascotPoints: 500,
          mascotLevel: 5,
          equippedItems: const ['hat_001', 'accessory_002'],
          createdAt: createdAt,
          lastSeenStage: 2,
        );

        expect(model.speciesId, 'seed');
        expect(model.name, 'Sprouty');
        expect(model.mascotPoints, 500);
        expect(model.mascotLevel, 5);
        expect(model.equippedItems, hasLength(2));
        expect(model.createdAt, createdAt);
        expect(model.lastSeenStage, 2);
      });
    });

    group('fromJson', () {
      test('creates model from JSON', () {
        final json = {
          'id': 'test-id',
          'speciesId': 'seed',
          'name': 'Leafy',
          'equippedItems': ['hat_001'],
          'lastSeenStage': 3,
        };

        final model = MascotModel.fromJson(json);

        expect(model.id, 'test-id');
        expect(model.speciesId, 'seed');
        expect(model.name, 'Leafy');
        expect(model.equippedItems, ['hat_001']);
        expect(model.lastSeenStage, 3);
      });

      test('creates model from JSON with Timestamp', () {
        final timestamp = Timestamp.fromDate(DateTime(2024, 6, 15));
        final json = {
          'id': 'test-id',
          'speciesId': 'seed',
          'name': 'Sprouty',
          'createdAt': timestamp,
        };

        final model = MascotModel.fromJson(json);

        expect(model.createdAt, DateTime(2024, 6, 15));
      });

      test('handles missing optional fields', () {
        final json = {'id': 'test-id', 'speciesId': 'seed'};

        final model = MascotModel.fromJson(json);

        expect(model.name, '');
        expect(model.equippedItems, isEmpty);
        expect(model.createdAt, isNull);
        expect(model.lastSeenStage, 1);
      });
    });

    group('toJson', () {
      test('converts model to JSON', () {
        const model = MascotModel(
          id: 'test-id',
          speciesId: 'seed',
          name: 'Sprouty',
          equippedItems: ['hat_001'],
          lastSeenStage: 2,
        );

        final json = model.toJson();

        expect(json['id'], 'test-id');
        expect(json['speciesId'], 'seed');
        expect(json['name'], 'Sprouty');
        expect(json['equippedItems'], ['hat_001']);
        expect(json['lastSeenStage'], 2);
      });

      test('converts createdAt to Timestamp', () {
        final createdAt = DateTime(2024, 6, 15);
        final model = MascotModel(
          id: 'test-id',
          speciesId: 'seed',
          createdAt: createdAt,
        );

        final json = model.toJson();

        expect(json['createdAt'], isA<Timestamp>());
        expect((json['createdAt'] as Timestamp).toDate(), createdAt);
      });
    });

    group('copyWith', () {
      test('creates copy with modified name', () {
        const original = MascotModel(
          id: 'test-id',
          speciesId: 'seed',
          name: 'Sprouty',
        );

        final copy = original.copyWith(name: 'Leafy');

        expect(copy.speciesId, 'seed');
        expect(copy.name, 'Leafy');
      });

      test('original remains unchanged', () {
        const original = MascotModel(
          id: 'test-id',
          speciesId: 'seed',
          name: 'Sprouty',
        );

        final copy = original.copyWith(name: 'Leafy');

        expect(copy.name, 'Leafy');
        expect(original.name, 'Sprouty');
      });
    });

    group('equality', () {
      test('two models with same values are equal', () {
        const model1 = MascotModel(
          id: 'test-id',
          speciesId: 'seed',
          name: 'Sprouty',
        );

        const model2 = MascotModel(
          id: 'test-id',
          speciesId: 'seed',
          name: 'Sprouty',
        );

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('models with different values not equal', () {
        const model1 = MascotModel(
          id: 'test-id',
          speciesId: 'seed',
          name: 'Sprouty',
        );

        const model2 = MascotModel(
          id: 'test-id',
          speciesId: 'seed',
          name: 'Leafy',
        );

        expect(model1, isNot(equals(model2)));
      });
    });
  });

  group('TimestampConverter', () {
    const converter = TimestampConverter();

    test('fromJson converts Timestamp to DateTime', () {
      final date = DateTime(2024, 6, 15, 10, 30);
      final timestamp = Timestamp.fromDate(date);

      final result = converter.fromJson(timestamp);

      expect(result, date);
    });

    test('fromJson returns null for null input', () {
      final result = converter.fromJson(null);

      expect(result, isNull);
    });

    test('toJson converts DateTime to Timestamp', () {
      final date = DateTime(2024, 6, 15, 10, 30);

      final result = converter.toJson(date);

      expect(result, isA<Timestamp>());
      expect(result?.toDate(), date);
    });

    test('toJson returns null for null input', () {
      final result = converter.toJson(null);

      expect(result, isNull);
    });
  });
}
