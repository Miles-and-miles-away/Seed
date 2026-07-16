import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';

ProviderContainer _containerWithUser(AppUserModel? user) {
  return ProviderContainer(
    overrides: [currentUserProvider.overrideWith((_) => Stream.value(user))],
  );
}

Future<void> _pump(ProviderContainer c) async {
  c.listen(currentUserProvider, (_, _) {});
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('dailyGoalTargetProvider', () {
    test('returns null when user is null', () async {
      final c = _containerWithUser(null);
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(dailyGoalTargetProvider), isNull);
    });

    test('returns null when user has no target set', () async {
      final c = _containerWithUser(const AppUserModel(uid: 'u', email: 'e'));
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(dailyGoalTargetProvider), isNull);
    });

    test('returns the target when user has one', () async {
      final c = _containerWithUser(
        const AppUserModel(uid: 'u', email: 'e', dailyGoalTarget: 5),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(dailyGoalTargetProvider), 5);
    });
  });

  group('needsDailyTargetSetupProvider', () {
    test('returns false when no user', () async {
      final c = _containerWithUser(null);
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(needsDailyTargetSetupProvider), isFalse);
    });

    test('returns true when user has no target', () async {
      final c = _containerWithUser(const AppUserModel(uid: 'u', email: 'e'));
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(needsDailyTargetSetupProvider), isTrue);
    });

    test('returns false when user has a target', () async {
      final c = _containerWithUser(
        const AppUserModel(uid: 'u', email: 'e', dailyGoalTarget: 3),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(c.read(needsDailyTargetSetupProvider), isFalse);
    });
  });

  group('SelectedMonth notifier', () {
    test('defaults to the first day of the current month', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      final state = c.read(selectedMonthProvider);
      final now = DateTime.now();
      expect(state.year, now.year);
      expect(state.month, now.month);
      expect(state.day, 1);
    });

    test('goToPreviousMonth wraps across year boundary', () {
      final c = ProviderContainer();
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
      final c = ProviderContainer();
      addTearDown(c.dispose);

      final notifier = c.read(selectedMonthProvider.notifier);
      final now = DateTime.now();
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
      final c = ProviderContainer();
      addTearDown(c.dispose);

      final notifier = c.read(selectedMonthProvider.notifier);
      final now = DateTime.now();

      notifier.state = DateTime(now.year, now.month);
      expect(notifier.canGoToNextMonth, isFalse);

      // Two months ago.
      notifier.state = DateTime(now.year, now.month - 2);
      expect(notifier.canGoToNextMonth, isTrue);
    });
  });
}
