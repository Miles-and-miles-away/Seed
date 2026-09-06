import 'dart:async';

import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/data/repositories/action_log_repository.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';
import 'package:seed_app/features/progress/domain/entities/co2_chart_data.dart';
import 'package:seed_app/features/progress/domain/entities/co2_stats.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_chart_data_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_stats_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/services/analytics_service.dart';

import '../../../../helpers/test_helpers.dart';

class _MockRepository extends Mock implements ActionLogRepository {}

class _RecordingAnalytics extends Fake implements AnalyticsService {
  final loggedActionIds = <String>[];
  final milestoneDays = <int>[];

  @override
  Future<void> logActionLogged({
    required String actionId,
    required String category,
    required int points,
    required int co2Grams,
    required List<String> sdgs,
  }) async => loggedActionIds.add(actionId);

  @override
  Future<void> logStreakMilestone({required int days}) async =>
      milestoneDays.add(days);
}

const _action = ActionModel(
  id: 'walk',
  nameEn: 'Walk',
  nameJa: '歩く',
  category: 'transport',
  points: 20,
  co2Grams: 500,
  relatedSdgs: ['11'],
);

const _user = AppUserModel(uid: 'u1', email: 'e');

ActionLogResult _result({int? milestoneWeek}) => ActionLogResult(
  actionLog: ActionLogModel(
    id: 'log-1',
    actionId: 'walk',
    actionName: 'Walk',
    category: 'transport',
    points: 20,
    co2Grams: 500,
    loggedAt: DateTime(2026, 6),
  ),
  newStreakDays: 7,
  crossedMilestoneWeek: milestoneWeek,
);

void main() {
  late _MockRepository repo;
  late _RecordingAnalytics analytics;

  setUpAll(() => registerFallbackValue(_action));

  setUp(() {
    repo = _MockRepository();
    analytics = _RecordingAnalytics();
  });

  When<Future<ActionLogResult>> whenLog() => when(
    () => repo.logAction(
      userId: any(named: 'userId'),
      action: any(named: 'action'),
      languageCode: any(named: 'languageCode'),
      note: any(named: 'note'),
    ),
  );

  Future<ProviderContainer> container({
    AppUserModel? user = _user,
    List<Override> extra = const [],
  }) => pumpedContainer([
    userOverride(user),
    actionLogRepositoryProvider.overrideWith((_) async => repo),
    analyticsServiceProvider.overrideWithValue(analytics),
    ...extra,
  ]);

  group('ActionLogNotifier.logAction', () {
    test('logs through the repository for the signed-in user', () async {
      final result = _result();
      whenLog().thenAnswer((_) async => result);
      final c = await container();

      final returned = await c
          .read(actionLogProvider.notifier)
          .logAction(_action, note: 'with a bag', languageCode: 'ja');

      expect(returned, same(result));
      expect(c.read(actionLogProvider).value, same(result));
      verify(
        () => repo.logAction(
          userId: 'u1',
          action: _action,
          languageCode: 'ja',
          note: 'with a bag',
        ),
      ).called(1);
    });

    test('refreshes every chart and stats provider after a log', () async {
      whenLog().thenAnswer((_) async => _result());
      final builds = <String, int>{};
      void built(String name) => builds[name] = (builds[name] ?? 0) + 1;
      final c = await container(
        extra: [
          co2StatsProvider.overrideWith((ref, period) async {
            built('stats');
            return Co2Stats(
              totalGrams: 0,
              previousTotalGrams: 0,
              percentChange: 0,
              period: period,
            );
          }),
          co2TrendDataProvider.overrideWith((ref, period) async {
            built('trend');
            return Co2TrendData(
              points: const [],
              averageGrams: 0,
              windowStart: DateTime(2026, 6),
              windowEnd: DateTime(2026, 6, 8),
            );
          }),
          co2CategoryDataProvider.overrideWith((ref, period) async {
            built('category');
            return const Co2CategoryData(slices: [], totalGrams: 0);
          }),
          monthCalendarDataProvider.overrideWith((ref) async {
            built('calendar');
            return const <CalendarDayData>[];
          }),
        ],
      );
      c
        ..listen(co2StatsProvider(TimePeriod.today), (_, _) {})
        ..listen(co2TrendDataProvider(TimePeriod.today), (_, _) {})
        ..listen(co2CategoryDataProvider(TimePeriod.today), (_, _) {})
        ..listen(monthCalendarDataProvider, (_, _) {});
      await Future<void>.delayed(Duration.zero);
      expect(builds.values, everyElement(1));

      await c.read(actionLogProvider.notifier).logAction(_action);
      await Future<void>.delayed(Duration.zero);

      expect(builds, {'stats': 2, 'trend': 2, 'category': 2, 'calendar': 2});
    });

    test('reports the action and a crossed milestone to analytics', () async {
      whenLog().thenAnswer((_) async => _result(milestoneWeek: 1));
      final c = await container();

      await c.read(actionLogProvider.notifier).logAction(_action);
      await Future<void>.delayed(Duration.zero);

      expect(analytics.loggedActionIds, ['walk']);
      expect(analytics.milestoneDays, [7]);
    });

    test('does not report a milestone when none was crossed', () async {
      whenLog().thenAnswer((_) async => _result());
      final c = await container();

      await c.read(actionLogProvider.notifier).logAction(_action);
      await Future<void>.delayed(Duration.zero);

      expect(analytics.loggedActionIds, ['walk']);
      expect(analytics.milestoneDays, isEmpty);
    });

    test('signed out: returns null, errors, and never hits the repo', () async {
      final c = await container(user: null);

      final returned = await c
          .read(actionLogProvider.notifier)
          .logAction(_action);

      expect(returned, isNull);
      expect(c.read(actionLogProvider).hasError, isTrue);
      verifyNever(
        () => repo.logAction(
          userId: any(named: 'userId'),
          action: any(named: 'action'),
          languageCode: any(named: 'languageCode'),
          note: any(named: 'note'),
        ),
      );
    });

    test('a second call while the first is in flight is dropped', () async {
      final gate = Completer<ActionLogResult>();
      whenLog().thenAnswer((_) => gate.future);
      final c = await container();
      final notifier = c.read(actionLogProvider.notifier);

      final first = notifier.logAction(_action);
      await Future<void>.delayed(Duration.zero);
      expect(c.read(actionLogProvider).isLoading, isTrue);

      expect(await notifier.logAction(_action), isNull);

      gate.complete(_result());
      expect(await first, isNotNull);
      verify(
        () => repo.logAction(
          userId: any(named: 'userId'),
          action: any(named: 'action'),
          languageCode: any(named: 'languageCode'),
          note: any(named: 'note'),
        ),
      ).called(1);
    });

    test('a repository failure lands in state and skips analytics', () async {
      whenLog().thenThrow(
        FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
      );
      final c = await container();

      final returned = await c
          .read(actionLogProvider.notifier)
          .logAction(_action);
      await Future<void>.delayed(Duration.zero);

      expect(returned, isNull);
      final state = c.read(actionLogProvider);
      expect(state.hasError, isTrue);
      expect((state.error! as FirebaseException).code, 'permission-denied');
      expect(analytics.loggedActionIds, isEmpty);
    });

    test('can log again after a failure', () async {
      whenLog().thenThrow(Exception('offline'));
      final c = await container();
      final notifier = c.read(actionLogProvider.notifier);
      await notifier.logAction(_action);

      whenLog().thenAnswer((_) async => _result());
      expect(await notifier.logAction(_action), isNotNull);
    });
  });
}
