import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Creates a container with a mock user.
  ProviderContainer createContainer({
    List<String> viewedFactDates = const [],
    String challengeCompletedDate = '',
  }) {
    final user = AppUserModel(
      uid: 'test-uid',
      email: 'test@example.com',
      viewedFactDates: viewedFactDates,
      challengeCompletedDate: challengeCompletedDate,
    );

    final container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWith(
          (_) => Stream.value(user),
        ),
      ],
    )..listen(currentUserProvider, (_, __) {});

    return container;
  }

  group('isTodayFactViewedProvider', () {
    test('returns false when user has no viewed dates', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(isTodayFactViewedProvider);
      expect(result, isFalse);
    });

    test('returns true when today is in viewedFactDates', () async {
      final todayKey = formatDateKey(DateTime.now());
      final container = createContainer(
        viewedFactDates: [todayKey],
      );
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(isTodayFactViewedProvider);
      expect(result, isTrue);
    });

    test('returns false when only other dates are viewed', () async {
      final container = createContainer(
        viewedFactDates: ['2020-01-01'],
      );
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(isTodayFactViewedProvider);
      expect(result, isFalse);
    });
  });

  group('hasUnreadFactProvider', () {
    test('returns true when fact not viewed and challenge done', () async {
      final todayKey = formatDateKey(DateTime.now());
      final container = createContainer(
        challengeCompletedDate: todayKey,
      );
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(hasUnreadFactProvider);
      expect(result, isTrue);
    });

    test('returns false when fact viewed', () async {
      final todayKey = formatDateKey(DateTime.now());
      final container = createContainer(
        viewedFactDates: [todayKey],
      );
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(hasUnreadFactProvider);
      expect(result, isFalse);
    });
  });

  group('ecoFactsProvider', () {
    test('loads 366 facts', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final facts = await container.read(ecoFactsProvider.future);
      expect(facts.length, 366);
    });
  });

  group('todayEcoFactProvider', () {
    test('returns fact for today', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final fact = await container.read(todayEcoFactProvider.future);
      expect(fact, isNotNull);

      final expectedDay = dayOfYear(DateTime.now());
      expect(fact!.dayOfYear, expectedDay);
    });
  });

  group('FactCalendarSelectedMonth', () {
    test('initializes to current month', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final month = container.read(factCalendarSelectedMonthProvider);
      final now = DateTime.now();
      expect(month.year, now.year);
      expect(month.month, now.month);
    });

    test('goToPreviousMonth moves back', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final now = DateTime.now();
      container
          .read(factCalendarSelectedMonthProvider.notifier)
          .goToPreviousMonth();

      final month = container.read(factCalendarSelectedMonthProvider);
      final expected = DateTime(now.year, now.month - 1);
      expect(month.year, expected.year);
      expect(month.month, expected.month);
    });

    test('canGoToNextMonth is false for current month', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final canGoNext = container
          .read(factCalendarSelectedMonthProvider.notifier)
          .canGoToNextMonth;
      expect(canGoNext, isFalse);
    });

    test('canGoToNextMonth is true for past month', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(factCalendarSelectedMonthProvider.notifier)
          .goToPreviousMonth();

      final canGoNext = container
          .read(factCalendarSelectedMonthProvider.notifier)
          .canGoToNextMonth;
      expect(canGoNext, isTrue);
    });
  });
}
