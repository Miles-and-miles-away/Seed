import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/features/challenge/presentation/widgets/multi_day_challenge_card.dart';

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

  Widget buildCard({
    required AppUserModel user,
  }) {
    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWith(
          (_) => Stream.value(user),
        ),
        challengeTemplateDataProvider.overrideWith(
          (_) async => templateData,
        ),
      ],
      child: createTestWidget(
        child: const Scaffold(
          body: SingleChildScrollView(
            child: MultiDayChallengeCard(),
          ),
        ),
      ),
    );
  }

  group('MultiDayChallengeCard', () {
    testWidgets('renders nothing when no active challenge', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
      );

      await tester.pumpWidget(buildCard(user: user));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('renders card with active challenge', (
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

      await tester.pumpWidget(buildCard(user: user));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
      // Shows template title
      expect(find.text('Vegan Week'), findsOneWidget);
      // Shows progress indicator
      expect(
        find.byType(LinearProgressIndicator),
        findsOneWidget,
      );
      // Shows chevron
      expect(
        find.byIcon(Icons.chevron_right),
        findsOneWidget,
      );
    });

    testWidgets('renders nothing with empty template ID', (
      tester,
    ) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        activeMultiDayChallenge: {
          'currentDay': 0,
          'targetDays': 7,
        },
      );

      await tester.pumpWidget(buildCard(user: user));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
    });
  });
}
