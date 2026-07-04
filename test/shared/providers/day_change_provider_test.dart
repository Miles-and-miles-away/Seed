import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/providers/day_change_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testUser = AppUserModel(
    uid: 'test-uid',
    email: 'test@example.com',
  );

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        currentUserProvider.overrideWith(
          (_) => Stream.value(testUser),
        ),
      ],
    );
  }

  group('DayChangeNotifier', () {
    test('build returns today date key', () {
      final container = createContainer();
      addTearDown(container.dispose);

      final result = container.read(dayChangeProvider);
      expect(result, formatDateKey(DateTime.now()));
    });

    test('checkDayChanged does nothing when same day', () {
      final container = createContainer();
      addTearDown(container.dispose);

      final before = container.read(dayChangeProvider);
      container.read(dayChangeProvider.notifier).checkDayChanged();
      final after = container.read(dayChangeProvider);

      expect(after, before);
    });
  });
}
