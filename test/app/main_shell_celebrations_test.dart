import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/app/main_shell.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/actions.dart';
import 'package:seed_app/features/actions/presentation/utils/handle_action_tap.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/data/challenge_templates_data.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/features/eco_dex/eco_dex.dart';
import 'package:seed_app/features/mascot/mascot.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/streak_milestone_dialog.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/services/analytics_service.dart';

import '../features/eco_dex/eco_dex_fixtures.dart';
import '../features/walkthrough/walkthrough_test_support.dart';
import '../helpers/test_helpers.dart';

const _svg = 'assets/images/mascot/seed_stage1.svg';
const _uid = 'test-uid';

// Loaded outside fake async: a second in-test asset load never completes.
late final ChallengeTemplateData _templates;

class _Analytics implements AnalyticsService {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

class _FakeCrashlytics extends Fake implements FirebaseCrashlytics {
  @override
  Future<void> setCustomKey(String key, Object value) async {}
}

class _FakeDiscovery extends EcoDexDiscoveryNotifier {
  List<String> newIds = const [];

  @override
  Future<({List<String> unlocked, List<String> claimed})> discoverNewEntries({
    int? minActionsCount,
  }) async {
    final ids = newIds;
    newIds = const [];
    return (unlocked: ids, claimed: ids);
  }
}

const _stages = [
  EvolutionStageModel(level: 1, assetPath: _svg, nameEn: '1', nameJa: '1'),
  EvolutionStageModel(level: 10, assetPath: _svg, nameEn: '2', nameJa: '2'),
  EvolutionStageModel(level: 25, assetPath: _svg, nameEn: '3', nameJa: '3'),
  EvolutionStageModel(level: 50, assetPath: _svg, nameEn: '4', nameJa: '4'),
];

MascotSpeciesModel _species(String id) => MascotSpeciesModel(
  id: id,
  nameEn: id,
  nameJa: id,
  descriptionEn: '',
  descriptionJa: '',
  evolutionStages: _stages,
);

const _walk = ActionModel(
  id: 'walk',
  nameEn: 'Walk instead of drive',
  nameJa: 'walk',
  category: 'transport',
  points: 20,
  co2Grams: 500,
  relatedSdgs: ['11', '13'],
);

MockFirebaseAuth _auth(User? user) {
  final auth = MockFirebaseAuth();
  when(() => auth.currentUser).thenReturn(user);
  when(auth.userChanges).thenAnswer((_) => Stream.value(user));
  return auth;
}

class _RouterApp extends ConsumerWidget {
  const _RouterApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    routerConfig: ref.watch(routerProvider),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

/// A user one point short of level 25 (stage 3) with stage 2 seen.
Map<String, dynamic> _userDoc({
  int level = 24,
  int? points,
  int lastSeenStage = 2,
  Map<String, dynamic> extra = const {},
}) => {
  'uid': _uid,
  'email': 'e',
  AppConstants.fieldActiveMascotId: 'm1',
  AppConstants.fieldMascots: [
    {
      AppConstants.fieldId: 'm1',
      AppConstants.fieldSpeciesId: 'seed',
      AppConstants.fieldName: 'Pip',
      AppConstants.fieldMascotPoints: points ?? calculatePointsForLevel(25) - 1,
      AppConstants.fieldMascotLevel: level,
      AppConstants.fieldIsFullyEvolved: false,
      'equippedItems': <String>[],
      AppConstants.fieldLastSeenStage: lastSeenStage,
    },
  ],
  ...extra,
};

Future<FakeFirebaseFirestore> _store(Map<String, dynamic> doc) async {
  final fs = FakeFirebaseFirestore();
  await fs.collection(AppConstants.collectionUsers).doc(_uid).set(doc);
  return fs;
}

Future<void> _pumpApp(
  WidgetTester tester,
  FakeFirebaseFirestore fs, {
  Set<int> seenWeeks = const {},
  _FakeDiscovery? discovery,
  bool challengeLog = false,
  Widget app = const _RouterApp(),
}) async {
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final settings = settingsWith(
    WalkthroughItem.values,
  ).copyWith(seenStreakMilestones: {for (final w in seenWeeks) '$w': true});
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        languageStoreOverride(),
        crashlyticsProvider.overrideWithValue(_FakeCrashlytics()),
        firebaseAuthProvider.overrideWithValue(_auth(createMockUser())),
        firestoreProvider.overrideWithValue(fs),
        analyticsServiceProvider.overrideWithValue(_Analytics()),
        mascotSpeciesDataProvider.overrideWith(
          (_) async => [_species('seed'), _species('leaf')],
        ),
        userSettingsProvider.overrideWith((_) => Stream.value(settings)),
        // The real notifier, so the shell and the tap handler share claims.
        if (challengeLog)
          actionLogProvider.overrideWith(_ChallengeLog.new)
        else
          ecoDexDiscoveryProvider.overrideWith(
            () => discovery ?? _FakeDiscovery(),
          ),
        ecoDexDataProvider.overrideWith(
          (_) async => ecoDexDataFor([ecoDexEntry('forests_01')]),
        ),
        ecoDexAvailableIconsProvider.overrideWith((_) async => <String>{}),
        challengeTemplateDataProvider.overrideWith((_) async => _templates),
      ],
      child: app,
    ),
  );
  await _settle(tester);
  if (app is _RouterApp) expect(find.byType(MainShell), findsOneWidget);
}

/// Pumps fixed steps; the celebrations animate forever, so no settle.
Future<void> _settle(WidgetTester tester, [int steps = 10]) async {
  for (var i = 0; i < steps; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

ProviderContainer _container(WidgetTester tester) => ProviderScope.containerOf(
  tester.element(find.byType(MaterialApp)),
  listen: false,
);

/// Logs [_walk] through the real repository against the fake store.
Future<void> _log(WidgetTester tester) async {
  // The notifier's futures live in the fake zone, so runAsync never resumes.
  var done = false;
  unawaited(
    _container(tester)
        .read(actionLogProvider.notifier)
        .logAction(_walk)
        .whenComplete(() => done = true),
  );
  for (var i = 0; i < 100 && !done; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(done, isTrue, reason: 'logAction did not complete');
  await _settle(tester, 40);
}

/// The real notifier, with every log marked as completing the challenge.
class _ChallengeLog extends ActionLogNotifier {
  @override
  Future<ActionLogResult?> logAction(
    ActionModel action, {
    String? note,
    String languageCode = 'en',
  }) async {
    final r = await super.logAction(
      action,
      note: note,
      languageCode: languageCode,
    );
    if (r == null) return null;
    return ActionLogResult(
      actionLog: r.actionLog,
      newStreakDays: r.newStreakDays,
      crossedMilestoneWeek: r.crossedMilestoneWeek,
      hatchedMascotId: r.hatchedMascotId,
      challengeCompleted: true,
      newTotalActionsCount: r.newTotalActionsCount,
      newGoalCount: r.newGoalCount,
    );
  }
}

/// Logs [_walk] through handleActionTap on the action log route, then
/// expects [celebration] to hold the inbox back until it closes.
Future<void> _expectInboxWaitsFor(
  WidgetTester tester,
  Finder celebration,
) async {
  final router = _container(tester).read(routerProvider);
  unawaited(router.push(appRoutes.actionLog));
  await _settle(tester);
  final screen = tester.state<ConsumerState<ActionLogScreen>>(
    find.byType(ActionLogScreen),
  );
  unawaited(
    handleActionTap(
      screen.context,
      screen.ref,
      action: _walk,
      languageCode: 'en',
    ),
  );
  await _settle(tester, 5);
  await tester.tap(find.text('Confirm'));
  // Device-sized frames: at coarser steps the handler claims the Eco-Dex
  // entries before the shell does, and then waits by itself.
  for (var i = 0; i < 600; i++) {
    await tester.pump(const Duration(milliseconds: 10));
  }

  expect(celebration, findsOneWidget);
  expect(router.state.uri.path, appRoutes.actionLog);

  await _popTop(tester);
  await _settle(tester, 20);
  expect(router.state.uri.path, appRoutes.dailyFact);
}

Future<void> _popTop(WidgetTester tester) async {
  tester.state<NavigatorState>(find.byType(Navigator).first).pop();
  await _settle(tester, 5);
}

Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await _settle(tester, 50);
}

DateTime get _yesterday => DateTime.now().subtract(const Duration(days: 1));

void main() {
  setUpAll(() async => _templates = await loadChallengeTemplates());

  testWidgets('a level-up log shows evolution, then egg discovery', (
    tester,
  ) async {
    await _pumpApp(tester, await _store(_userDoc()));

    await _log(tester);

    expect(find.byType(EvolutionCelebration), findsOneWidget);
    expect(find.byType(EggDiscoveryCelebration), findsNothing);

    await _popTop(tester);

    expect(find.byType(EvolutionCelebration), findsNothing);
    expect(find.byType(EggDiscoveryCelebration), findsOneWidget);

    await _popTop(tester);
    await _unmount(tester);
  });

  testWidgets('a second evolution in one session shows again', (tester) async {
    final fs = await _store(_userDoc());
    await _pumpApp(tester, fs);

    await _log(tester);
    expect(find.byType(EvolutionCelebration), findsOneWidget);
    await _popTop(tester);
    await _popTop(tester);
    expect(find.byType(EvolutionCelebration), findsNothing);

    await tester.runAsync(
      () => fs
          .collection(AppConstants.collectionUsers)
          .doc(_uid)
          .update(
            _userDoc(
              level: 50,
              points: calculatePointsForLevel(50),
              lastSeenStage: 3,
            ),
          ),
    );
    await _settle(tester, 20);

    expect(find.byType(EvolutionCelebration), findsOneWidget);
    await _popTop(tester);
    await _unmount(tester);
  });

  testWidgets('evolution and egg discovery pending at mount both show', (
    tester,
  ) async {
    final doc = _userDoc(
      level: 25,
      points: calculatePointsForLevel(25),
      extra: {AppConstants.fieldEggPendingDiscovery: true},
    );
    final fs = await _store(doc);
    await _pumpApp(tester, fs);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MainShell)),
    );
    final evolution = container.listen(hasNewEvolutionProvider, (_, _) {});
    final egg = container.listen(shouldShowEggDiscoveryProvider, (_, _) {});
    addTearDown(evolution.close);
    addTearDown(egg.close);

    // A shell that mounts after the user stream has loaded, as on a
    // route rebuild, must still see the pending state.
    await _pumpApp(tester, fs, app: const SizedBox());
    await _pumpApp(tester, fs);

    expect(find.byType(EvolutionCelebration), findsOneWidget);
    await _popTop(tester);
    expect(find.byType(EggDiscoveryCelebration), findsOneWidget);

    await _popTop(tester);
    await _unmount(tester);
  });

  testWidgets('a day-30 egg log shows the hatching celebration', (
    tester,
  ) async {
    final doc = _userDoc(
      level: 30,
      points: calculatePointsForLevel(30),
      lastSeenStage: 3,
      extra: {
        AppConstants.fieldEgg: {
          'receivedAt': Timestamp.fromDate(
            _yesterday.subtract(const Duration(days: 30)),
          ),
          AppConstants.fieldHatchingStreakDays: 29,
          AppConstants.fieldLastHatchingActivityDate: Timestamp.fromDate(
            _yesterday,
          ),
        },
      },
    );
    final fs = await _store(doc);
    await _pumpApp(tester, fs);

    await _log(tester);

    expect(find.byType(EggHatchingCelebration), findsOneWidget);

    await _settle(tester, 40);
    await tester.enterText(find.byType(TextField), 'Sprig');
    await tester.tap(find.byType(FilledButton));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await _settle(tester);

    expect(find.byType(EggHatchingCelebration), findsNothing);
    final stored = (await fs.collection('users').doc(_uid).get()).data()!;
    final mascots = stored[AppConstants.fieldMascots] as List<dynamic>;
    final hatched = mascots.last as Map<String, dynamic>;
    expect(hatched[AppConstants.fieldName], 'Sprig');

    await _unmount(tester);
  });

  group('streak milestone', () {
    Map<String, dynamic> streak(int days, DateTime last) => _userDoc(
      level: 12,
      points: calculatePointsForLevel(12),
      extra: {
        AppConstants.fieldCurrentStreak: days,
        AppConstants.fieldLastActionDate: Timestamp.fromDate(last),
      },
    );

    testWidgets('a log that crosses week 1 shows the milestone', (
      tester,
    ) async {
      final fs = await _store(streak(6, _yesterday));
      await _pumpApp(tester, fs);
      expect(find.byType(StreakMilestoneDialog), findsNothing);

      await _log(tester);

      expect(find.byType(StreakMilestoneDialog), findsOneWidget);
      await _popTop(tester);
      final doc = await fs.collection('users').doc(_uid).get();
      final settings = doc.data()![AppConstants.fieldSettings] as Map;
      final seen = settings[AppConstants.fieldSeenStreakMilestones] as Map;
      expect(seen['1'], isTrue);
      await _unmount(tester);
    });

    testWidgets('an already-seen milestone shows nothing', (tester) async {
      await _pumpApp(
        tester,
        await _store(streak(6, _yesterday)),
        seenWeeks: {1},
      );

      await _log(tester);

      expect(find.byType(StreakMilestoneDialog), findsNothing);
      await _unmount(tester);
    });

    testWidgets('an unseen milestone at mount shows once', (tester) async {
      await _pumpApp(tester, await _store(streak(7, DateTime.now())));

      expect(find.byType(StreakMilestoneDialog), findsOneWidget);
      await _popTop(tester);

      await _log(tester);

      expect(find.byType(StreakMilestoneDialog), findsNothing);
      await _unmount(tester);
    });
  });

  testWidgets('Eco-Dex unlocks pending at mount are celebrated', (
    tester,
  ) async {
    final discovery = _FakeDiscovery()..newIds = ['forests_01'];
    await _pumpApp(
      tester,
      await _store(
        _userDoc(
          level: 12,
          points: calculatePointsForLevel(12),
          extra: {AppConstants.fieldTotalActionsCount: 1},
        ),
      ),
      discovery: discovery,
    );

    expect(find.byType(EcoDexCelebrationScreen), findsOneWidget);
    await _popTop(tester);
    await _unmount(tester);
  });

  testWidgets('an unlock from a write outside the log tap is celebrated', (
    tester,
  ) async {
    final discovery = _FakeDiscovery();
    final fs = await _store(
      _userDoc(level: 12, points: calculatePointsForLevel(12)),
    );
    await _pumpApp(tester, fs, discovery: discovery);
    expect(find.byType(EcoDexCelebrationScreen), findsNothing);

    // A bank or calendar reproduce write, which skips handleActionTap.
    discovery.newIds = ['forests_01'];
    await fs.collection(AppConstants.collectionUsers).doc(_uid).update({
      AppConstants.fieldTotalActionsCount: 1,
    });
    await _settle(tester, 40);

    expect(find.byType(EcoDexCelebrationScreen), findsOneWidget);
    await _popTop(tester);
    await _unmount(tester);
  });

  group('a challenge-completing log on the action log route', () {
    testWidgets('opens the inbox after the Eco-Dex celebration', (
      tester,
    ) async {
      final fs = await _store(
        _userDoc(level: 12, points: calculatePointsForLevel(12)),
      );
      await _pumpApp(tester, fs, challengeLog: true);

      await _expectInboxWaitsFor(tester, find.byType(EcoDexCelebrationScreen));
      await _unmount(tester);
    });

    testWidgets('opens the inbox after the hatching celebration', (
      tester,
    ) async {
      final fs = await _store(
        _userDoc(
          level: 30,
          points: calculatePointsForLevel(30),
          lastSeenStage: 3,
          extra: {
            AppConstants.fieldEcodexDiscovered: ['forests_01'],
            AppConstants.fieldEgg: {
              'receivedAt': Timestamp.fromDate(
                _yesterday.subtract(const Duration(days: 30)),
              ),
              AppConstants.fieldHatchingStreakDays: 29,
              AppConstants.fieldLastHatchingActivityDate: Timestamp.fromDate(
                _yesterday,
              ),
            },
          },
        ),
      );
      await _pumpApp(tester, fs, challengeLog: true);

      await _expectInboxWaitsFor(tester, find.byType(EggHatchingCelebration));
      await _unmount(tester);
    });
  });
}
