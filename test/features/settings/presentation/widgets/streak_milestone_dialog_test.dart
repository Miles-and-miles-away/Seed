import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/streak_milestone_dialog.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  late FakeFirebaseFirestore firestore;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    await firestore.collection(AppConstants.collectionUsers).doc('u').set({
      'uid': 'u',
      AppConstants.fieldSettings: <String, dynamic>{},
    });
  });

  Future<void> pumpDialog(
    WidgetTester tester, {
    required VoidCallback onDismiss,
  }) async {
    await tester.pumpWidget(
      createTestWidget(
        firestore: firestore,
        overrides: [
          userOverride(const AppUserModel(uid: 'u', email: 'e')),
          // No mascot art: keeps Rive out of the test.
          activeMascotAssetPathProvider.overrideWith((_) => null),
          activeStageDataProvider.overrideWith((_) => null),
        ],
        child: StreakMilestoneDialog(
          weekNumber: 2,
          totalDays: 14,
          onDismiss: onDismiss,
        ),
      ),
    );
    // The shell keeps the user stream alive app-wide.
    ProviderScope.containerOf(
      tester.element(find.byType(StreakMilestoneDialog)),
    ).listen(currentUserProvider, (_, _) {});
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
    await pumpDialog(tester, onDismiss: () {});
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

  testWidgets('Continue marks the week seen, then dismisses', (tester) async {
    var dismissed = false;
    await pumpDialog(tester, onDismiss: () => dismissed = true);
    await tester.pump(durationNormal);
    await tester.pump(durationCelebration);

    await tester.tap(find.text('Continue'));
    for (var i = 0; i < 6; i++) {
      await tester.pump();
    }

    expect(dismissed, isTrue);
    final doc = await firestore
        .collection(AppConstants.collectionUsers)
        .doc('u')
        .get();
    final settings = doc.data()![AppConstants.fieldSettings] as Map;
    final seen = settings[AppConstants.fieldSeenStreakMilestones] as Map;
    expect(seen['2'], isTrue);

    await tearDownTree(tester);
  });
}
