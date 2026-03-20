import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/presentation/widgets/daily_challenge_card.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final todayKey = formatDateKey(DateTime.now());

  Widget buildCard({
    required AppUserModel user,
  }) {
    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWith(
          (_) => Stream.value(user),
        ),
      ],
      child: createTestWidget(
        child: const Scaffold(
          body: SingleChildScrollView(
            child: DailyChallengeCard(),
          ),
        ),
      ),
    );
  }

  group('DailyChallengeCard', () {
    testWidgets('renders nothing when user is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const Scaffold(
            body: DailyChallengeCard(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('renders incomplete state with title', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
      );

      await tester.pumpWidget(buildCard(user: user));
      await tester.pump();

      expect(find.byType(Card), findsOneWidget);
      // Should not show checkmark for incomplete
      expect(
        find.byIcon(Icons.check_circle),
        findsNothing,
      );
    });

    testWidgets('renders completed state with checkmark', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        challengeCompletedDate: todayKey,
      );

      await tester.pumpWidget(buildCard(user: user));
      await tester.pump();

      expect(find.byType(Card), findsOneWidget);
      expect(
        find.byIcon(Icons.check_circle),
        findsOneWidget,
      );
    });

    testWidgets('shows streak badge when streak > 0', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        challengeStreak: 5,
      );

      await tester.pumpWidget(buildCard(user: user));
      await tester.pump();

      expect(
        find.byIcon(Icons.local_fire_department),
        findsOneWidget,
      );
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('hides streak badge when streak is 0', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
      );

      await tester.pumpWidget(buildCard(user: user));
      await tester.pump();

      expect(
        find.byIcon(Icons.local_fire_department),
        findsNothing,
      );
    });
  });
}
