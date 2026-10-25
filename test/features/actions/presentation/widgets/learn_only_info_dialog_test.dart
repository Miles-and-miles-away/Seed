import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_science_bottom_sheet.dart';
import 'package:seed_app/features/actions/presentation/widgets/learn_only_info_dialog.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

import '../../../../helpers/test_helpers.dart';

const _description = 'Choose a plant-based meal instead of beef today';

Widget _wrap() => createTestWidget(
  overrides: [
    sdgGoalsDataProvider.overrideWith(
      (_) async => const SdgGoalsData(goals: [], goalMap: {}),
    ),
  ],
  scaffold: true,
  child: const SizedBox(),
);

void main() {
  testWidgets('displays the action name and a dismiss button', (tester) async {
    await tester.pumpWidget(_wrap());

    final future = showDialog<void>(
      context: tester.element(find.byType(Scaffold)),
      builder: (_) => const LearnOnlyInfoDialog(
        action: ActionModel(
          id: 'learn-sign',
          nameEn: 'Sign petition',
          nameJa: 'サインする',
          category: 'advocacy',
          points: 0,
          isLearnOnly: true,
          relatedSdgs: ['13'],
        ),
        languageCode: 'en',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign petition'), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);

    // Dismiss so the showDialog future resolves and the test can finish.
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    await future;
  });

  testWidgets('pressing Dismiss closes the dialog', (tester) async {
    await tester.pumpWidget(_wrap());

    final future = showDialog<void>(
      context: tester.element(find.byType(Scaffold)),
      builder: (_) => const LearnOnlyInfoDialog(
        action: ActionModel(
          id: 'learn',
          nameEn: 'Learn',
          nameJa: '',
          category: 'learning',
          points: 0,
          isLearnOnly: true,
        ),
        languageCode: 'en',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    await future;
  });

  Future<void> showLearnOnly(WidgetTester tester, {String long = ''}) async {
    await tester.pumpWidget(_wrap());
    unawaited(
      LearnOnlyInfoDialog.show(
        tester.element(find.byType(Scaffold)),
        action: ActionModel(
          id: 'learn-meal',
          nameEn: 'Plant-based meal',
          nameJa: '',
          category: 'consumption',
          points: 0,
          isLearnOnly: true,
          descriptionEn: _description,
          descriptionLongEn: long,
        ),
        languageCode: 'en',
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a long description is one button that opens the science', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await showLearnOnly(tester, long: 'The science.');

    final text = tester.widget<Text>(find.text(_description));
    expect(text.style?.decoration, isNot(TextDecoration.underline));
    expect(
      text.style?.color,
      Theme.of(
        tester.element(find.text(_description)),
      ).colorScheme.onSurfaceVariant,
    );
    final node = tester.getSemantics(find.text(_description));
    expect(node.label, _description);
    expect(node.hint, 'About this action');
    expect(node.flagsCollection.isButton, isTrue);
    expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);

    for (final target in [
      find.text(_description),
      find.byIcon(Icons.info_outline),
    ]) {
      await tester.tap(target);
      await tester.pumpAndSettle();
      expect(find.byType(ActionScienceBottomSheet), findsOneWidget);
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
    }
    semantics.dispose();
  });

  testWidgets('a short description has no glyph', (tester) async {
    await showLearnOnly(tester);

    expect(find.text(_description), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsNothing);
  });

  stressWidthLayoutTests(
    (locale, theme) => createTestWidget(
      overrides: [
        sdgGoalsDataProvider.overrideWith(
          (_) async => const SdgGoalsData(goals: [], goalMap: {}),
        ),
      ],
      locale: locale,
      theme: theme,
      scaffold: true,
      child: const SizedBox(),
    ),
    widths: [testPhoneWidths.first, testPhoneWidths.last],
    act: (tester, locale) async {
      unawaited(
        LearnOnlyInfoDialog.show(
          tester.element(find.byType(Scaffold)),
          action: const ActionModel(
            id: 'skip_high_impact_food',
            nameEn: 'Skip High-Impact Meal',
            nameJa: '高インパクトの食事をスキップ',
            nameEs: 'Evitar comida de alto impacto',
            category: 'food',
            points: 0,
            isLearnOnly: true,
            descriptionEn:
                'Choose a plant-based meal instead of beef or lamb today',
            descriptionJa: '今日は牛肉やラム肉の代わりに植物性の食事を選択する',
            descriptionEs:
                'Elegir una comida vegetal en vez de carne de res o cordero hoy',
            descriptionLongEn: 'The science.',
          ),
          languageCode: locale.languageCode,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    },
  );
}
