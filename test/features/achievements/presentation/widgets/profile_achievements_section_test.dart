import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/presentation/providers/achievement_providers.dart';
import 'package:seed_app/features/achievements/presentation/widgets/profile_achievements_section.dart';

AchievementDefinition _def(String id) => AchievementDefinition(
      id: id,
      category: AchievementCategory.action,
      iconName: 'emoji_events',
      bonusPoints: 100,
      criteria: const AchievementCriteria.actionCount(count: 10),
      nameEn: id,
      nameJa: '',
      nameEs: '',
      descriptionEn: id,
      descriptionJa: '',
      descriptionEs: '',
    );

Widget _wrap({
  required List<AchievementDefinition> defs,
  required Set<String> unlockedIds,
  String userId = 'u1',
}) {
  return ProviderScope(
    overrides: [
      achievementDefinitionsProvider.overrideWith((_) async => defs),
      userUnlockedAchievementIdsProvider(userId)
          .overrideWith((_) => Stream.value(unlockedIds)),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: ProfileAchievementsSection(userId: userId),
      ),
    ),
  );
}

void main() {
  group('ProfileAchievementsSection', () {
    testWidgets('renders count and empty hint when nothing unlocked',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          defs: [_def('a10'), _def('a50')],
          unlockedIds: const {},
        ),
      );
      await tester.pump();

      expect(find.text('0 of 2 unlocked'), findsOneWidget);
      expect(find.textContaining('Log your first action'), findsOneWidget);
    });

    testWidgets('renders unlocked badges (no overflow chip when count <= max)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          defs: [_def('a10'), _def('a50'), _def('a100')],
          unlockedIds: const {'a10', 'a50'},
        ),
      );
      await tester.pump();

      expect(find.text('a10'), findsOneWidget);
      expect(find.text('a50'), findsOneWidget);
      expect(find.text('2 of 3 unlocked'), findsOneWidget);
      // No overflow chip should appear yet.
      expect(find.textContaining('+'), findsNothing);
    });

    testWidgets('shows "+N more" chip when unlocked > maxBadges',
        (tester) async {
      final defs = [
        for (var i = 0; i < 7; i++) _def('a$i'),
      ];
      await tester.pumpWidget(
        _wrap(
          defs: defs,
          unlockedIds: const {'a0', 'a1', 'a2', 'a3', 'a4'},
        ),
      );
      await tester.pump();

      // maxBadges defaults to 3 -> 5 unlocked -> "+2" chip.
      expect(find.text('+2'), findsOneWidget);
      expect(find.text('5 of 7 unlocked'), findsOneWidget);
    });

    testWidgets('tapping the card navigates to the Achievements route',
        (tester) async {
      const userId = 'u1';
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => Scaffold(
              body: ProfileAchievementsSection(userId: userId),
            ),
          ),
          GoRoute(
            path: AppRoutes.achievements,
            builder: (_, __) => const Scaffold(
              body: Text('ACHIEVEMENTS_SCREEN'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            achievementDefinitionsProvider
                .overrideWith((_) async => [_def('a10')]),
            userUnlockedAchievementIdsProvider(userId)
                .overrideWith((_) => Stream.value(const <String>{})),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(ProfileAchievementsSection));
      await tester.pumpAndSettle();

      expect(find.text('ACHIEVEMENTS_SCREEN'), findsOneWidget);
    });
  });
}
