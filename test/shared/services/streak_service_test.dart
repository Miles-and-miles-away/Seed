import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/services/streak_service.dart';

void main() {
  group('StreakService', () {
    late StreakService service;

    setUp(() {
      service = StreakService.instance;
    });

    group('calculateStreakUpdate', () {
      test('first action ever sets streak to 1', () {
        final result = service.calculateStreakUpdate(
          lastActionDate: null,
          currentStreak: 0,
          longestStreak: 0,
          now: DateTime(2026, 1, 27),
        );

        expect(result.currentStreak, equals(1));
        expect(result.longestStreak, equals(1));
        expect(result.previousStreak, equals(0));
        expect(result.crossedMilestoneWeek, isNull);
        expect(result.streakWasBroken, isFalse);
      });

      test('action on same day does not change streak', () {
        final result = service.calculateStreakUpdate(
          lastActionDate: DateTime(2026, 1, 27, 9),
          currentStreak: 5,
          longestStreak: 10,
          now: DateTime(2026, 1, 27, 18), // Later same day
        );

        expect(result.currentStreak, equals(5));
        expect(result.longestStreak, equals(10));
        expect(result.previousStreak, equals(5));
        expect(result.crossedMilestoneWeek, isNull);
        expect(result.streakWasBroken, isFalse);
      });

      test('action on consecutive day increments streak', () {
        final result = service.calculateStreakUpdate(
          lastActionDate: DateTime(2026, 1, 26),
          currentStreak: 5,
          longestStreak: 10,
          now: DateTime(2026, 1, 27),
        );

        expect(result.currentStreak, equals(6));
        expect(result.longestStreak, equals(10));
        expect(result.previousStreak, equals(5));
        expect(result.crossedMilestoneWeek, isNull);
        expect(result.streakWasBroken, isFalse);
      });

      test('action on consecutive day updates longest streak when exceeded',
          () {
        final result = service.calculateStreakUpdate(
          lastActionDate: DateTime(2026, 1, 26),
          currentStreak: 10,
          longestStreak: 10,
          now: DateTime(2026, 1, 27),
        );

        expect(result.currentStreak, equals(11));
        expect(result.longestStreak, equals(11));
      });

      test('missed day resets streak to 1', () {
        final result = service.calculateStreakUpdate(
          lastActionDate: DateTime(2026, 1, 25), // 2 days ago
          currentStreak: 10,
          longestStreak: 15,
          now: DateTime(2026, 1, 27),
        );

        expect(result.currentStreak, equals(1));
        expect(result.longestStreak, equals(15)); // Unchanged
        expect(result.previousStreak, equals(10));
        expect(result.streakWasBroken, isTrue);
      });

      test('missed day does not set streakWasBroken if streak was already 1',
          () {
        final result = service.calculateStreakUpdate(
          lastActionDate: DateTime(2026, 1, 25), // 2 days ago
          currentStreak: 1,
          longestStreak: 5,
          now: DateTime(2026, 1, 27),
        );

        expect(result.currentStreak, equals(1));
        expect(result.streakWasBroken, isFalse);
      });

      test('detects 1-week milestone crossing (6 to 7 days)', () {
        final result = service.calculateStreakUpdate(
          lastActionDate: DateTime(2026, 1, 26),
          currentStreak: 6,
          longestStreak: 6,
          now: DateTime(2026, 1, 27),
        );

        expect(result.currentStreak, equals(7));
        expect(result.crossedMilestoneWeek, equals(1));
        expect(result.shouldShowMilestone, isTrue);
      });

      test('detects 2-week milestone crossing (13 to 14 days)', () {
        final result = service.calculateStreakUpdate(
          lastActionDate: DateTime(2026, 1, 26),
          currentStreak: 13,
          longestStreak: 13,
          now: DateTime(2026, 1, 27),
        );

        expect(result.currentStreak, equals(14));
        expect(result.crossedMilestoneWeek, equals(2));
        expect(result.shouldShowMilestone, isTrue);
      });

      test('does not detect milestone if not a milestone week', () {
        // 8 days is not a milestone (not week 1 or 2)
        final result = service.calculateStreakUpdate(
          lastActionDate: DateTime(2026, 1, 26),
          currentStreak: 8,
          longestStreak: 8,
          now: DateTime(2026, 1, 27),
        );

        expect(result.currentStreak, equals(9));
        expect(result.crossedMilestoneWeek, isNull);
        expect(result.shouldShowMilestone, isFalse);
      });

      test('handles timezone edge case - action just before midnight', () {
        final result = service.calculateStreakUpdate(
          lastActionDate: DateTime(2026, 1, 26, 23, 59),
          currentStreak: 5,
          longestStreak: 5,
          now: DateTime(2026, 1, 27, 0, 1), // Just after midnight
        );

        expect(result.currentStreak, equals(6));
      });

      test('travelling west (now on an earlier day) does not reset', () {
        // Log at 00:30 JST, fly to Honolulu where it is still the
        // previous calendar day: a negative day difference must be
        // treated as same-day, not as a broken streak.
        final result = service.calculateStreakUpdate(
          lastActionDate: DateTime(2026, 6, 12, 0, 30),
          currentStreak: 12,
          longestStreak: 12,
          now: DateTime(2026, 6, 11, 23),
        );

        expect(result.currentStreak, equals(12));
        expect(result.streakWasBroken, isFalse);
      });
    });

    group('displayedStreak', () {
      test('returns the stored streak when last action was yesterday', () {
        expect(
          service.displayedStreak(
            storedStreak: 6,
            lastActionDate: DateTime(2026, 6, 12, 22),
            now: DateTime(2026, 6, 13, 8),
          ),
          6,
        );
      });

      test('returns 0 once a missed day broke the streak', () {
        expect(
          service.displayedStreak(
            storedStreak: 6,
            lastActionDate: DateTime(2026, 6, 10),
            now: DateTime(2026, 6, 13),
          ),
          0,
        );
      });

      test('treats a null lastActionDate as live (pending write)', () {
        // A pending serverTimestamp briefly reads as null right after
        // logging; the streak must not flicker to zero.
        expect(
          service.displayedStreak(
            storedStreak: 6,
            lastActionDate: null,
            now: DateTime(2026, 6, 13),
          ),
          6,
        );
      });
    });

    group('getStreakWeeks', () {
      test('returns 0 for less than 7 days', () {
        expect(service.getStreakWeeks(0), equals(0));
        expect(service.getStreakWeeks(6), equals(0));
      });

      test('returns 1 for 7-13 days', () {
        expect(service.getStreakWeeks(7), equals(1));
        expect(service.getStreakWeeks(13), equals(1));
      });

      test('returns 2 for 14-20 days', () {
        expect(service.getStreakWeeks(14), equals(2));
        expect(service.getStreakWeeks(20), equals(2));
      });

      test('returns correct weeks for larger streaks', () {
        expect(service.getStreakWeeks(28), equals(4));
        expect(service.getStreakWeeks(56), equals(8));
        expect(service.getStreakWeeks(365), equals(52));
      });
    });

    group('weekMilestones', () {
      test('contains expected milestone weeks', () {
        expect(StreakService.weekMilestones, contains(1));
        expect(StreakService.weekMilestones, contains(2));
        expect(StreakService.weekMilestones, contains(3));
        expect(StreakService.weekMilestones, contains(4));
        expect(StreakService.weekMilestones, contains(8));
        expect(StreakService.weekMilestones, contains(12));
        expect(StreakService.weekMilestones, contains(26));
        expect(StreakService.weekMilestones, contains(52));
      });

      test('is sorted in ascending order', () {
        for (var i = 0; i < StreakService.weekMilestones.length - 1; i++) {
          expect(
            StreakService.weekMilestones[i],
            lessThan(StreakService.weekMilestones[i + 1]),
          );
        }
      });
    });
  });
}
