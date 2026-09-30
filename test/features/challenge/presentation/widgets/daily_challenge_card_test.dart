import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
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
import 'package:seed_app/features/settings/data/repositories/settings_repository.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../walkthrough/walkthrough_test_support.dart';

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
            localizationsDelegates: AppLocalizations.localizationsDelegates,
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

    group('walkthrough', () {
      late FakeFirebaseFirestore firestore;
      late SettingsRepository repo;
      const uid = 'test-uid';

      setUp(() async {
        firestore = FakeFirebaseFirestore();
        repo = SettingsRepository(firestore: firestore);
        await firestore.collection('users').doc(uid).set({'uid': uid});
        await repo.markWalkthroughFound(uid, WalkthroughItem.intro.name);
      });

      Widget app(AppUserModel user, GoRouter router) => ProviderScope(
        overrides: [
          ...walkthroughOverrides(
            user: user,
            settings: repo.watchSettings(uid),
            firestore: firestore,
          ),
          challengeTemplateDataProvider.overrideWith(
            (_) async => testTemplateData,
          ),
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      );

      // Home wraps the card in its shimmer, which keeps the pending
      // provider alive for the card's synchronous read.
      GoRoute home() => GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(
          body: WarmUser(
            child: WalkthroughShimmer(
              item: WalkthroughItem.dailyChallenge,
              child: DailyChallengeCard(),
            ),
          ),
        ),
      );

      testWidgets('incomplete card explains itself, then opens the log', (
        tester,
      ) async {
        sizeViewport(tester);
        String? capturedCategory;
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            home(),
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
          app(const AppUserModel(uid: uid, email: 'e'), router),
        );
        await pumpUntilFound(tester, find.text('Test Challenge'));

        await tester.tap(find.text('Test Challenge'));
        await pumpUntilFound(tester, find.byType(WalkthroughOverlay));
        expect(find.text('Action Log'), findsNothing);

        await tester.tap(find.text('Got it'));
        await pumpUntilFound(tester, find.text('Action Log'));
        expect(capturedCategory, 'recycling');
        await settleWrites(tester);
        final found = await foundInFirestore(firestore, uid);
        expect(found, contains(WalkthroughItem.dailyChallenge.name));
        expect(found, isNot(contains(WalkthroughItem.logAction.name)));
        await flushOverlayTimers(tester);
      });

      testWidgets('completed card ticks silently and opens the inbox', (
        tester,
      ) async {
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            home(),
            GoRoute(
              path: '/home/daily-fact',
              builder: (_, _) => const Scaffold(body: Text('Inbox')),
            ),
          ],
        );
        await tester.pumpWidget(
          app(
            AppUserModel(
              uid: uid,
              email: 'e',
              challengeCompletedDate: todayKey,
            ),
            router,
          ),
        );
        await pumpUntilFound(tester, find.text("See today's eco-fact"));

        await tester.tap(find.text("See today's eco-fact"));
        await pumpUntilFound(tester, find.text('Inbox'));
        expect(find.byType(WalkthroughOverlay), findsNothing);
        await settleWrites(tester);
        final found = await foundInFirestore(firestore, uid);
        expect(found, contains(WalkthroughItem.dailyChallenge.name));
      });
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
