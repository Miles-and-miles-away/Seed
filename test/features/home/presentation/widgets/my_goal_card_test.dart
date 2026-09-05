import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/home/presentation/widgets/my_goal_card.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  Future<void> pumpCard(
    WidgetTester tester, {
    AppUserModel? currentUser,
  }) async {
    await tester.pumpWidget(
      createTestWidget(
        child: const MyGoalCard(),
        overrides: [userOverride(currentUser)],
        scaffold: true,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();
  }

  const baseUser = AppUserModel(uid: 'u1', email: 'user@example.com');

  group('MyGoalCard', () {
    testWidgets('shows set-goal prompt when no goal', (tester) async {
      await pumpCard(tester, currentUser: baseUser);

      expect(find.text('My Goal'), findsOneWidget);
      expect(find.text('Tap to set your sustainability goal'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    });

    testWidgets('shows localized preset and edit icon when goal set', (
      tester,
    ) async {
      await pumpCard(
        tester,
        currentUser: baseUser.copyWith(personalGoal: 'save_world'),
      );

      expect(find.text('Save the world'), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsNothing);
    });

    testWidgets('shows legacy custom goal text verbatim', (tester) async {
      await pumpCard(
        tester,
        currentUser: baseUser.copyWith(personalGoal: 'Plant 100 trees'),
      );

      expect(find.text('Plant 100 trees'), findsOneWidget);
    });

    testWidgets('shows prefixed custom goal text verbatim', (tester) async {
      await pumpCard(
        tester,
        currentUser: baseUser.copyWith(
          personalGoal: '${personalGoalCustomPrefix}Plant 100 trees',
        ),
      );

      expect(find.text('Plant 100 trees'), findsOneWidget);
    });

    testWidgets('tapping the card opens the goal picker sheet', (tester) async {
      await pumpCard(tester, currentUser: baseUser);

      await tester.tap(find.byType(MyGoalCard));
      await tester.pumpAndSettle();

      expect(find.byType(GoalPickerSheet), findsOneWidget);
    });
  });
}
