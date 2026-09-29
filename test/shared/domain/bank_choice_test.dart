import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_choice_providers.dart';
import 'package:seed_app/shared/data/custom_action_repository.dart';
import 'package:seed_app/shared/models/custom_action_model.dart';
import 'package:seed_app/shared/providers/custom_action_providers.dart';

import '../../helpers/test_helpers.dart';

class _MockCustomActionRepository extends Mock
    implements CustomActionRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CustomAction(
        id: '',
        name: '',
        co2Grams: 0,
        points: 0,
        category: '',
        relatedSdgs: [],
      ),
    );
  });

  test('a template write that never answers times out as offline', () async {
    final repo = _MockCustomActionRepository();
    when(
      () => repo.create(any(), any()),
    ).thenAnswer((_) => Completer<CustomAction>().future);
    final container = await pumpedContainer([
      userIdProvider.overrideWith((_) => 'u'),
      customActionRepositoryProvider.overrideWithValue(repo),
    ], warm: userIdProvider);
    container.listen(transportChoiceLoggerProvider, (_, _) {});

    fakeAsync((async) {
      AsyncValue<void>? result;
      unawaited(
        container
            .read(transportChoiceLoggerProvider.notifier)
            .logChoice(name: 'Train over plane', co2Grams: 500)
            .then((r) => result = r),
      );
      async.elapse(const Duration(seconds: 6));

      expect(result?.error, isA<TimeoutException>());
      expect(container.read(transportChoiceLoggerProvider).hasError, isTrue);
    });
  });
}
