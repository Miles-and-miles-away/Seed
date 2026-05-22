import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/data/models/achievement_category.dart';
import 'package:seed_app/features/achievements/data/models/achievement_criteria_model.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/presentation/screens/achievement_celebration_screen.dart';

AchievementDefinition _def(
  String id, {
  int bonusPoints = 100,
  String nameEn = 'Achievement Name',
  String descriptionEn = 'Achievement description',
}) {
  return AchievementDefinition(
    id: id,
    category: AchievementCategory.action,
    iconName: 'emoji_events',
    bonusPoints: bonusPoints,
    criteria: const AchievementCriteria.actionCount(count: 10),
    nameEn: nameEn,
    nameJa: '',
    nameEs: '',
    descriptionEn: descriptionEn,
    descriptionJa: '',
    descriptionEs: '',
  );
}

class _CelebrationLauncher extends StatelessWidget {
  const _CelebrationLauncher({required this.definitions});

  final List<AchievementDefinition> definitions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => showAchievementCelebrations(
            context,
            definitions: definitions,
          ),
          child: const Text('launch'),
        ),
      ),
    );
  }
}

Widget _harness(List<AchievementDefinition> definitions) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: _CelebrationLauncher(definitions: definitions),
  );
}

void main() {
  group('AchievementCelebrationScreen (widget render)', () {
    testWidgets('renders title, name, description, bonus, and tap hint',
        (tester) async {
      var dismissed = false;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: AchievementCelebrationScreen(
            definition: _def(
              'a',
              bonusPoints: 150,
              nameEn: 'One Week Strong',
              descriptionEn: 'Maintain a 7-day streak',
            ),
            onDismiss: () => dismissed = true,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Achievement Unlocked!'), findsOneWidget);
      expect(find.text('One Week Strong'), findsOneWidget);
      expect(find.text('Maintain a 7-day streak'), findsOneWidget);
      expect(find.text('+150 points!'), findsOneWidget);
      expect(find.text('Tap to continue'), findsOneWidget);
      // Queue indicator hidden when nothing else is queued.
      expect(find.textContaining('more queued'), findsNothing);
      expect(dismissed, isFalse);
    });

    testWidgets('shows "+N more queued" when more follow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: AchievementCelebrationScreen(
            definition: _def('a'),
            onDismiss: () {},
            remainingInQueue: 2,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('+2 more queued'), findsOneWidget);
    });

    testWidgets('tap fires onDismiss', (tester) async {
      var dismissed = 0;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: AchievementCelebrationScreen(
            definition: _def('a'),
            onDismiss: () => dismissed++,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));

      await tester.tapAt(const Offset(20, 20));
      expect(dismissed, 1);
    });
  });

  group('showAchievementCelebrations (queue)', () {
    testWidgets('walks through every definition in order', (tester) async {
      final defs = [
        _def('first', nameEn: 'First Up'),
        _def('second', nameEn: 'Second Up'),
        _def('third', nameEn: 'Third Up'),
      ];

      await tester.pumpWidget(_harness(defs));
      await tester.tap(find.text('launch'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('First Up'), findsOneWidget);
      expect(find.text('+2 more queued'), findsOneWidget);

      await tester.tapAt(const Offset(20, 20));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Second Up'), findsOneWidget);
      expect(find.text('+1 more queued'), findsOneWidget);

      await tester.tapAt(const Offset(20, 20));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Third Up'), findsOneWidget);
      expect(find.textContaining('more queued'), findsNothing);

      await tester.tapAt(const Offset(20, 20));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Third Up'), findsNothing);
      expect(find.text('Achievement Unlocked!'), findsNothing);
    });

    testWidgets('empty list is a no-op (no dialog opens)', (tester) async {
      await tester.pumpWidget(_harness(const []));
      await tester.tap(find.text('launch'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Achievement Unlocked!'), findsNothing);
    });
  });
}
