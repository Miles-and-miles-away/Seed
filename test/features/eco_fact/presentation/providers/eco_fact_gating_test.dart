import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

final _now = DateTime(2026, 6, 17, 12);
final _clock = clockProvider.overrideWithValue(() => _now);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final todayKey = formatDateKey(_now);

  ProviderContainer createContainer({
    String challengeCompletedDate = '',
    List<String> viewedFactDates = const [],
  }) {
    final user = AppUserModel(
      uid: 'test-uid',
      email: 'test@example.com',
      challengeCompletedDate: challengeCompletedDate,
      viewedFactDates: viewedFactDates,
    );

    final container = ProviderContainer(
      overrides: [
        _clock,
        currentUserProvider.overrideWith((_) => Stream.value(user)),
      ],
    )..listen(currentUserProvider, (_, _) {});

    return container;
  }

  group('isEcoFactLockedProvider', () {
    test('returns true when challenge not completed', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(isEcoFactLockedProvider);
      expect(result, isTrue);
    });

    test('returns false when challenge completed', () async {
      final container = createContainer(challengeCompletedDate: todayKey);
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(isEcoFactLockedProvider);
      expect(result, isFalse);
    });
  });

  group('hasUnreadFactProvider (gated)', () {
    test('returns false when challenge not completed', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(hasUnreadFactProvider);
      expect(result, isFalse);
    });

    test('returns true when challenge completed and fact not viewed', () async {
      final container = createContainer(challengeCompletedDate: todayKey);
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(hasUnreadFactProvider);
      expect(result, isTrue);
    });

    test('returns false when challenge completed and fact viewed', () async {
      final container = createContainer(
        challengeCompletedDate: todayKey,
        viewedFactDates: [todayKey],
      );
      addTearDown(container.dispose);

      await Future<void>.delayed(Duration.zero);
      final result = container.read(hasUnreadFactProvider);
      expect(result, isFalse);
    });
  });
}
