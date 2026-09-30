import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/settings/data/repositories/settings_repository.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/streak_milestone_dialog.dart';

import '../../../../helpers/test_helpers.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late FakeFirebaseFirestore firestore;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    await firestore.collection(AppConstants.collectionUsers).doc('u').set({
      'uid': 'u',
      AppConstants.fieldSettings: <String, dynamic>{},
    });
  });

  final baseOverrides = [
    userOverride(const AppUserModel(uid: 'u', email: 'e')),
    // No mascot art: keeps Rive out of the test.
    activeMascotAssetPathProvider.overrideWith((_) => null),
    activeStageDataProvider.overrideWith((_) => null),
  ];

  /// Opens the celebration through its helper from a host button.
  Future<void> pumpAndShow(
    WidgetTester tester, {
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(
      createTestWidget(
        firestore: firestore,
        overrides: [...baseOverrides, ...overrides],
        child: Consumer(
          builder: (context, ref, _) => ElevatedButton(
            onPressed: () => showStreakMilestoneCelebration(
              context,
              ref,
              weekNumber: 2,
              totalDays: 14,
            ),
            child: const Text('show'),
          ),
        ),
      ),
    );
    // The shell keeps the user stream alive app-wide.
    ProviderScope.containerOf(
      tester.element(find.byType(ElevatedButton)),
    ).listen(currentUserProvider, (_, _) {});
    await tester.pump();
    await tester.tap(find.text('show'));
    await tester.pump();
  }

  Future<void> revealButton(WidgetTester tester) async {
    await tester.pump(durationNormal);
    await tester.pump(durationCelebration);
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump();
    }
  }

  // Drops the looping confetti, then flushes flutter_animate's timers.
  Future<void> tearDownTree(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('reveals the copy first and the button afterwards', (
    tester,
  ) async {
    await pumpAndShow(tester);
    expect(find.text('Amazing!'), findsNothing);

    await tester.pump(durationNormal);
    expect(find.text('Amazing!'), findsOneWidget);
    expect(find.text('2 Week Streak!'), findsOneWidget);
    expect(
      find.text("You've logged actions for 14 days in a row!"),
      findsOneWidget,
    );
    expect(find.text('Continue'), findsNothing);

    await tester.pump(durationCelebration);
    expect(find.text('Continue'), findsOneWidget);

    await tearDownTree(tester);
  });

  testWidgets('Continue dismisses, then marks the week seen', (tester) async {
    await pumpAndShow(tester);
    await revealButton(tester);

    await tester.tap(find.text('Continue'));
    await settle(tester);

    expect(find.byType(StreakMilestoneDialog), findsNothing);
    final doc = await firestore
        .collection(AppConstants.collectionUsers)
        .doc('u')
        .get();
    final settings = doc.data()![AppConstants.fieldSettings] as Map;
    final seen = settings[AppConstants.fieldSeenStreakMilestones] as Map;
    expect(seen['2'], isTrue);

    await tearDownTree(tester);
  });

  group('with a write that never answers', () {
    late _MockSettingsRepository repo;

    setUp(() {
      repo = _MockSettingsRepository();
      when(
        () => repo.markMilestoneSeen(any(), any()),
      ).thenAnswer((_) => Completer<void>().future);
    });

    testWidgets('Continue still closes the dialog', (tester) async {
      await pumpAndShow(
        tester,
        overrides: [settingsRepositoryProvider.overrideWithValue(repo)],
      );
      await revealButton(tester);

      await tester.tap(find.text('Continue'));
      await settle(tester);

      expect(find.byType(StreakMilestoneDialog), findsNothing);
      verify(() => repo.markMilestoneSeen('u', 2)).called(1);
      await tearDownTree(tester);
    });

    testWidgets('system back still marks the week seen', (tester) async {
      await pumpAndShow(
        tester,
        overrides: [settingsRepositoryProvider.overrideWithValue(repo)],
      );
      await revealButton(tester);

      await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
      await settle(tester);

      expect(find.byType(StreakMilestoneDialog), findsNothing);
      verify(() => repo.markMilestoneSeen('u', 2)).called(1);
      await tearDownTree(tester);
    });
  });
}
