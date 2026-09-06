import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/progress/data/repositories/progress_repository.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_stats_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

import '../../../../helpers/test_helpers.dart';

const _userId = 'test-user';

List<Override> _overrides(
  FakeFirebaseFirestore firestore, [
  AppUserModel? user,
]) => [
  _clock,
  userOverride(user),
  // The stats provider keys on the user id, not the whole doc.
  userIdProvider.overrideWithValue(user?.uid),
  // Replace the repository so it reads from fake firestore instead
  // of the FirebaseFirestore.instance the production provider uses.
  progressRepositoryProvider.overrideWith(
    (_) => ProgressRepository(firestore, clock: () => _now),
  ),
];

CollectionReference<Map<String, dynamic>> _summariesCollection(
  FakeFirebaseFirestore firestore,
) => firestore
    .collection(AppConstants.collectionUsers)
    .doc(_userId)
    .collection(AppConstants.collectionDailySummaries);

String _dateId(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}'
    '-${date.day.toString().padLeft(2, '0')}';

Future<void> _seedSummary(
  FakeFirebaseFirestore firestore,
  DateTime date,
  int co2Grams,
) async {
  await _summariesCollection(firestore).doc(_dateId(date)).set({
    'date': _dateId(date),
    'goalCount': 1,
    'completedSdgs': <int>[],
    'totalPoints': 0,
    'totalCo2Grams': co2Grams,
  });
}

final _now = DateTime(2026, 6, 17, 12);
final _clock = clockProvider.overrideWithValue(() => _now);

void main() {
  group('co2StatsProvider', () {
    test('returns zeros when user is null', () async {
      final firestore = FakeFirebaseFirestore();
      final c = await pumpedContainer(_overrides(firestore));

      final stats = await c.read(co2StatsProvider(TimePeriod.today).future);

      expect(stats.totalGrams, 0);
      expect(stats.previousTotalGrams, 0);
      expect(stats.percentChange, 0);
      expect(stats.period, TimePeriod.today);
      expect(stats.hasComparison, isFalse);
    });

    test("today sums today's daily summary", () async {
      final firestore = FakeFirebaseFirestore();
      await _seedSummary(firestore, _now, 1500);

      final c = await pumpedContainer(
        _overrides(firestore, const AppUserModel(uid: _userId, email: 'e')),
      );

      final stats = await c.read(co2StatsProvider(TimePeriod.today).future);

      expect(stats.totalGrams, 1500);
    });

    test("today comparison reads yesterday's total", () async {
      final firestore = FakeFirebaseFirestore();
      final now = _now;
      final yesterday = now.subtract(const Duration(days: 1));
      await _seedSummary(firestore, now, 2300);
      await _seedSummary(firestore, yesterday, 2000);

      final c = await pumpedContainer(
        _overrides(firestore, const AppUserModel(uid: _userId, email: 'e')),
      );

      final stats = await c.read(co2StatsProvider(TimePeriod.today).future);

      expect(stats.totalGrams, 2300);
      expect(stats.previousTotalGrams, 2000);
      // (2300 - 2000) / 2000 * 100 = 15
      expect(stats.percentChange, closeTo(15.0, 0.001));
      expect(stats.hasComparison, isTrue);
    });

    test('percentChange is 0 when previous total is 0', () async {
      final firestore = FakeFirebaseFirestore();
      await _seedSummary(firestore, _now, 500);

      final c = await pumpedContainer(
        _overrides(firestore, const AppUserModel(uid: _userId, email: 'e')),
      );

      final stats = await c.read(co2StatsProvider(TimePeriod.today).future);

      expect(stats.totalGrams, 500);
      expect(stats.previousTotalGrams, 0);
      expect(stats.percentChange, 0);
      expect(stats.hasComparison, isFalse);
    });

    test('thisWeek sums only the Monday-to-Sunday week', () async {
      final firestore = FakeFirebaseFirestore();
      final now = _now;
      final weekStart = DateTime(
        now.year,
        now.month,
        now.day - (now.weekday - 1),
      );
      await _seedSummary(firestore, now, 100);
      // Last week's Sunday and next week's Monday sit just outside.
      await _seedSummary(
        firestore,
        DateTime(weekStart.year, weekStart.month, weekStart.day - 1),
        200,
      );
      await _seedSummary(
        firestore,
        DateTime(weekStart.year, weekStart.month, weekStart.day + 7),
        500,
      );

      final c = await pumpedContainer(
        _overrides(firestore, const AppUserModel(uid: _userId, email: 'e')),
      );

      final stats = await c.read(co2StatsProvider(TimePeriod.thisWeek).future);

      expect(stats.totalGrams, 100);
      expect(stats.previousTotalGrams, 200);
    });

    test('allTime reads user.totalCo2Grams and has zero previous', () async {
      final firestore = FakeFirebaseFirestore();
      // Seed some summaries that should NOT be summed for allTime --
      // user.totalCo2Grams is the source of truth.
      await _seedSummary(firestore, _now, 999);

      final c = await pumpedContainer(
        _overrides(
          firestore,
          const AppUserModel(uid: _userId, email: 'e', totalCo2Grams: 42000),
        ),
      );

      final stats = await c.read(co2StatsProvider(TimePeriod.allTime).future);

      expect(stats.totalGrams, 42000);
      expect(stats.previousTotalGrams, 0);
      expect(stats.hasComparison, isFalse);
    });
  });

  test('a one-gram previous total still yields a percent change', () async {
    final firestore = FakeFirebaseFirestore();
    await _seedSummary(firestore, _now, 3);
    await _seedSummary(firestore, _now.subtract(const Duration(days: 1)), 1);
    final c = await pumpedContainer(
      _overrides(firestore, const AppUserModel(uid: _userId, email: 'e')),
    );

    final stats = await c.read(co2StatsProvider(TimePeriod.today).future);

    expect(stats.previousTotalGrams, 1);
    expect(stats.percentChange, 200);
    expect(stats.hasComparison, isTrue);
  });
}
