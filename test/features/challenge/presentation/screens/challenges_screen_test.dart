import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/data/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/features/challenge/presentation/screens/challenges_screen.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ChallengeTemplateData templateData;

  setUpAll(() async {
    final jsonString = await rootBundle.loadString(
      'data/app/challenge_templates.json',
    );
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final daily = (json['daily'] as List<dynamic>)
        .map(
          (e) => DailyChallengeTemplate.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
    final multiDay = (json['multiDay'] as List<dynamic>)
        .map(
          (e) => MultiDayChallengeTemplate.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
    templateData = ChallengeTemplateData(
      daily: daily,
      multiDay: multiDay,
    );
  });

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
        challengeTemplateDataProvider.overrideWith(
          (_) async => templateData,
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
      await tester.pumpAndSettle();

      // First template should be visible
      expect(
        find.text(templateData.multiDay.first.titleEn),
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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

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
      await tester.pumpAndSettle();

      // Active card has abandon button, not start
      // Other 5 templates are blocked (no start buttons)
      expect(find.byType(FilledButton), findsNothing);
    });
  });
}
