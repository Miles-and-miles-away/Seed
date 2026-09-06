import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

final _now = DateTime(2026, 6, 17, 12);
final _clock = clockProvider.overrideWithValue(() => _now);

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
        _clock,
        currentUserProvider.overrideWith((_) => Stream.value(user)),
      ],
    )..listen(currentUserProvider, (_, _) {});

    return container;
  }

  group('isTodayFactViewedProvider', () {
    test('returns false when signed out', () async {
      final container = ProviderContainer(
        overrides: [
          _clock,
          currentUserProvider.overrideWith((_) => Stream.value(null)),
        ],
      )..listen(currentUserProvider, (_, _) {});
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      expect(container.read(isTodayFactViewedProvider), isFalse);
    });

    test('returns false when user has no viewed dates', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(isTodayFactViewedProvider);
      expect(result, isFalse);
    });

    test('returns true when today is in viewedFactDates', () async {
      final todayKey = formatDateKey(_now);
      final container = createContainer(viewedFactDates: [todayKey]);
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(isTodayFactViewedProvider);
      expect(result, isTrue);
    });

    test('returns false when only other dates are viewed', () async {
      final container = createContainer(viewedFactDates: ['2020-01-01']);
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(isTodayFactViewedProvider);
      expect(result, isFalse);
    });
  });

  group('hasUnreadFactProvider', () {
    test('returns true when fact not viewed and challenge done', () async {
      final todayKey = formatDateKey(_now);
      final container = createContainer(challengeCompletedDate: todayKey);
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(hasUnreadFactProvider);
      expect(result, isTrue);
    });

    test('returns false when fact viewed', () async {
      final todayKey = formatDateKey(_now);
      final container = createContainer(viewedFactDates: [todayKey]);
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
      final container = ProviderContainer(overrides: [_clock]);
      addTearDown(container.dispose);

      final fact = await container.read(todayEcoFactProvider.future);
      expect(fact, isNotNull);

      final expectedDay = dayOfYear(_now);
      expect(fact!.dayOfYear, expectedDay);
    });
  });

  group('ecoFactInboxProvider', () {
    test('includes today row when no viewed dates', () async {
      final container = createContainer()
        ..listen(ecoFactInboxProvider, (_, _) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      expect(items, hasLength(1));
      expect(items.first.dateKey, formatDateKey(_now));
    });

    test('marks today as read when in viewedFactDates', () async {
      final todayKey = formatDateKey(_now);
      final container = createContainer(viewedFactDates: [todayKey])
        ..listen(ecoFactInboxProvider, (_, _) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      expect(items.first.isRead, isTrue);
    });

    test('past viewed dates appear after today, newest first', () async {
      final todayKey = formatDateKey(_now);
      final container = createContainer(
        viewedFactDates: [todayKey, '2026-01-05', '2026-02-10'],
        challengeCompletedDate: todayKey,
      )..listen(ecoFactInboxProvider, (_, _) {});
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
        ..listen(ecoFactInboxProvider, (_, _) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      expect(items.first.isLocked, isTrue);
    });

    test('past unlocked-but-unviewed day surfaces as unread', () async {
      final todayKey = formatDateKey(_now);
      final container = createContainer(
        unlockedFactDates: [todayKey, '2026-02-10'],
        challengeCompletedDate: todayKey,
      )..listen(ecoFactInboxProvider, (_, _) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      expect(items, hasLength(2));
      final past = items.firstWhere((i) => i.dateKey == '2026-02-10');
      expect(past.isRead, isFalse);
      expect(past.isLocked, isFalse);
    });

    test('isRead reflects viewedFactDates independent of unlock set', () async {
      final todayKey = formatDateKey(_now);
      final container = createContainer(
        viewedFactDates: ['2026-01-05'],
        unlockedFactDates: [todayKey, '2026-01-05', '2026-02-10'],
        challengeCompletedDate: todayKey,
      )..listen(ecoFactInboxProvider, (_, _) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);
      final read = items.firstWhere((i) => i.dateKey == '2026-01-05');
      final unread = items.firstWhere((i) => i.dateKey == '2026-02-10');
      expect(read.isRead, isTrue);
      expect(unread.isRead, isFalse);
    });
  });

  group('ecoFactInboxProvider locking', () {
    test('past unlocked facts stay readable while today is locked', () async {
      final todayKey = formatDateKey(_now);
      final container = createContainer(unlockedFactDates: ['2026-02-10'])
        ..listen(ecoFactInboxProvider, (_, _) {});
      addTearDown(container.dispose);

      final items = await container.read(ecoFactInboxProvider.future);

      expect(items.map((i) => i.dateKey), [todayKey, '2026-02-10']);
      expect(items.first.isLocked, isTrue);
      expect(items.last.isLocked, isFalse);
    });
  });

  group('FactViewedNotifier', () {
    late FakeFirebaseFirestore firestore;

    setUp(() async {
      firestore = FakeFirebaseFirestore();
      await firestore
          .collection(AppConstants.collectionUsers)
          .doc('test-uid')
          .set({
            'uid': 'test-uid',
            AppConstants.fieldViewedFactDates: ['2026-01-01'],
          });
    });

    Future<ProviderContainer> notifierContainer({bool signedIn = true}) async {
      final user = signedIn
          ? const AppUserModel(
              uid: 'test-uid',
              email: 'e',
              viewedFactDates: ['2026-01-01'],
            )
          : null;
      final container = ProviderContainer(
        overrides: [
          _clock,
          currentUserProvider.overrideWith((_) => Stream.value(user)),
          firestoreProvider.overrideWithValue(firestore),
        ],
      )..listen(currentUserProvider, (_, _) {});
      addTearDown(container.dispose);
      await Future<void>.delayed(Duration.zero);
      return container;
    }

    Future<List<dynamic>> storedViewed() async =>
        (await firestore
                    .collection(AppConstants.collectionUsers)
                    .doc('test-uid')
                    .get())
                .data()![AppConstants.fieldViewedFactDates]
            as List<dynamic>;

    test('markDateViewed appends the date', () async {
      final container = await notifierContainer();

      await container
          .read(factViewedProvider.notifier)
          .markDateViewed('2026-02-02');

      expect(await storedViewed(), ['2026-01-01', '2026-02-02']);
      expect(container.read(factViewedProvider).hasValue, isTrue);
    });

    test('markDateViewed is a no-op for an already viewed date', () async {
      final container = await notifierContainer();
      var stateChanges = 0;
      container.listen(factViewedProvider, (_, _) => stateChanges++);

      await container
          .read(factViewedProvider.notifier)
          .markDateViewed('2026-01-01');

      expect(await storedViewed(), ['2026-01-01']);
      expect(stateChanges, 0);
    });

    test('markDateViewed does nothing when signed out', () async {
      final container = await notifierContainer(signedIn: false);

      await container
          .read(factViewedProvider.notifier)
          .markDateViewed('2026-02-02');

      expect(await storedViewed(), ['2026-01-01']);
    });
  });
}
