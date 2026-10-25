import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/recall_answer_button.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/recall_question_card.dart';

import '../../../../helpers/test_helpers.dart';

final _latinAlnum = RegExp('[A-Za-z0-9À-ÿ]');

/// Clean-text offsets at which [lines] break.
List<int> _breaks(List<String> lines) {
  final offsets = <int>[];
  var offset = 0;
  for (final line in lines.take(lines.length - 1)) {
    offsets.add(offset += line.length);
  }
  return offsets;
}

/// Offsets inside [figure] where a JA line may break.
Set<int> _figureBreaks(String figure) {
  final free = <int>{};
  var offset = 0;
  var joined = false;
  for (final unit in jaFigureWrap(
    figure,
    locale: const Locale('ja'),
  ).split('')) {
    if (unit == wordJoiner) {
      joined = true;
      continue;
    }
    if (!joined && offset > 0) free.add(offset);
    joined = false;
    offset++;
  }
  return free;
}

/// Problems with where [lines] break: inside a Latin word, or inside the
/// JA [figure] at [start] in the clean text other than where
/// [jaFigureWrap] lets it.
List<String> _badBreaks(
  List<String> lines, {
  required String language,
  required int start,
  required String figure,
}) => [
  for (var l = 1; l < lines.length; l++)
    if (_latinAlnum.hasMatch(lines[l - 1].characters.last) &&
        _latinAlnum.hasMatch(lines[l].characters.first))
      'word: $lines',
  if (language == 'ja')
    for (final offset in _breaks(lines))
      if (offset > start &&
          offset < start + figure.length &&
          !_figureBreaks(figure).contains(offset - start))
        'inside "$figure": $lines',
];

RecallQuestion _question(EcoFact fact, String language, String blank) {
  final figure = fact.keyFigure(language)!;
  final text = fact.fact(language);
  return RecallQuestion(
    fact: fact,
    title: fact.name(language),
    blanked: text.replaceAll(figure, blank),
    revealed: text,
    options: [figure, figure, figure],
    answerIndex: 0,
  );
}

void main() {
  late List<EcoFact> playable;

  setUpAll(() async {
    await loadTestFonts();
    final json =
        jsonDecode(File('data/app/eco_facts.json').readAsStringSync())
            as List<dynamic>;
    playable = [
      for (final e in json)
        if (EcoFact.fromJson(e as Map<String, dynamic>) case final fact
            when fact.isPlayable)
          fact,
    ];
  });

  Future<void> pumpAll(
    WidgetTester tester,
    String language,
    double width,
    double scale,
    List<Widget> children,
  ) async {
    sizeViewport(tester, size: Size(width, 800));
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(language),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: language == 'ja' ? ThemeData(fontFamily: 'FlutterTest') : null,
        home: Material(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: spacingXxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  for (final (language, widths) in [
    ('en', [320.0, 360.0]),
    ('es', [320 * robotoToSfWidthFactor, 320.0, 360.0]),
    ('ja', [320.0, 360.0]),
  ]) {
    for (final width in widths) {
      for (final scale in [1.0, 2.0]) {
        final at = '$language at ${width.round()}pt, text scale $scale';

        testWidgets('fact text breaks only between words, $at', (tester) async {
          final l10n = lookupAppLocalizations(Locale(language));
          final blank = l10n.factRecallBlank.characters.join(wordJoiner);
          final cleanBlank = l10n.factRecallBlank;
          final questions = [
            for (final fact in playable) _question(fact, language, blank),
          ];
          await pumpAll(tester, language, width, scale, [
            for (final (i, q) in questions.indexed) ...[
              RecallQuestionCard(
                key: ValueKey('blanked $i'),
                question: q,
                answered: false,
              ),
              RecallQuestionCard(
                key: ValueKey('revealed $i'),
                question: q,
                answered: true,
              ),
            ],
          ]);

          final bad = <String>[];
          for (final (i, q) in questions.indexed) {
            List<String> lines(String key, {int at = 1}) => renderedLines(
              tester,
              find
                  .descendant(
                    of: find.byKey(ValueKey('$key $i')),
                    matching: find.byType(RichText),
                  )
                  .at(at),
            );
            final title = lines('blanked', at: 0);
            expect(title.join(), q.title);
            bad.addAll(
              _badBreaks(title, language: language, start: 0, figure: ''),
            );
            final blanked = lines('blanked');
            expect(blanked.join(), stripWordJoiners(q.blanked));
            bad.addAll(
              _badBreaks(
                blanked,
                language: language,
                start: stripWordJoiners(q.blanked).indexOf(cleanBlank),
                figure: cleanBlank,
              ),
            );
            final revealed = lines('revealed');
            expect(revealed.join(), q.revealed);
            bad.addAll(
              _badBreaks(
                revealed,
                language: language,
                start: q.revealed.indexOf(q.answer),
                figure: q.answer,
              ),
            );
          }
          expect(bad, isEmpty);
        });

        testWidgets('answers break only between words, $at', (tester) async {
          final figures = {for (final f in playable) f.keyFigure(language)!};
          await pumpAll(tester, language, width, scale, [
            for (final figure in figures)
              for (final state in [
                RecallAnswerState.idle,
                RecallAnswerState.right,
              ])
                RecallAnswerButton(
                  key: ValueKey('$figure $state'),
                  figure: figure,
                  state: state,
                  onPressed: null,
                ),
          ]);

          final bad = <String>[];
          for (final figure in figures) {
            for (final state in [
              RecallAnswerState.idle,
              RecallAnswerState.right,
            ]) {
              final lines = renderedLines(
                tester,
                find.descendant(
                  of: find.byKey(ValueKey('$figure $state')),
                  matching: find.byType(Text),
                ),
              );
              expect(lines.join(), figure);
              bad.addAll(
                _badBreaks(lines, language: language, start: 0, figure: figure),
              );
            }
          }
          expect(bad, isEmpty);
        });
      }
    }
  }
}
