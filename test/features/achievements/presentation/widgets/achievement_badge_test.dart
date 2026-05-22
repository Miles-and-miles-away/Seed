import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_badge.dart';

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

const _def = AchievementDefinition(
  id: 'streak_7',
  category: AchievementCategory.streak,
  iconName: 'local_fire_department',
  bonusPoints: 150,
  criteria: AchievementCriteria.streakDays(days: 7),
  nameEn: 'One Week Strong',
  nameJa: '一週間連続',
  nameEs: '',
  descriptionEn: '',
  descriptionJa: '',
  descriptionEs: '',
);

void main() {
  group('AchievementBadge', () {
    testWidgets('renders localized name', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AchievementBadge(definition: _def, isUnlocked: true),
        ),
      );
      expect(find.text('One Week Strong'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });

    testWidgets('falls back to a default icon for unknown iconName',
        (tester) async {
      const odd = AchievementDefinition(
        id: 'x',
        category: AchievementCategory.action,
        iconName: 'not_a_real_icon',
        bonusPoints: 1,
        criteria: AchievementCriteria.actionCount(count: 1),
        nameEn: 'Mystery',
        nameJa: '',
        nameEs: '',
        descriptionEn: '',
        descriptionJa: '',
        descriptionEs: '',
      );
      await tester.pumpWidget(
        _wrap(const AchievementBadge(definition: odd, isUnlocked: false)),
      );
      // emoji_events is the fallback in achievementIconFor.
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('invokes onTap when provided', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          AchievementBadge(
            definition: _def,
            isUnlocked: true,
            onTap: () => taps++,
          ),
        ),
      );
      await tester.tap(find.byType(InkWell));
      expect(taps, 1);
    });
  });
}
