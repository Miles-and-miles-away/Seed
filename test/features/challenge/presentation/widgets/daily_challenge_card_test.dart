import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/features/challenge/presentation/widgets/daily_challenge_card.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final todayKey = formatDateKey(DateTime.now());

  final testTemplateData = ChallengeTemplateData(
    daily: [
      const DailyChallengeTemplate(
        id: 'test_1',
        category: 'recycling',
        titleEn: 'Test Challenge',
        titleEs: 'Reto de Prueba',
        titleJa: 'テストチャレンジ',
      ),
    ],
    multiDay: [],
  );

  Widget buildCard({required AppUserModel user}) {
    return ProviderScope(
      overrides: [
        currentUserProvider.overrideWith((_) => Stream.value(user)),
        challengeTemplateDataProvider.overrideWith(
          (_) async => testTemplateData,
        ),
      ],
      child: createTestWidget(
        child: const Scaffold(
          body: SingleChildScrollView(child: DailyChallengeCard()),
        ),
      ),
    );
  }

  group('DailyChallengeCard', () {
    testWidgets('renders nothing when user is null', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            challengeTemplateDataProvider.overrideWith(
              (_) async => testTemplateData,
            ),
          ],
          child: createTestWidget(
            child: const Scaffold(body: DailyChallengeCard()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('renders incomplete state with title', (tester) async {
      final user = AppUserModel(uid: 'test-uid', email: 'test@example.com');

      await tester.pumpWidget(buildCard(user: user));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
      // Should not show checkmark for incomplete
      expect(find.byIcon(Icons.check_circle), findsNothing);
      // Chevron signals the card is tappable.
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('incomplete card opens action log filtered by category', (
      tester,
    ) async {
      final user = AppUserModel(uid: 'test-uid', email: 'test@example.com');

      String? capturedCategory;
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: DailyChallengeCard()),
          ),
          GoRoute(
            path: '/log-action',
            builder: (_, state) {
              capturedCategory = state.uri.queryParameters['category'];
              return const Scaffold(body: Text('Action Log'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((_) => Stream.value(user)),
            challengeTemplateDataProvider.overrideWith(
              (_) async => testTemplateData,
            ),
          ],
          child: MaterialApp.router(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Challenge'));
      await tester.pumpAndSettle();

      expect(find.text('Action Log'), findsOneWidget);
      expect(capturedCategory, 'recycling');
    });

    testWidgets('renders completed state with checkmark', (tester) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        challengeCompletedDate: todayKey,
      );

      await tester.pumpWidget(buildCard(user: user));
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows streak badge when streak > 0', (tester) async {
      final user = AppUserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        challengeStreak: 5,
        // A live streak requires a recent completion -- yesterday, so
        // today's challenge still renders as in-progress.
        challengeCompletedDate: formatDateKey(
          DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

      await tester.pumpWidget(buildCard(user: user));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('hides streak badge when streak is 0', (tester) async {
      final user = AppUserModel(uid: 'test-uid', email: 'test@example.com');

      await tester.pumpWidget(buildCard(user: user));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_fire_department), findsNothing);
    });
  });
}
