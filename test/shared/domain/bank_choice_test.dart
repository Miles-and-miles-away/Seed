import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/log_error_message.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/transport/presentation/providers/transport_choice_providers.dart';
import 'package:seed_app/shared/data/custom_action_repository.dart';
import 'package:seed_app/shared/domain/bank_choice.dart';
import 'package:seed_app/shared/models/custom_action_model.dart';
import 'package:seed_app/shared/providers/custom_action_providers.dart';

import '../../helpers/test_helpers.dart';

class _MockCustomActionRepository extends Mock
    implements CustomActionRepository {}

class _FailingActionLog extends ActionLogNotifier {
  _FailingActionLog(this.error);

  final Object error;
  final calls = <ActionModel>[];
  final uniqueKeys = <String?>[];

  @override
  Future<ActionLogResult?> logAction(
    ActionModel action, {
    String? note,
    String languageCode = 'en',
    bool countsAsUnique = true,
    String? uniqueKey,
  }) async {
    calls.add(action);
    uniqueKeys.add(countsAsUnique ? uniqueKey : null);
    state = AsyncValue.error(error, StackTrace.current);
    return null;
  }
}

const _template = CustomAction(
  id: 'tpl-1',
  name: 'Train over plane',
  co2Grams: 500,
  points: 12,
  category: 'transport',
  relatedSdgs: ['13'],
);

Future<ProviderContainer> _bankContainer(
  CustomActionRepository repo,
  ActionLogNotifier log,
) => pumpedContainer([
  userIdProvider.overrideWith((_) => 'u'),
  customActionRepositoryProvider.overrideWithValue(repo),
  actionLogProvider.overrideWith(() => log),
], warm: userIdProvider);

Future<AsyncValue<void>?> _bank(ProviderContainer container) => container
    .read(transportChoiceLoggerProvider.notifier)
    .logChoice(
      name: 'Train over plane',
      co2Grams: 500,
      chosenIds: const ['train'],
      baselineIds: const ['plane'],
    );

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
            .logChoice(
              name: 'Train over plane',
              co2Grams: 500,
              chosenIds: const ['train'],
              baselineIds: const ['plane'],
            )
            .then((r) => result = r),
      );
      async.elapse(const Duration(seconds: 6));

      expect(result?.error, isA<TimeoutException>());
      expect(container.read(transportChoiceLoggerProvider).hasError, isTrue);
    });
  });

  test('a saving above the rules cap is refused before any write', () async {
    final repo = _MockCustomActionRepository();
    final log = _FailingActionLog(StateError('unused'));
    final container = await _bankContainer(repo, log);
    container.listen(transportChoiceLoggerProvider, (_, _) {});

    final result = await container
        .read(transportChoiceLoggerProvider.notifier)
        .logChoice(
          name: 'Train over private jet',
          co2Grams: AppConstants.maxBankCo2Grams + 1,
          chosenIds: const ['train'],
          baselineIds: const ['private_jet'],
        );

    expect(result?.error, isA<SavingTooLargeException>());
    verifyNever(() => repo.create(any(), any()));
    expect(log.calls, isEmpty);
  });

  test('a name above the rules cap is shortened, not denied', () async {
    final repo = _MockCustomActionRepository();
    when(() => repo.create(any(), any())).thenAnswer((_) async => _template);
    final container = await _bankContainer(
      repo,
      _FailingActionLog(Exception('rejected')),
    );
    container.listen(transportChoiceLoggerProvider, (_, _) {});

    await container
        .read(transportChoiceLoggerProvider.notifier)
        .logChoice(
          name: '${'a' * 498}\u{1F96C}${'b' * 10}',
          co2Grams: 500,
          chosenIds: const ['train'],
          baselineIds: const ['plane'],
        );

    final saved =
        verify(() => repo.create(any(), captureAny())).captured.single
            as CustomAction;
    expect(saved.name, '${'a' * 498}\u2026');
  });

  test('leaving during the template write still logs the action', () async {
    final repo = _MockCustomActionRepository();
    final create = Completer<CustomAction>();
    when(() => repo.create(any(), any())).thenAnswer((_) => create.future);
    final log = _FailingActionLog(Exception('rejected'));
    final container = await _bankContainer(repo, log);
    final screen = container.listen(transportChoiceLoggerProvider, (_, _) {});

    final pending = _bank(container);
    screen.close();
    await container.pump();
    create.complete(_template);
    await pending;

    expect(log.calls, hasLength(1));
  });

  test('an offline log failure surfaces as an offline error', () async {
    final repo = _MockCustomActionRepository();
    when(() => repo.create(any(), any())).thenAnswer((_) async => _template);
    final container = await _bankContainer(
      repo,
      _FailingActionLog(TimeoutException('offline')),
    );

    final result = await _bank(container);

    expect(isOfflineError(result?.error), isTrue);
  });

  test('a rules rejection surfaces as permission-denied', () async {
    final repo = _MockCustomActionRepository();
    when(() => repo.create(any(), any())).thenAnswer((_) async => _template);
    final container = await _bankContainer(
      repo,
      _FailingActionLog(
        FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
      ),
    );

    final result = await _bank(container);

    expect(
      result?.error,
      isA<FirebaseException>().having(
        (e) => e.code,
        'code',
        'permission-denied',
      ),
    );
  });

  test('a banked action counts once per kind of choice', () async {
    final repo = _MockCustomActionRepository();
    when(() => repo.create(any(), any())).thenAnswer((_) async => _template);
    final log = _FailingActionLog(Exception('rejected'));
    final container = await _bankContainer(repo, log);

    await _bank(container);

    expect(log.uniqueKeys, ['bank:transport:train>plane']);
  });

  test('the bank key ignores order and repeats of ids', () {
    expect(
      bankUniqueKey('food', ['b', 'a', 'b'], ['c']),
      bankUniqueKey('food', ['a', 'b'], ['c']),
    );
    expect(
      bankUniqueKey('food', ['a'], ['c']),
      isNot(bankUniqueKey('transport', ['a'], ['c'])),
    );
  });
}
