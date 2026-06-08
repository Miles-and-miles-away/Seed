import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/home/presentation/widgets/my_goal_card.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

void main() {
  Widget createTestWidget({AppUserModel? currentUser}) {
    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWith((ref) => Stream.value(currentUser)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const Scaffold(body: MyGoalCard()),
      ),
    );
  }

  const baseUser = AppUserModel(uid: 'u1', email: 'user@example.com');

  group('MyGoalCard', () {
    testWidgets('shows set-goal prompt when no goal', (tester) async {
      await tester.pumpWidget(createTestWidget(currentUser: baseUser));
      await tester.pumpAndSettle();

      expect(find.text('My Goal'), findsOneWidget);
      expect(
        find.text('Tap to set your sustainability goal'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    });

    testWidgets('shows localized preset and edit icon when goal set',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          currentUser: baseUser.copyWith(personalGoal: 'save_world'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Save the world'), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.byIcon(Icons.add_circle_outline), findsNothing);
    });

    testWidgets('shows custom goal text verbatim', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          currentUser: baseUser.copyWith(personalGoal: 'Plant 100 trees'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Plant 100 trees'), findsOneWidget);
    });

    testWidgets('tapping the card opens the goal picker sheet', (tester) async {
      await tester.pumpWidget(createTestWidget(currentUser: baseUser));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(MyGoalCard));
      await tester.pumpAndSettle();

      expect(find.byType(GoalPickerSheet), findsOneWidget);
    });
  });
}
