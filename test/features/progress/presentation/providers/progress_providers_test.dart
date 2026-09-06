import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/progress/data/repositories/progress_repository.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

import '../../../../helpers/test_helpers.dart';

class _MockProgressRepository extends Mock implements ProgressRepository {}

final _now = DateTime(2026, 6, 17, 12);
final _clock = clockProvider.overrideWithValue(() => _now);

void main() {
  group('dailyGoalTargetProvider', () {
    test('returns null when user is null', () async {
      final c = await pumpedContainer([_clock, userOverride(null)]);

      expect(c.read(dailyGoalTargetProvider), isNull);
    });

    test('returns null when user has no target set', () async {
      final c = await pumpedContainer([
        _clock,
        userOverride(const AppUserModel(uid: 'u', email: 'e')),
      ]);

      expect(c.read(dailyGoalTargetProvider), isNull);
    });

    test('returns the target when user has one', () async {
      final c = await pumpedContainer([
        _clock,
        userOverride(
          const AppUserModel(uid: 'u', email: 'e', dailyGoalTarget: 5),
        ),
      ]);

      expect(c.read(dailyGoalTargetProvider), 5);
    });
  });

  group('needsDailyTargetSetupProvider', () {
    test('returns false when no user', () async {
      final c = await pumpedContainer([_clock, userOverride(null)]);

      expect(c.read(needsDailyTargetSetupProvider), isFalse);
    });

    test('returns true when user has no target', () async {
      final c = await pumpedContainer([
        _clock,
        userOverride(const AppUserModel(uid: 'u', email: 'e')),
      ]);

      expect(c.read(needsDailyTargetSetupProvider), isTrue);
    });

    test('returns false when user has a target', () async {
      final c = await pumpedContainer([
        _clock,
        userOverride(
          const AppUserModel(uid: 'u', email: 'e', dailyGoalTarget: 3),
        ),
      ]);

      expect(c.read(needsDailyTargetSetupProvider), isFalse);
    });
  });

  group('SelectedMonth notifier', () {
    test('defaults to the first day of the current month', () {
      final c = ProviderContainer(overrides: [_clock]);
      addTearDown(c.dispose);

      final state = c.read(selectedMonthProvider);
      final now = _now;
      expect(state.year, now.year);
      expect(state.month, now.month);
      expect(state.day, 1);
    });

    test('goToPreviousMonth wraps across year boundary', () {
      final c = ProviderContainer(overrides: [_clock]);
      addTearDown(c.dispose);

      // Force to Jan to exercise the December wrap.
      c.read(selectedMonthProvider.notifier)
        ..state = DateTime(2026)
        ..goToPreviousMonth();

      final state = c.read(selectedMonthProvider);
      expect(state.year, 2025);
      expect(state.month, 12);
    });

    test('goToNextMonth stops at the current month', () {
      final c = ProviderContainer(overrides: [_clock]);
      addTearDown(c.dispose);

      final notifier = c.read(selectedMonthProvider.notifier);
      final now = _now;
      // Start at current month.
      notifier
        ..state = DateTime(now.year, now.month)
        ..goToNextMonth();

      // Cannot advance past the current month.
      final state = c.read(selectedMonthProvider);
      expect(state.month, now.month);
      expect(state.year, now.year);
    });

    test('canGoToNextMonth is false at current month, true in the past', () {
      final c = ProviderContainer(overrides: [_clock]);
      addTearDown(c.dispose);

      final notifier = c.read(selectedMonthProvider.notifier);
      final now = _now;

      notifier.state = DateTime(now.year, now.month);
      expect(notifier.canGoToNextMonth, isFalse);

      // Two months ago.
      notifier.state = DateTime(now.year, now.month - 2);
      expect(notifier.canGoToNextMonth, isTrue);
    });
  });

  group('SelectedMonth notifier (behind today)', () {
    test('goToNextMonth advances one month at a time up to today', () {
      final c = ProviderContainer(overrides: [_clock]);
      addTearDown(c.dispose);
      final now = _now;

      final notifier = c.read(selectedMonthProvider.notifier)
        ..state = DateTime(now.year, now.month - 2)
        ..goToNextMonth();
      expect(c.read(selectedMonthProvider), DateTime(now.year, now.month - 1));

      notifier.goToNextMonth();
      expect(c.read(selectedMonthProvider), DateTime(now.year, now.month));
    });
  });

  group('monthCalendarDataProvider', () {
    Future<ProviderContainer> containerWith(
      AppUserModel user,
      _MockProgressRepository repo,
    ) => pumpedContainer([
      _clock,
      userOverride(user),
      userIdProvider.overrideWithValue(user.uid),
      progressRepositoryProvider.overrideWith((_) => repo),
    ]);

    void stubCalendar(_MockProgressRepository repo) => when(
      () => repo.getMonthCalendarData(
        userId: any(named: 'userId'),
        year: any(named: 'year'),
        month: any(named: 'month'),
        goalTarget: any(named: 'goalTarget'),
      ),
    ).thenAnswer((_) async => const []);

    test('defaults the goal target to 3 when the user has none', () async {
      final repo = _MockProgressRepository();
      stubCalendar(repo);
      final c = await containerWith(
        const AppUserModel(uid: 'u', email: 'e'),
        repo,
      );

      await c.read(monthCalendarDataProvider.future);

      final now = _now;
      verify(
        () => repo.getMonthCalendarData(
          userId: 'u',
          year: now.year,
          month: now.month,
          goalTarget: 3,
        ),
      ).called(1);
    });

    test('passes the user goal target and the selected month', () async {
      final repo = _MockProgressRepository();
      stubCalendar(repo);
      final c = await containerWith(
        const AppUserModel(uid: 'u', email: 'e', dailyGoalTarget: 5),
        repo,
      );
      c.listen(selectedMonthProvider, (_, _) {});
      c.read(selectedMonthProvider.notifier).state = DateTime(2025, 2);

      await c.read(monthCalendarDataProvider.future);

      verify(
        () => repo.getMonthCalendarData(
          userId: 'u',
          year: 2025,
          month: 2,
          goalTarget: 5,
        ),
      ).called(1);
    });
  });

  group('DailyTargetNotifier', () {
    test('saveTarget writes dailyGoalTarget for the signed-in user', () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection(AppConstants.collectionUsers).doc('u').set({
        'uid': 'u',
      });
      final c = await pumpedContainer([
        _clock,
        userOverride(const AppUserModel(uid: 'u', email: 'e')),
        progressRepositoryProvider.overrideWith(
          (_) => ProgressRepository(firestore),
        ),
      ]);

      await c.read(dailyTargetProvider.notifier).saveTarget(4);

      final doc = await firestore
          .collection(AppConstants.collectionUsers)
          .doc('u')
          .get();
      expect(doc.data()![AppConstants.fieldDailyGoalTarget], 4);
      expect(c.read(dailyTargetProvider).hasValue, isTrue);
    });

    test('saveTarget errors when signed out', () async {
      final firestore = FakeFirebaseFirestore();
      final c = await pumpedContainer([
        _clock,
        userOverride(null),
        progressRepositoryProvider.overrideWith(
          (_) => ProgressRepository(firestore),
        ),
      ]);

      await c.read(dailyTargetProvider.notifier).saveTarget(4);

      expect(c.read(dailyTargetProvider).hasError, isTrue);
    });
  });
}
