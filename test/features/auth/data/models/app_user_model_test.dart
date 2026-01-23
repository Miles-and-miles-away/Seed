import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';

void main() {
  group('AppUserModel', () {
    group('construction', () {
      test('creates model with required fields', () {
        const model = AppUserModel(
          uid: 'user123',
          email: 'test@example.com',
        );

        expect(model.uid, 'user123');
        expect(model.email, 'test@example.com');
      });

      test('has correct default values', () {
        const model = AppUserModel(
          uid: 'user123',
          email: 'test@example.com',
        );

        expect(model.displayName, isNull);
        expect(model.photoUrl, isNull);
        expect(model.points, 0);
        expect(model.level, 1);
        expect(model.currentStreak, 0);
        expect(model.longestStreak, 0);
        expect(model.language, 'en');
        expect(model.notificationTime, '09:00');
        expect(model.createdAt, isNull);
        expect(model.emailVerified, isFalse);
        expect(model.dailyGoalTarget, isNull);
      });

      test('creates model with all fields', () {
        final createdAt = DateTime(2024, 1, 15);
        final model = AppUserModel(
          uid: 'user123',
          email: 'test@example.com',
          displayName: 'Test User',
          photoUrl: 'https://example.com/photo.jpg',
          points: 500,
          level: 5,
          currentStreak: 7,
          longestStreak: 14,
          language: 'ja',
          notificationTime: '08:00',
          createdAt: createdAt,
          emailVerified: true,
          dailyGoalTarget: 5,
        );

        expect(model.displayName, 'Test User');
        expect(model.photoUrl, 'https://example.com/photo.jpg');
        expect(model.points, 500);
        expect(model.level, 5);
        expect(model.currentStreak, 7);
        expect(model.longestStreak, 14);
        expect(model.language, 'ja');
        expect(model.notificationTime, '08:00');
        expect(model.createdAt, createdAt);
        expect(model.emailVerified, isTrue);
        expect(model.dailyGoalTarget, 5);
      });
    });

    group('fromJson', () {
      test('creates model from JSON without timestamp', () {
        final json = {
          'uid': 'user123',
          'email': 'test@example.com',
          'displayName': 'Test User',
          'points': 100,
          'level': 2,
        };

        final model = AppUserModel.fromJson(json);

        expect(model.uid, 'user123');
        expect(model.email, 'test@example.com');
        expect(model.displayName, 'Test User');
        expect(model.points, 100);
        expect(model.level, 2);
      });

      test('creates model from JSON with Timestamp', () {
        final timestamp = Timestamp.fromDate(DateTime(2024, 1, 15));
        final json = {
          'uid': 'user123',
          'email': 'test@example.com',
          'createdAt': timestamp,
        };

        final model = AppUserModel.fromJson(json);

        expect(model.createdAt, DateTime(2024, 1, 15));
      });

      test('handles null createdAt', () {
        final json = {
          'uid': 'user123',
          'email': 'test@example.com',
          'createdAt': null,
        };

        final model = AppUserModel.fromJson(json);

        expect(model.createdAt, isNull);
      });
    });

    group('toJson', () {
      test('converts model to JSON', () {
        const model = AppUserModel(
          uid: 'user123',
          email: 'test@example.com',
          displayName: 'Test User',
          points: 200,
        );

        final json = model.toJson();

        expect(json['uid'], 'user123');
        expect(json['email'], 'test@example.com');
        expect(json['displayName'], 'Test User');
        expect(json['points'], 200);
      });

      test('converts createdAt to Timestamp', () {
        final createdAt = DateTime(2024, 6, 15);
        final model = AppUserModel(
          uid: 'user123',
          email: 'test@example.com',
          createdAt: createdAt,
        );

        final json = model.toJson();

        expect(json['createdAt'], isA<Timestamp>());
        expect((json['createdAt'] as Timestamp).toDate(), createdAt);
      });
    });

    group('copyWith', () {
      test('creates copy with modified fields', () {
        const original = AppUserModel(
          uid: 'user123',
          email: 'test@example.com',
          points: 100,
        );

        final copy = original.copyWith(points: 200);

        expect(copy.uid, 'user123');
        expect(copy.email, 'test@example.com');
        expect(copy.points, 200);
      });

      test('original remains unchanged', () {
        const original = AppUserModel(
          uid: 'user123',
          email: 'test@example.com',
          points: 100,
        );

        final copy = original.copyWith(points: 200);

        expect(copy.points, 200);
        expect(original.points, 100);
      });
    });

    group('equality', () {
      test('two models with same values are equal', () {
        const model1 = AppUserModel(
          uid: 'user123',
          email: 'test@example.com',
        );

        const model2 = AppUserModel(
          uid: 'user123',
          email: 'test@example.com',
        );

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('two models with different values are not equal', () {
        const model1 = AppUserModel(
          uid: 'user123',
          email: 'test@example.com',
        );

        const model2 = AppUserModel(
          uid: 'user456',
          email: 'test@example.com',
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

    test('round-trip conversion preserves date', () {
      final date = DateTime(2024, 6, 15, 10, 30, 45);

      final timestamp = converter.toJson(date);
      final restored = converter.fromJson(timestamp);

      expect(restored, date);
    });
  });
}
