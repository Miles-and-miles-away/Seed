import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_progress.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_card.dart';

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
  id: 'actions_100',
  category: AchievementCategory.action,
  iconName: 'military_tech',
  bonusPoints: 500,
  criteria: AchievementCriteria.actionCount(count: 100),
  nameEn: 'Century Club',
  nameJa: '',
  nameEs: '',
  descriptionEn: 'Log 100 actions',
  descriptionJa: '',
  descriptionEs: '',
);

void main() {
  group('AchievementCard', () {
    testWidgets('shows name, description, and progress bar', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AchievementCard(
            definition: _def,
            progress: AchievementProgress(
              current: 78,
              target: 100,
              hasProgress: true,
            ),
            isUnlocked: false,
          ),
        ),
      );

      expect(find.text('Century Club'), findsOneWidget);
      expect(find.text('Log 100 actions'), findsOneWidget);
      expect(find.text('78 / 100'), findsOneWidget);
      expect(find.byIcon(Icons.military_tech), findsOneWidget);
    });

    testWidgets('uses the unlocked icon styling when isUnlocked is true',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AchievementCard(
            definition: _def,
            progress: AchievementProgress(
              current: 100,
              target: 100,
              hasProgress: true,
            ),
            isUnlocked: true,
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.military_tech));
      final containerBg = tester
          .widget<Container>(
            find
                .ancestor(
                  of: find.byIcon(Icons.military_tech),
                  matching: find.byType(Container),
                )
                .first,
          )
          .decoration! as BoxDecoration;

      final theme = Theme.of(tester.element(find.byType(AchievementCard)));
      expect(iconWidget.color, theme.colorScheme.onPrimaryContainer);
      expect(containerBg.color, theme.colorScheme.primaryContainer);
    });

    testWidgets('omits progress bar for binary criteria', (tester) async {
      const special = AchievementDefinition(
        id: 'first_action',
        category: AchievementCategory.special,
        iconName: 'rocket_launch',
        bonusPoints: 50,
        criteria: AchievementCriteria.special(specialType: 'first_action'),
        nameEn: 'First Step',
        nameJa: '',
        nameEs: '',
        descriptionEn: 'Log your first action',
        descriptionJa: '',
        descriptionEs: '',
      );
      await tester.pumpWidget(
        _wrap(
          const AchievementCard(
            definition: special,
            progress: AchievementProgress.binary(),
            isUnlocked: false,
          ),
        ),
      );

      expect(find.text('First Step'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });
  });
}
