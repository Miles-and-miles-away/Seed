import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_progress.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_detail_sheet.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_progress_bar.dart';

const _def = AchievementDefinition(
  id: 'a10',
  category: AchievementCategory.action,
  iconName: 'emoji_events',
  bonusPoints: 100,
  criteria: AchievementCriteria.actionCount(count: 10),
  nameEn: 'Getting Started',
  nameJa: '',
  nameEs: '',
  descriptionEn: 'Log 10 actions',
  descriptionJa: '',
  descriptionEs: '',
);

Widget _wrap(Widget sheet) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(body: sheet),
  );
}

void main() {
  group('AchievementDetailSheet', () {
    testWidgets('always shows name, criteria description, and reward',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AchievementDetailSheet(definition: _def, isUnlocked: false),
        ),
      );

      expect(find.text('Getting Started'), findsOneWidget);
      expect(find.text('Log 10 actions'), findsOneWidget);
      expect(find.text('Reward: +100 points'), findsOneWidget);
    });

    testWidgets('locked with numeric criteria shows the progress bar',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AchievementDetailSheet(
            definition: _def,
            isUnlocked: false,
            progress: AchievementProgress(
              current: 4,
              target: 10,
              hasProgress: true,
            ),
          ),
        ),
      );

      expect(find.byType(AchievementProgressBar), findsOneWidget);
      expect(find.text('4 / 10'), findsOneWidget);
      expect(find.textContaining('Unlocked on'), findsNothing);
    });

    testWidgets('unlocked shows the unlock date and no progress bar',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          AchievementDetailSheet(
            definition: _def,
            isUnlocked: true,
            unlockedAt: DateTime(2026, 5),
          ),
        ),
      );

      expect(find.text('Unlocked on May 1, 2026'), findsOneWidget);
      expect(find.byType(AchievementProgressBar), findsNothing);
    });

    testWidgets('unlocked without a date omits the date line', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AchievementDetailSheet(definition: _def, isUnlocked: true),
        ),
      );

      expect(find.textContaining('Unlocked on'), findsNothing);
    });
  });
}
