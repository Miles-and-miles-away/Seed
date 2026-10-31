import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

import '../../helpers/test_helpers.dart';

const _body = '今日は近所の人や地域の活動を手伝おう';
const _link = '詳しくはこちらをご覧ください';

void main() {
  testWidgets('rich text keeps the link tap action and clean labels', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final recognizer = TapGestureRecognizer()..onTap = () {};
    addTearDown(recognizer.dispose);

    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('ja'),
        scaffold: true,
        child: Center(
          child: PhraseText.rich(
            TextSpan(
              text: _body,
              children: [TextSpan(text: _link, recognizer: recognizer)],
            ),
          ),
        ),
      ),
    );

    final rich = tester.widget<RichText>(find.byType(RichText));
    expect(
      rich.text.toPlainText(includeSemanticsLabels: false),
      contains(wordJoiner),
    );
    expect(
      find.semantics.byPredicate(
        (node) =>
            node.label == _link &&
            node.getSemanticsData().hasAction(SemanticsAction.tap),
      ),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel(RegExp(wordJoiner)), findsNothing);
    expect(find.text('$_body$_link'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('plain text exposes the clean string', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      createTestWidget(
        locale: const Locale('ja'),
        scaffold: true,
        child: const Center(child: PhraseText(_body)),
      ),
    );

    final rich = tester.widget<RichText>(find.byType(RichText));
    expect(
      rich.text.toPlainText(includeSemanticsLabels: false),
      contains(wordJoiner),
    );
    expect(find.bySemanticsLabel(_body), findsOneWidget);
    expect(find.text(_body), findsOneWidget);
    semantics.dispose();
  });
}
