import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_log_confirmation_dialog.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_science_bottom_sheet.dart';
import 'package:seed_app/shared/widgets/info_affordance.dart';

import '../../../../helpers/test_helpers.dart';

const _action = ActionModel(
  id: 'transport-bike',
  nameEn: 'Bike to work',
  nameJa: '自転車通勤',
  category: 'transport',
  points: 10,
);

const _description = 'Choose a plant-based meal instead of beef today';

const _mealAction = ActionModel(
  id: 'skip_high_impact_food',
  nameEn: 'Skip High-Impact Meal',
  nameJa: '高インパクトの食事をスキップ',
  nameEs: 'Evitar comida de alto impacto',
  category: 'food',
  points: 37,
  co2Grams: 3700,
  descriptionEn: 'Choose a plant-based meal instead of beef or lamb today',
  descriptionJa: '今日は牛肉やラム肉の代わりに植物性の食事を選択する',
  descriptionEs:
      'Elegir una comida vegetal en vez de carne de res o cordero hoy',
  descriptionLongEn: 'The science.',
);

void main() {
  testWidgets('note field truncates emoji-heavy input to the UTF-16 unit cap', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(scaffold: true, child: const SizedBox()),
    );

    final future = ActionLogConfirmationDialog.show(
      tester.element(find.byType(Scaffold)),
      action: _action,
      languageCode: 'en',
    );
    await tester.pumpAndSettle();

    // 150 emoji are 150 graphemes (within maxLength) but 300 UTF-16
    // units -- over the Firestore rule's 200-unit cap, so the UI must
    // truncate or the whole action-log write is rejected server-side.
    const emoji = '\u{1F600}';
    await tester.enterText(find.byType(TextField), emoji * 150);

    final field = tester.widget<TextField>(find.byType(TextField));
    final text = field.controller!.text;
    expect(text.length, lessThanOrEqualTo(AppConstants.maxNoteLength));
    expect(text, emoji * 100);

    // Confirm so the returned note reflects the truncated value.
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    final result = await future;
    expect(result?.confirmed, isTrue);
    expect(result?.note?.length, AppConstants.maxNoteLength);
  });

  group('the science panel', () {
    Future<void> showDialog(WidgetTester tester, {String long = ''}) async {
      await tester.pumpWidget(
        createTestWidget(scaffold: true, child: const SizedBox()),
      );
      unawaited(
        ActionLogConfirmationDialog.show(
          tester.element(find.byType(Scaffold)),
          action: _action.copyWith(
            descriptionEn: _description,
            descriptionLongEn: long,
          ),
          languageCode: 'en',
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> expectScienceOpens(WidgetTester tester, Finder target) async {
      await tester.tap(target);
      await tester.pumpAndSettle();
      expect(find.byType(ActionScienceBottomSheet), findsOneWidget);
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
    }

    testWidgets('the info button opens the science sheet', (tester) async {
      await showDialog(tester, long: 'The science.');

      expect(find.byIcon(Icons.expand_more), findsNothing);
      await expectScienceOpens(tester, find.byType(InfoIconButton));
    });

    testWidgets('tapping the panel opens the science sheet too', (
      tester,
    ) async {
      await showDialog(tester, long: 'The science.');

      await expectScienceOpens(tester, find.text(_description));
    });

    testWidgets('the panel is not a second control for assistive tech', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await showDialog(tester, long: 'The science.');

      final panel = tester
          .getSemantics(find.text(_description))
          .getSemanticsData();
      expect(panel.hasAction(SemanticsAction.tap), isFalse);
      expect(panel.hasAction(SemanticsAction.focus), isFalse);
      final button = tester
          .getSemantics(find.byType(InfoIconButton))
          .getSemanticsData();
      expect(button.tooltip, 'About this action');
      expect(button.hasAction(SemanticsAction.tap), isTrue);
      semantics.dispose();
    });

    testWidgets('no long text means no panel and no glyph', (tester) async {
      await showDialog(tester);

      expect(find.text(_description), findsOneWidget);
      expect(find.byType(InfoGlyph), findsNothing);
      expect(
        find.ancestor(
          of: find.text(_description),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
    });
  });

  stressWidthLayoutTests(
    (locale, theme) => createTestWidget(
      locale: locale,
      theme: theme,
      scaffold: true,
      child: const SizedBox(),
    ),
    widths: [testPhoneWidths.first, testPhoneWidths.last],
    act: (tester, locale) async {
      unawaited(
        ActionLogConfirmationDialog.show(
          tester.element(find.byType(Scaffold)),
          action: _mealAction,
          languageCode: locale.languageCode,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(InfoIconButton), findsOneWidget);
    },
  );
}
