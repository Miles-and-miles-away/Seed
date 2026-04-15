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
    List<String> unlockedFactDates = const [],
    String challengeCompletedDate = '',
  }) {
    final user = AppUserModel(
      uid: 'test-uid',
      email: 'test@example.com',
      viewedFactDates: viewedFactDates,
      unlockedFactDates: unlockedFactDates,
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

  group('ecoFactInboxProvider', () {
    test('includes today row when no viewed dates', () async {
      final container = createContainer()
        ..listen(ecoFactInboxProvider, (_, __) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      expect(items, hasLength(1));
      expect(items.first.dateKey, formatDateKey(DateTime.now()));
    });

    test('marks today as read when in viewedFactDates', () async {
      final todayKey = formatDateKey(DateTime.now());
      final container = createContainer(viewedFactDates: [todayKey])
        ..listen(ecoFactInboxProvider, (_, __) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      expect(items.first.isRead, isTrue);
    });

    test('past viewed dates appear after today, newest first', () async {
      final todayKey = formatDateKey(DateTime.now());
      final container = createContainer(
        viewedFactDates: [todayKey, '2026-01-05', '2026-02-10'],
        challengeCompletedDate: todayKey,
      )..listen(ecoFactInboxProvider, (_, __) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      expect(items, hasLength(3));
      expect(items[0].dateKey, todayKey);
      expect(items[1].dateKey, '2026-02-10');
      expect(items[2].dateKey, '2026-01-05');
      expect(items.skip(1).every((i) => i.isRead), isTrue);
    });

    test('today row is locked when challenge incomplete', () async {
      final container = createContainer()
        ..listen(ecoFactInboxProvider, (_, __) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      expect(items.first.isLocked, isTrue);
    });

    test('past unlocked-but-unviewed day surfaces as unread', () async {
      final todayKey = formatDateKey(DateTime.now());
      final container = createContainer(
        unlockedFactDates: [todayKey, '2026-02-10'],
        challengeCompletedDate: todayKey,
      )..listen(ecoFactInboxProvider, (_, __) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      expect(items, hasLength(2));
      final past = items.firstWhere((i) => i.dateKey == '2026-02-10');
      expect(past.isRead, isFalse);
      expect(past.isLocked, isFalse);
    });

    test('isRead reflects viewedFactDates independent of unlock set', () async {
      final todayKey = formatDateKey(DateTime.now());
      final container = createContainer(
        viewedFactDates: ['2026-01-05'],
        unlockedFactDates: [todayKey, '2026-01-05', '2026-02-10'],
        challengeCompletedDate: todayKey,
      )..listen(ecoFactInboxProvider, (_, __) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      final read = items.firstWhere((i) => i.dateKey == '2026-01-05');
      final unread = items.firstWhere((i) => i.dateKey == '2026-02-10');
      expect(read.isRead, isTrue);
      expect(unread.isRead, isFalse);
    });
  });
}
