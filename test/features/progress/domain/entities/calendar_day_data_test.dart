import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';

void main() {
  group('CalendarDayData', () {
    group('completionRatio', () {
      test('returns 0.0 when goalTarget is 0', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 5,
          goalTarget: 0,
          completedSdgs: const [1, 2, 3],
          isToday: false,
          isFuture: false,
        );

        expect(data.completionRatio, 0.0);
      });

      test('returns 0.0 when goalTarget is negative', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 5,
          goalTarget: -1,
          completedSdgs: const [1, 2, 3],
          isToday: false,
          isFuture: false,
        );

        expect(data.completionRatio, 0.0);
      });

      test('returns correct ratio for partial completion', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 3,
          goalTarget: 6,
          completedSdgs: const [1, 2, 3],
          isToday: false,
          isFuture: false,
        );

        expect(data.completionRatio, 0.5);
      });

      test('returns 1.0 when goals exactly met', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 5,
          goalTarget: 5,
          completedSdgs: const [1, 2, 3, 4, 5],
          isToday: false,
          isFuture: false,
        );

        expect(data.completionRatio, 1.0);
      });

      test('clamps to 1.0 when goals exceeded', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 10,
          goalTarget: 5,
          completedSdgs: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
          isToday: false,
          isFuture: false,
        );

        expect(data.completionRatio, 1.0);
      });

      test('returns 0.0 when no goals completed', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 0,
          goalTarget: 5,
          completedSdgs: const [],
          isToday: false,
          isFuture: false,
        );

        expect(data.completionRatio, 0.0);
      });
    });

    group('isGoalMet', () {
      test('returns true when goalCount equals goalTarget', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 5,
          goalTarget: 5,
          completedSdgs: const [1, 2, 3, 4, 5],
          isToday: false,
          isFuture: false,
        );

        expect(data.isGoalMet, isTrue);
      });

      test('returns true when goalCount exceeds goalTarget', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 7,
          goalTarget: 5,
          completedSdgs: const [1, 2, 3, 4, 5, 6, 7],
          isToday: false,
          isFuture: false,
        );

        expect(data.isGoalMet, isTrue);
      });

      test('returns false when goalCount is less than goalTarget', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 3,
          goalTarget: 5,
          completedSdgs: const [1, 2, 3],
          isToday: false,
          isFuture: false,
        );

        expect(data.isGoalMet, isFalse);
      });
    });

    group('hasActivity', () {
      test('returns true when goalCount is positive', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 1,
          goalTarget: 5,
          completedSdgs: const [1],
          isToday: false,
          isFuture: false,
        );

        expect(data.hasActivity, isTrue);
      });

      test('returns false when goalCount is zero', () {
        final data = CalendarDayData(
          date: DateTime(2024, 1, 15),
          goalCount: 0,
          goalTarget: 5,
          completedSdgs: const [],
          isToday: false,
          isFuture: false,
        );

        expect(data.hasActivity, isFalse);
      });
    });

    group('constructor', () {
      test('creates instance with all required parameters', () {
        final date = DateTime(2024, 1, 15);
        final data = CalendarDayData(
          date: date,
          goalCount: 3,
          goalTarget: 5,
          completedSdgs: const [1, 2, 3],
          isToday: true,
          isFuture: false,
        );

        expect(data.date, date);
        expect(data.goalCount, 3);
        expect(data.goalTarget, 5);
        expect(data.completedSdgs, const [1, 2, 3]);
        expect(data.isToday, isTrue);
        expect(data.isFuture, isFalse);
      });
    });
  });
}
