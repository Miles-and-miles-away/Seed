import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/data/repositories/settings_repository.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';

import '../../helpers/test_helpers.dart';
import 'walkthrough_test_support.dart';

const _uid = walkthroughTestUid;
const _allButQuiz = [
  WalkthroughItem.intro,
  WalkthroughItem.logAction,
  WalkthroughItem.dailyChallenge,
  WalkthroughItem.sdg,
  WalkthroughItem.ecoFact,
  WalkthroughItem.calculators,
  WalkthroughItem.progress,
];

void main() {
  late FakeFirebaseFirestore firestore;
  late SettingsRepository repo;
  late RecordingWalkthroughAnalytics analytics;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    repo = SettingsRepository(firestore: firestore);
    analytics = RecordingWalkthroughAnalytics();
    await firestore.collection(AppConstants.collectionUsers).doc(_uid).set({
      'uid': _uid,
      AppConstants.fieldSettings: <String, dynamic>{},
    });
  });

  Future<void> seedFound(Iterable<WalkthroughItem> items) async {
    for (final item in items) {
      await repo.markWalkthroughFound(_uid, item.name);
    }
  }

  Widget wrap(Widget child, {Stream<UserSettingsModel>? settings}) =>
      createTestWidget(
        scaffold: true,
        locale: const Locale('en'),
        overrides: walkthroughOverrides(
          settings: settings ?? repo.watchSettings(_uid),
          firestore: firestore,
          analytics: analytics,
        ),
        child: WarmUser(child: child),
      );

  Future<void> pumpTrigger(
    WidgetTester tester,
    WalkthroughItem item, {
    Stream<UserSettingsModel>? settings,
  }) async {
    sizeViewport(tester);
    await tester.pumpWidget(
      wrap(
        WalkthroughTrigger(item: item, child: const Text('screen')),
        settings: settings,
      ),
    );
    await pumpUntilFound(tester, find.byType(WalkthroughOverlay));
  }

  Future<void> tapButton(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pump();
    await tester.pump();
  }

  group('WalkthroughShimmer', () {
    Widget shimmer(Iterable<WalkthroughItem> found, {Widget? child}) => wrap(
      child ??
          const WalkthroughShimmer(
            item: WalkthroughItem.quiz,
            child: Text('anchor'),
          ),
      settings: Stream.value(settingsWith(found)),
    );

    testWidgets('sweeps once, then requests no frames until the gap ends', (
      tester,
    ) async {
      await tester.pumpWidget(shimmer([WalkthroughItem.intro]));
      await tester.pump();
      expect(find.byType(Animate), findsOneWidget);
      expect(tester.binding.hasScheduledFrame, isTrue);

      // Past the sweep: the controller is idle, so nothing asks to paint.
      await tester.pump(const Duration(milliseconds: 1100));
      await tester.pump();
      expect(tester.binding.hasScheduledFrame, isFalse);

      // The gap ends and the next sweep starts.
      await tester.pump(const Duration(seconds: 1));
      expect(tester.binding.hasScheduledFrame, isTrue);
      await flushOverlayTimers(tester);
    });

    testWidgets('is the identity once found, and before the intro', (
      tester,
    ) async {
      await tester.pumpWidget(
        shimmer([WalkthroughItem.intro, WalkthroughItem.quiz]),
      );
      await tester.pump();
      expect(find.byType(Animate), findsNothing);
      expect(find.text('anchor'), findsOneWidget);

      await tester.pumpWidget(shimmer(const []));
      await tester.pump();
      expect(find.byType(Animate), findsNothing);
    });

    testWidgets('draws a static border under reduced motion', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: shimmer([WalkthroughItem.intro]),
        ),
      );
      await tester.pump();
      expect(find.byType(Animate), findsNothing);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox && w.position == DecorationPosition.foreground,
        ),
        findsOneWidget,
      );
    });
  });

  group('WalkthroughTrigger', () {
    testWidgets('pops once, marks the item found, then stays quiet', (
      tester,
    ) async {
      await seedFound([WalkthroughItem.intro]);
      late StateSetter rebuild;
      sizeViewport(tester);
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (_, setState) {
              rebuild = setState;
              return const WalkthroughTrigger(
                item: WalkthroughItem.quiz,
                child: Text('screen'),
              );
            },
          ),
        ),
      );
      await pumpUntilFound(tester, find.byType(WalkthroughOverlay));
      expect(find.text('Things to find'), findsOneWidget);

      rebuild(() {});
      await tester.pump();
      await tester.pump();
      expect(find.byType(WalkthroughOverlay), findsOneWidget);

      await tapButton(tester, 'Got it');
      expect(find.byType(WalkthroughOverlay), findsNothing);
      await settleWrites(tester);
      expect(await foundInFirestore(firestore, _uid), ['intro', 'quiz']);
      expect(analytics.events, ['found:quiz']);
      await flushOverlayTimers(tester);
    });

    testWidgets('does nothing when the item is already found', (tester) async {
      await seedFound([WalkthroughItem.intro, WalkthroughItem.quiz]);
      sizeViewport(tester);
      await tester.pumpWidget(
        wrap(
          const WalkthroughTrigger(
            item: WalkthroughItem.quiz,
            child: Text('screen'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final container = ProviderScope.containerOf(
        tester.element(find.text('screen')),
      );
      expect(container.read(walkthroughFoundProvider), {'intro', 'quiz'});
      expect(find.byType(WalkthroughOverlay), findsNothing);
    });

    testWidgets('waits while offstage and re-arms after a reset', (
      tester,
    ) async {
      final settings = StreamController<UserSettingsModel>();
      final onstage = ValueNotifier(false);
      addTearDown(settings.close);
      addTearDown(onstage.dispose);
      sizeViewport(tester);
      await tester.pumpWidget(
        wrap(
          ValueListenableBuilder<bool>(
            valueListenable: onstage,
            builder: (_, enabled, _) => TickerMode(
              enabled: enabled,
              child: const WalkthroughTrigger(
                item: WalkthroughItem.quiz,
                child: Text('screen'),
              ),
            ),
          ),
          settings: settings.stream,
        ),
      );
      settings.add(settingsWith([WalkthroughItem.intro]));
      await tester.pump();
      await tester.pump();
      expect(find.byType(WalkthroughOverlay), findsNothing);

      onstage.value = true;
      await pumpUntilFound(tester, find.byType(WalkthroughOverlay));

      await tapButton(tester, 'Got it');
      settings.add(settingsWith([WalkthroughItem.intro, WalkthroughItem.quiz]));
      await tester.pump();
      expect(find.byType(WalkthroughOverlay), findsNothing);

      settings.add(settingsWith([WalkthroughItem.intro]));
      await pumpUntilFound(tester, find.byType(WalkthroughOverlay));
      expect(find.byType(WalkthroughOverlay), findsOneWidget);
      await flushOverlayTimers(tester);
    });

    testWidgets('system back does not dismiss the overlay', (tester) async {
      await seedFound([WalkthroughItem.intro]);
      await pumpTrigger(tester, WalkthroughItem.quiz);

      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(find.byType(WalkthroughOverlay), findsOneWidget);
      await flushOverlayTimers(tester);
    });
  });

  group('WalkthroughOverlay', () {
    testWidgets('steps through pages and shows the checklist last', (
      tester,
    ) async {
      await seedFound([
        WalkthroughItem.intro,
        WalkthroughItem.sdg,
        WalkthroughItem.ecoFact,
      ]);
      await pumpTrigger(tester, WalkthroughItem.calculators);

      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Things to find'), findsNothing);
      await tapButton(tester, 'Next');
      await tapButton(tester, 'Next');
      await tapButton(tester, 'Next');
      expect(find.text('Got it'), findsOneWidget);
      expect(find.text('Things to find'), findsOneWidget);
      // sdg, ecoFact and the current item are ticked; four remain.
      expect(find.byIcon(Icons.check_circle), findsNWidgets(3));
      expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(4));
      final label = tester.widget<Text>(find.text('Meet the calculators'));
      expect(label.style?.fontWeight, FontWeight.bold);
      expect(find.byType(TimedConfettiLayer), findsNothing);

      await tapButton(tester, 'Got it');
      await flushOverlayTimers(tester);
    });

    testWidgets('the last item ends with confetti and a completed event', (
      tester,
    ) async {
      await seedFound(_allButQuiz);
      await pumpTrigger(tester, WalkthroughItem.quiz);

      expect(find.text('Next'), findsOneWidget);
      await tapButton(tester, 'Next');
      expect(find.textContaining("That's everything"), findsOneWidget);
      expect(find.byType(TimedConfettiLayer), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNWidgets(7));

      await tapButton(tester, 'Got it');
      expect(find.byType(WalkthroughOverlay), findsNothing);
      await settleWrites(tester);
      expect(analytics.events, ['found:quiz', 'completed']);
      await flushOverlayTimers(tester);
    });

    testWidgets("the intro greets by name, ends on Let's go, ticks nothing", (
      tester,
    ) async {
      await pumpTrigger(tester, WalkthroughItem.intro);
      await pumpUntilFound(tester, find.textContaining("Hi, I'm Pip"));

      expect(find.textContaining("Hi, I'm Pip"), findsOneWidget);
      expect(find.text('Pip'), findsOneWidget);
      await tapButton(tester, 'Next');
      expect(find.text("Let's go"), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);
      expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(7));

      await tapButton(tester, "Let's go");
      expect(find.byType(WalkthroughOverlay), findsNothing);
      await settleWrites(tester);
      expect(await foundInFirestore(firestore, _uid), ['intro']);
      await flushOverlayTimers(tester);
    });

    testWidgets('a replayed intro never shows the completion page', (
      tester,
    ) async {
      await seedFound(WalkthroughItem.checklist);
      await pumpTrigger(tester, WalkthroughItem.intro);

      await tapButton(tester, 'Next');
      expect(find.text("Let's go"), findsOneWidget);
      expect(find.byType(TimedConfettiLayer), findsNothing);
      await flushOverlayTimers(tester);
    });
  });
}
