import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/progress/data/repositories/progress_repository.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_stats_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';

const _userId = 'test-user';

ProviderContainer _container({
  required FakeFirebaseFirestore firestore,
  AppUserModel? user,
}) {
  return ProviderContainer(
    overrides: [
      currentUserProvider.overrideWith((_) => Stream.value(user)),
      // The stats provider keys on the user id, not the whole doc.
      userIdProvider.overrideWithValue(user?.uid),
      // Replace the repository so it reads from fake firestore instead
      // of the FirebaseFirestore.instance the production provider uses.
      progressRepositoryProvider.overrideWith(
        (_) => ProgressRepository(firestore),
      ),
    ],
  );
}

Future<void> _pump(ProviderContainer c) async {
  c.listen(currentUserProvider, (_, _) {});
  await Future<void>.delayed(Duration.zero);
}

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

void main() {
  group('co2StatsProvider', () {
    test('returns zeros when user is null', () async {
      final firestore = FakeFirebaseFirestore();
      final c = _container(firestore: firestore);
      addTearDown(c.dispose);
      await _pump(c);

      final stats = await c.read(co2StatsProvider(TimePeriod.today).future);

      expect(stats.totalGrams, 0);
      expect(stats.previousTotalGrams, 0);
      expect(stats.percentChange, 0);
      expect(stats.period, TimePeriod.today);
      expect(stats.hasComparison, isFalse);
    });

    test("today sums today's daily summary", () async {
      final firestore = FakeFirebaseFirestore();
      await _seedSummary(firestore, DateTime.now(), 1500);

      final c = _container(
        firestore: firestore,
        user: const AppUserModel(uid: _userId, email: 'e'),
      );
      addTearDown(c.dispose);
      await _pump(c);

      final stats = await c.read(co2StatsProvider(TimePeriod.today).future);

      expect(stats.totalGrams, 1500);
    });

    test("today comparison reads yesterday's total", () async {
      final firestore = FakeFirebaseFirestore();
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      await _seedSummary(firestore, now, 2300);
      await _seedSummary(firestore, yesterday, 2000);

      final c = _container(
        firestore: firestore,
        user: const AppUserModel(uid: _userId, email: 'e'),
      );
      addTearDown(c.dispose);
      await _pump(c);

      final stats = await c.read(co2StatsProvider(TimePeriod.today).future);

      expect(stats.totalGrams, 2300);
      expect(stats.previousTotalGrams, 2000);
      // (2300 - 2000) / 2000 * 100 = 15
      expect(stats.percentChange, closeTo(15.0, 0.001));
      expect(stats.hasComparison, isTrue);
    });

    test('percentChange is 0 when previous total is 0', () async {
      final firestore = FakeFirebaseFirestore();
      await _seedSummary(firestore, DateTime.now(), 500);

      final c = _container(
        firestore: firestore,
        user: const AppUserModel(uid: _userId, email: 'e'),
      );
      addTearDown(c.dispose);
      await _pump(c);

      final stats = await c.read(co2StatsProvider(TimePeriod.today).future);

      expect(stats.totalGrams, 500);
      expect(stats.previousTotalGrams, 0);
      expect(stats.percentChange, 0);
      expect(stats.hasComparison, isFalse);
    });

    test('thisWeek sums daily summaries across the current week', () async {
      final firestore = FakeFirebaseFirestore();
      final now = DateTime.now();
      // Seed today and a few days back to land within the current
      // Mon-Sun week regardless of which day "today" is.
      await _seedSummary(firestore, now, 100);
      await _seedSummary(firestore, now.subtract(const Duration(days: 1)), 200);

      final c = _container(
        firestore: firestore,
        user: const AppUserModel(uid: _userId, email: 'e'),
      );
      addTearDown(c.dispose);
      await _pump(c);

      final stats = await c.read(co2StatsProvider(TimePeriod.thisWeek).future);

      // Both seeded days could fall within this week or one in last week
      // depending on weekday. The total is at least 100 (today) and at
      // most 300 (today + yesterday).
      expect(stats.totalGrams, anyOf(100, 300));
    });

    test('allTime reads user.totalCo2Grams and has zero previous', () async {
      final firestore = FakeFirebaseFirestore();
      // Seed some summaries that should NOT be summed for allTime --
      // user.totalCo2Grams is the source of truth.
      await _seedSummary(firestore, DateTime.now(), 999);

      final c = _container(
        firestore: firestore,
        user: const AppUserModel(
          uid: _userId,
          email: 'e',
          totalCo2Grams: 42000,
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      final stats = await c.read(co2StatsProvider(TimePeriod.allTime).future);

      expect(stats.totalGrams, 42000);
      expect(stats.previousTotalGrams, 0);
      expect(stats.hasComparison, isFalse);
    });
  });
}
