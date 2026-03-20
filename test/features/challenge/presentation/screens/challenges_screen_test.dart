import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/data/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/screens/challenges_screen.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildScreen({
    required AppUserModel user,
  }) {
    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWith(
          (_) => Stream.value(user),
        ),
        firestoreProvider.overrideWithValue(
          createFakeFirestore(),
        ),
      ],
      child: createTestWidget(
        child: const ChallengesScreen(),
      ),
    );
  }

  group('ChallengesScreen', () {
    testWidgets('renders multi-day templates', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
      );

      await tester.pumpWidget(buildScreen(user: user));
      await tester.pump();

      // First template should be visible
      expect(
        find.text(multiDayChallengeTemplates.first.titleEn),
        findsOneWidget,
      );
      // Should have multiple cards visible
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('shows completed badge for finished', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        completedMultiDayChallenges: ['md_vegan_week'],
      );

      await tester.pumpWidget(buildScreen(user: user));
      await tester.pump();

      expect(
        find.byIcon(Icons.check_circle),
        findsOneWidget,
      );
    });

    testWidgets('shows progress bar for active challenge', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        activeMultiDayChallenge: {
          'templateId': 'md_vegan_week',
          'currentDay': 3,
          'targetDays': 7,
          'lastCompletionDate': '',
        },
      );

      await tester.pumpWidget(buildScreen(user: user));
      await tester.pump();

      expect(
        find.byType(LinearProgressIndicator),
        findsOneWidget,
      );
    });

    testWidgets('shows start button for available', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
      );

      await tester.pumpWidget(buildScreen(user: user));
      await tester.pump();

      // Visible templates should have start buttons
      expect(find.byType(FilledButton), findsWidgets);
    });

    testWidgets('blocks other templates when one is active', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        activeMultiDayChallenge: {
          'templateId': 'md_vegan_week',
          'currentDay': 1,
          'targetDays': 7,
          'lastCompletionDate': '',
        },
      );

      await tester.pumpWidget(buildScreen(user: user));
      await tester.pump();

      // Active card has abandon button, not start
      // Other 5 templates are blocked (no start buttons)
      expect(find.byType(FilledButton), findsNothing);
    });
  });
}
