import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/data/models/user_achievement_model.dart';
import 'package:seed_app/features/achievements/presentation/providers/achievement_providers.dart';
import 'package:seed_app/features/achievements/presentation/screens/achievements_screen.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_badge.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_detail_sheet.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';

AchievementDefinition _def(
  String id,
  AchievementCriteria criteria, {
  AchievementCategory category = AchievementCategory.action,
}) =>
    AchievementDefinition(
      id: id,
      category: category,
      iconName: 'emoji_events',
      bonusPoints: 100,
      criteria: criteria,
      nameEn: 'name-$id',
      nameJa: '',
      nameEs: '',
      descriptionEn: 'desc-$id',
      descriptionJa: '',
      descriptionEs: '',
    );

/// Definitions whose names wrap to two label lines in the badge
/// grid, exercising the tallest badge layout.
List<AchievementDefinition> _twoLineLabelDefs() => [
      for (var i = 0; i < 4; i++)
        AchievementDefinition(
          id: 'a$i',
          category: AchievementCategory.action,
          iconName: 'emoji_events',
          bonusPoints: 100,
          criteria: const AchievementCriteria.actionCount(count: 10),
          nameEn: 'Wrapping Two Line Name $i',
          nameJa: '',
          nameEs: '',
          descriptionEn: 'desc',
          descriptionJa: '',
          descriptionEs: '',
        ),
    ];

Widget _wrap({
  required AppUserModel user,
  required List<AchievementDefinition> defs,
  required Set<String> unlockedIds,
}) {
  final records = [
    for (final id in unlockedIds)
      UserAchievementModel(id: id, unlockedAt: DateTime(2026, 5)),
  ];
  return ProviderScope(
    overrides: [
      currentUserProvider.overrideWith((_) => Stream.value(user)),
      achievementDefinitionsProvider.overrideWith((_) async => defs),
      userAchievementsProvider(user.uid)
          .overrideWith((_) => Stream.value(records)),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const AchievementsScreen(),
    ),
  );
}

void main() {
  group('AchievementsScreen smoke', () {
    testWidgets('renders progress header, Next Up, Unlocked, and Locked',
        (tester) async {
      // Default 800x600 is too short for all four sections; give the
      // ListView room so every header is built rather than lazily
      // skipped.
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const user = AppUserModel(
        uid: 'u1',
        email: 'e',
        totalActionsCount: 4,
        currentStreak: 4,
      );
      final defs = [
        _def('a10', const AchievementCriteria.actionCount(count: 10)),
        _def(
          'streak5',
          const AchievementCriteria.streakDays(days: 5),
          category: AchievementCategory.streak,
        ),
        _def(
          'co2_1kg',
          const AchievementCriteria.co2Saved(grams: 1000),
          category: AchievementCategory.milestone,
        ),
      ];

      await tester.pumpWidget(
        _wrap(user: user, defs: defs, unlockedIds: const {'a10'}),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 of 3 unlocked'), findsOneWidget);
      expect(find.text('Next Up'), findsOneWidget);
      expect(find.text('Unlocked'), findsOneWidget);
      expect(find.text('Locked'), findsOneWidget);
      expect(find.text('name-streak5'), findsWidgets);
    });

    testWidgets('hides Next Up + Locked sections when everything is unlocked',
        (tester) async {
      const user = AppUserModel(uid: 'u1', email: 'e');
      final defs = [
        _def('a10', const AchievementCriteria.actionCount(count: 10)),
      ];

      await tester.pumpWidget(
        _wrap(user: user, defs: defs, unlockedIds: const {'a10'}),
      );
      await tester.pumpAndSettle();

      expect(find.text('Next Up'), findsNothing);
      expect(find.text('Locked'), findsNothing);
      expect(find.text('Unlocked'), findsOneWidget);
    });

    testWidgets(
        'badge grid does not overflow on a narrow phone with '
        'two-line labels', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const user = AppUserModel(uid: 'u1', email: 'e');

      await tester.pumpWidget(
        _wrap(
          user: user,
          defs: _twoLineLabelDefs(),
          unlockedIds: const {'a0', 'a1'},
        ),
      );
      await tester.pumpAndSettle();

      // Overflow surfaces as a FlutterError during layout; pumping
      // cleanly means the grid fits.
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'badge grid does not overflow under accessibility text '
        'scaling', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.binding.setSurfaceSize(const Size(390, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const user = AppUserModel(uid: 'u1', email: 'e');

      await tester.pumpWidget(
        _wrap(
          user: user,
          defs: _twoLineLabelDefs(),
          unlockedIds: const {'a0', 'a1'},
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'tapping an unlocked badge opens the detail sheet with the '
        'unlock date', (tester) async {
      const user = AppUserModel(uid: 'u1', email: 'e');
      final defs = [
        _def('a10', const AchievementCriteria.actionCount(count: 10)),
      ];

      await tester.pumpWidget(
        _wrap(user: user, defs: defs, unlockedIds: const {'a10'}),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AchievementBadge));
      await tester.pumpAndSettle();

      expect(find.byType(AchievementDetailSheet), findsOneWidget);
      expect(find.text('desc-a10'), findsOneWidget);
      expect(find.text('Reward: +100 points'), findsOneWidget);
      expect(find.text('Unlocked on May 1, 2026'), findsOneWidget);
    });

    testWidgets('tapping a locked badge opens the detail sheet with progress',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      const user = AppUserModel(
        uid: 'u1',
        email: 'e',
        totalActionsCount: 4,
      );
      final defs = [
        _def('a10', const AchievementCriteria.actionCount(count: 10)),
      ];

      await tester.pumpWidget(
        _wrap(user: user, defs: defs, unlockedIds: const {}),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AchievementBadge));
      await tester.pumpAndSettle();

      expect(find.byType(AchievementDetailSheet), findsOneWidget);
      expect(find.text('Reward: +100 points'), findsOneWidget);
      expect(find.text('4 / 10'), findsWidgets);
      expect(find.textContaining('Unlocked on'), findsNothing);
    });

    testWidgets('info button in the app bar opens the explainer sheet',
        (tester) async {
      const user = AppUserModel(uid: 'u1', email: 'e');

      await tester.pumpWidget(
        _wrap(user: user, defs: const [], unlockedIds: const {}),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle();

      expect(find.text('About Achievements'), findsOneWidget);
      expect(find.textContaining('bonus points'), findsOneWidget);
    });
  });

  group('achievementStateFromUser', () {
    test('copies aggregate counters and filters SDGs by count > 0', () {
      const user = AppUserModel(
        uid: 'u1',
        email: 'e',
        totalActionsCount: 12,
        totalCo2Grams: 4000,
        currentStreak: 3,
        level: 4,
        categoryActionCounts: {'recycling': 7, 'food': 5},
        sdgStats: {
          '11': {'count': 3, 'co2': 600},
          '13': {'count': 0, 'co2': 0},
        },
      );

      final state = achievementStateFromUser(user);

      expect(state.totalActionsCount, 12);
      expect(state.totalCo2Grams, 4000);
      expect(state.currentStreak, 3);
      expect(state.level, 4);
      expect(state.categoryActionCounts, {'recycling': 7, 'food': 5});
      expect(
        state.supportedSdgIds,
        {'11'},
        reason: 'SDG 13 has count=0 and must be filtered out',
      );
    });

    test('exposed maps are unmodifiable', () {
      const user = AppUserModel(
        uid: 'u1',
        email: 'e',
        categoryActionCounts: {'food': 1},
      );
      final state = achievementStateFromUser(user);

      expect(
        () => state.categoryActionCounts['x'] = 99,
        throwsUnsupportedError,
      );
      expect(
        () => state.supportedSdgIds.add('99'),
        throwsUnsupportedError,
      );
    });
  });
}
