import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/actions/presentation/utils/handle_action_tap.dart';
import 'package:seed_app/features/actions/presentation/widgets/learn_only_info_dialog.dart';
import 'package:seed_app/features/actions/presentation/widgets/points_animation_overlay.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/screens/eco_dex_celebration_screen.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/streak_milestone_dialog.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../eco_dex/eco_dex_fixtures.dart';

/// Stands in for the real notifier: returns [result], or fails with
/// [error], or parks in loading (the in-flight guard case).
class _FakeActionLog extends ActionLogNotifier {
  ActionLogResult? result;
  Object? error;
  bool stayLoading = false;
  final calls = <({ActionModel action, String? note, String lang})>[];

  @override
  Future<ActionLogResult?> logAction(
    ActionModel action, {
    String? note,
    String languageCode = 'en',
  }) async {
    calls.add((action: action, note: note, lang: languageCode));
    if (stayLoading) {
      state = const AsyncValue.loading();
      return null;
    }
    if (error != null) {
      state = AsyncValue.error(error!, StackTrace.current);
      return null;
    }
    state = AsyncValue.data(result);
    return result;
  }
}

class _FakeDiscovery extends EcoDexDiscoveryNotifier {
  List<String> newIds = const [];
  int? receivedMinCount;

  @override
  Future<List<String>> discoverNewEntries({int? minActionsCount}) async {
    receivedMinCount = minActionsCount;
    return newIds;
  }
}

const _uid = 'u';

const _walk = ActionModel(
  id: 'walk',
  nameEn: 'Walk instead of drive',
  nameJa: '歩く',
  category: 'transport',
  points: 20,
  co2Grams: 500,
  relatedSdgs: ['11'],
);

const _learn = ActionModel(
  id: 'learn',
  nameEn: 'Read about SDGs',
  nameJa: '読む',
  category: 'learning',
  points: 0,
  isLearnOnly: true,
);

ActionLogResult _result({
  int? milestoneWeek,
  bool challengeCompleted = false,
  int newTotalActionsCount = 1,
}) => ActionLogResult(
  actionLog: ActionLogModel(
    id: 'log-1',
    actionId: 'walk',
    actionName: 'Walk instead of drive',
    category: 'transport',
    points: 20,
    co2Grams: 500,
    loggedAt: DateTime(2026, 6),
  ),
  newStreakDays: 7,
  crossedMilestoneWeek: milestoneWeek,
  challengeCompleted: challengeCompleted,
  newTotalActionsCount: newTotalActionsCount,
);

void main() {
  late FakeFirebaseFirestore firestore;
  late _FakeActionLog log;
  late _FakeDiscovery discovery;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    await firestore.collection(AppConstants.collectionUsers).doc(_uid).set({
      'uid': _uid,
      AppConstants.fieldSettings: <String, dynamic>{},
    });
    log = _FakeActionLog();
    discovery = _FakeDiscovery();
  });

  Future<void> pumpHost(
    WidgetTester tester, {
    ActionModel action = _walk,
    UserSettingsModel settings = const UserSettingsModel(),
  }) async {
    await tester.pumpWidget(
      createTestWidget(
        firestore: firestore,
        scaffold: true,
        overrides: [
          userOverride(const AppUserModel(uid: _uid, email: 'e')),
          actionLogProvider.overrideWith(() => log),
          ecoDexDiscoveryProvider.overrideWith(() => discovery),
          ecoDexDataProvider.overrideWith(
            (_) async => ecoDexDataFor([ecoDexEntry('forests_01')]),
          ),
          ecoDexAvailableIconsProvider.overrideWith((_) async => <String>{}),
          userSettingsProvider.overrideWith((_) => Stream.value(settings)),
          activeMascotAssetPathProvider.overrideWith((_) => null),
          activeStageDataProvider.overrideWith((_) => null),
          sdgGoalsDataProvider.overrideWith(
            (_) async => const SdgGoalsData(goals: [], goalMap: {}),
          ),
        ],
        child: Consumer(
          builder: (context, ref, _) => ElevatedButton(
            onPressed: () => handleActionTap(
              context,
              ref,
              action: action,
              languageCode: 'en',
            ),
            child: const Text('tap'),
          ),
        ),
      ),
    );
    // The shell and SeedApp keep these alive; mirror that here.
    ProviderScope.containerOf(tester.element(find.byType(ElevatedButton)))
      ..listen(currentUserProvider, (_, _) {})
      ..listen(userSettingsProvider, (_, _) {});
  }

  ProviderContainer containerOf(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(ElevatedButton)));

  /// Pumps frames on the fake clock until [finder] matches (bounded).
  Future<void> pumpUntil(WidgetTester tester, Finder finder) async {
    for (var i = 0; i < 20 && finder.evaluate().isEmpty; i++) {
      await tester.pump();
    }
  }

  /// Confirms the dialog, then pumps until [until] appears (or a few
  /// frames when nothing is expected to appear).
  Future<void> tapAndConfirm(WidgetTester tester, {Finder? until}) async {
    await tester.tap(find.text('tap'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    if (until != null) {
      await pumpUntil(tester, until);
    } else {
      for (var i = 0; i < 6; i++) {
        await tester.pump();
      }
    }
  }

  /// Runs out the points overlay, snackbars and bounce timer.
  Future<void> drain(WidgetTester tester) async {
    await tester.pump(durationShowcase);
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
  }

  testWidgets('learn-only actions open the info dialog and never log', (
    tester,
  ) async {
    await pumpHost(tester, action: _learn);

    await tester.tap(find.text('tap'));
    await tester.pumpAndSettle();

    expect(find.byType(LearnOnlyInfoDialog), findsOneWidget);
    expect(log.calls, isEmpty);
    await tester.tap(find.text('Got It'));
    await tester.pumpAndSettle();
  });

  testWidgets('cancelling the confirmation logs nothing', (tester) async {
    await pumpHost(tester);

    await tester.tap(find.text('tap'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(log.calls, isEmpty);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('confirming logs with the note and celebrates', (tester) async {
    log.result = _result(newTotalActionsCount: 42);
    await pumpHost(tester);
    var bounced = false;
    containerOf(tester).listen(mascotAnimationTriggerProvider, (_, next) {
      if (next) bounced = true;
    });

    await tester.tap(find.text('tap'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  used my own bag ');
    await tester.tap(find.text('Confirm'));
    await pumpUntil(tester, find.text('Action logged! 20 points earned'));

    expect(log.calls.single.action, _walk);
    expect(log.calls.single.note, 'used my own bag');
    expect(log.calls.single.lang, 'en');
    expect(find.text('Action logged! 20 points earned'), findsOneWidget);
    expect(find.byType(PointsAnimationOverlay), findsOneWidget);
    expect(bounced, isTrue);
    expect(discovery.receivedMinCount, 42);
    expect(find.byType(StreakMilestoneDialog), findsNothing);
    expect(find.byType(EcoDexCelebrationScreen), findsNothing);
    await drain(tester);
  });

  testWidgets('a completed daily challenge queues a second snackbar', (
    tester,
  ) async {
    log.result = _result(challengeCompleted: true);
    await pumpHost(tester);

    await tapAndConfirm(
      tester,
      until: find.text('Action logged! 20 points earned'),
    );
    expect(find.text('Action logged! 20 points earned'), findsOneWidget);
    // The first snackbar has to hide before the queued one animates in.
    final queued = find.text('Challenge completed! Eco-fact unlocked!');
    for (var i = 0; i < 20 && queued.evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }

    expect(queued, findsOneWidget);
    await drain(tester);
  });

  testWidgets('a new milestone shows the celebration and marks it seen', (
    tester,
  ) async {
    log.result = _result(milestoneWeek: 1);
    await pumpHost(tester);

    await tapAndConfirm(tester, until: find.byType(StreakMilestoneDialog));
    expect(find.byType(StreakMilestoneDialog), findsOneWidget);

    await tester.pump(durationNormal);
    expect(find.text('1 Week Streak!'), findsOneWidget);
    await tester.pump(durationCelebration);
    await tester.tap(find.text('Continue'));
    for (
      var i = 0;
      i < 20 && find.byType(StreakMilestoneDialog).evaluate().isNotEmpty;
      i++
    ) {
      await tester.pump();
    }

    expect(find.byType(StreakMilestoneDialog), findsNothing);
    final doc = await firestore
        .collection(AppConstants.collectionUsers)
        .doc(_uid)
        .get();
    final settings = doc.data()![AppConstants.fieldSettings] as Map;
    final seen = settings[AppConstants.fieldSeenStreakMilestones] as Map;
    expect(seen['1'], isTrue);
    await drain(tester);
  });

  testWidgets('an already-seen milestone is not celebrated again', (
    tester,
  ) async {
    log.result = _result(milestoneWeek: 1);
    await pumpHost(
      tester,
      settings: const UserSettingsModel(seenStreakMilestones: {'1': true}),
    );

    await tapAndConfirm(
      tester,
      until: find.text('Action logged! 20 points earned'),
    );

    expect(find.byType(StreakMilestoneDialog), findsNothing);
    expect(find.text('Action logged! 20 points earned'), findsOneWidget);
    await drain(tester);
  });

  testWidgets('newly discovered Eco-Dex entries are celebrated', (
    tester,
  ) async {
    log.result = _result();
    discovery.newIds = ['forests_01', 'unknown-id'];
    await pumpHost(tester);

    await tapAndConfirm(tester, until: find.byType(EcoDexCelebrationScreen));

    expect(find.byType(EcoDexCelebrationScreen), findsOneWidget);
    expect(find.text('forests_01'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text('Awesome!'));
    await tester.pump();
    await tester.pump();

    // The unknown id has no entry, so only one celebration was queued.
    expect(find.byType(EcoDexCelebrationScreen), findsNothing);
    await drain(tester);
  });

  group('failure snackbars', () {
    Future<void> expectMessage(WidgetTester tester, String message) async {
      await pumpHost(tester);
      await tapAndConfirm(tester, until: find.text(message));

      expect(find.text(message), findsOneWidget);
      expect(find.byType(PointsAnimationOverlay), findsNothing);
      await drain(tester);
    }

    testWidgets('permission-denied reads as the rate limit', (tester) async {
      log.error = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
      );
      await expectMessage(tester, 'Please wait a few seconds between actions.');
    });

    testWidgets('unavailable reads as offline', (tester) async {
      log.error = FirebaseException(
        plugin: 'cloud_firestore',
        code: 'unavailable',
      );
      await expectMessage(
        tester,
        "You're offline. Check your connection and try again.",
      );
    });

    testWidgets('anything else reads as the generic error', (tester) async {
      log.error = Exception('boom');
      await expectMessage(tester, 'Something went wrong. Please try again.');
    });

    testWidgets('a dropped in-flight duplicate shows nothing', (tester) async {
      log.stayLoading = true;
      await pumpHost(tester);

      await tapAndConfirm(tester);

      expect(find.byType(SnackBar), findsNothing);
      expect(find.byType(PointsAnimationOverlay), findsNothing);
    });
  });
}
