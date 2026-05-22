import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_checker.dart';
import 'package:seed_app/features/achievements/presentation/widgets/next_up_section.dart';

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

AchievementDefinition _def(
  String id,
  AchievementCriteria criteria, {
  AchievementCategory category = AchievementCategory.action,
}) {
  return AchievementDefinition(
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
}

AchievementUserState _state({
  int totalActionsCount = 0,
  int currentStreak = 0,
  int totalCo2Grams = 0,
}) {
  return AchievementUserState(
    totalActionsCount: totalActionsCount,
    totalCo2Grams: totalCo2Grams,
    currentStreak: currentStreak,
    level: 1,
    categoryActionCounts: const {},
    supportedSdgIds: const {},
  );
}

void main() {
  group('NextUpSection', () {
    testWidgets('orders by progress fraction desc and caps at maxItems',
        (tester) async {
      final defs = [
        _def('far', const AchievementCriteria.actionCount(count: 1000)),
        _def(
          'close',
          const AchievementCriteria.streakDays(days: 5),
          category: AchievementCategory.streak,
        ),
        _def(
          'mid',
          const AchievementCriteria.co2Saved(grams: 1000),
          category: AchievementCategory.milestone,
        ),
        _def(
          'extra',
          const AchievementCriteria.actionCount(count: 10),
        ),
      ];

      await tester.pumpWidget(
        _wrap(
          NextUpSection(
            definitions: defs,
            unlockedIds: const {},
            // close: 4/5 = 0.80; mid: 500/1000 = 0.50;
            // extra: 5/10 = 0.50; far: 5/1000 = 0.005
            state: _state(
              totalActionsCount: 5,
              currentStreak: 4,
              totalCo2Grams: 500,
            ),
            maxItems: 2,
          ),
        ),
      );

      // First two cards by fraction should be 'close' and 'mid' (or
      // 'extra' tied at 0.50). 'far' must NOT appear.
      expect(find.text('name-close'), findsOneWidget);
      expect(find.text('name-far'), findsNothing);
    });

    testWidgets('excludes already-unlocked ids', (tester) async {
      final defs = [
        _def(
          'close',
          const AchievementCriteria.streakDays(days: 5),
          category: AchievementCategory.streak,
        ),
        _def(
          'unlocked',
          const AchievementCriteria.actionCount(count: 1),
        ),
      ];

      await tester.pumpWidget(
        _wrap(
          NextUpSection(
            definitions: defs,
            unlockedIds: const {'unlocked'},
            state: _state(totalActionsCount: 5, currentStreak: 4),
          ),
        ),
      );

      expect(find.text('name-close'), findsOneWidget);
      expect(find.text('name-unlocked'), findsNothing);
    });

    testWidgets('excludes special (binary) criteria', (tester) async {
      final defs = [
        _def(
          'first',
          const AchievementCriteria.special(specialType: 'first_action'),
          category: AchievementCategory.special,
        ),
      ];

      await tester.pumpWidget(
        _wrap(
          NextUpSection(
            definitions: defs,
            unlockedIds: const {},
            state: _state(),
          ),
        ),
      );

      expect(find.text('name-first'), findsNothing);
    });

    testWidgets('renders nothing when no candidates', (tester) async {
      await tester.pumpWidget(
        _wrap(
          NextUpSection(
            definitions: const [],
            unlockedIds: const {},
            state: _state(),
          ),
        ),
      );
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });
  });
}
