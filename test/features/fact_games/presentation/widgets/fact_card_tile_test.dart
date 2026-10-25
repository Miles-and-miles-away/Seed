import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/fact_games/domain/fact_pairs_board.dart';
import 'package:seed_app/features/fact_games/presentation/widgets/fact_card_tile.dart';

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

/// Clean-text offsets where [wrapped] carries no joiner.
Set<int> _unjoined(String wrapped) {
  final free = <int>{};
  var offset = 0;
  var joined = false;
  for (final unit in wrapped.split('')) {
    if (unit == wordJoiner) {
      joined = true;
      continue;
    }
    if (!joined) free.add(offset);
    joined = false;
    offset++;
  }
  return free;
}

/// Offsets inside [title] where a JA line may break: between phrases,
/// and anywhere inside a phrase too long to be joined at [cap].
Set<int> _jaTitleBreaks(String title, int cap) {
  final allowed = <int>{};
  var offset = 0;
  for (final phrase in jaPhrases(title)) {
    if (phrase.length > cap) {
      for (var i = 1; i < phrase.length; i++) {
        allowed.add(offset + i);
      }
    }
    allowed.add(offset += phrase.length);
  }
  return allowed;
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

  group('every playable face breaks only between words', () {
    for (final (language, widths) in [
      ('en', [320.0, 360.0]),
      ('es', [320 * robotoToSfWidthFactor, 320.0, 360.0]),
      ('ja', [320.0, 360.0]),
    ]) {
      for (final width in widths) {
        for (final scale in [1.0, 2.0]) {
          testWidgets('$language at ${width.round()}pt, text scale $scale', (
            tester,
          ) async {
            final columns = scale > 1 ? factCardWideColumns : factCardColumns;
            final aspect = scale > 1 ? factCardWideAspect : 1.0;
            final faceWidth =
                (width - 2 * spacingXxl - (columns - 1) * spacingSm) / columns;
            final cards = [
              for (final fact in playable) ...[
                FactCard(
                  fact: fact,
                  face: FactFace.title,
                  text: fact.name(language),
                ),
                FactCard(
                  fact: fact,
                  face: FactFace.figure,
                  text: fact.keyFigure(language)!,
                ),
              ],
            ];
            sizeViewport(tester, size: Size(width, 800));
            tester.platformDispatcher.textScaleFactorTestValue = scale;
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );
            await tester.pumpWidget(
              MaterialApp(
                locale: Locale(language),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: language == 'ja'
                    ? ThemeData(fontFamily: 'FlutterTest')
                    : null,
                home: Material(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        for (final (i, card) in cards.indexed)
                          SizedBox(
                            key: ValueKey(i),
                            width: faceWidth,
                            height: faceWidth / aspect,
                            child: FactCardTile(
                              card: card,
                              state: FactCardState.faceUp,
                              index: i,
                              total: cards.length,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);

            final context = tester.element(find.byType(Wrap));
            final title = Theme.of(context).textTheme.labelMedium!;
            final cap = phraseCap(
              faceWidth - 2 * spacingSm,
              scale * title.fontSize! + (title.letterSpacing ?? 0),
            );
            for (final (i, card) in cards.indexed) {
              final lines = renderedLines(
                tester,
                find
                    .descendant(
                      of: find.byKey(ValueKey(i)),
                      matching: find.byType(RichText),
                    )
                    .first,
              );
              expect(lines.join(), card.text);
              for (var l = 1; l < lines.length; l++) {
                final before = lines[l - 1].characters.last;
                final after = lines[l].characters.first;
                expect(
                  _latinAlnum.hasMatch(before) && _latinAlnum.hasMatch(after),
                  isFalse,
                  reason: '$lines',
                );
              }
              if (language != 'ja') continue;
              final allowed = card.face == FactFace.figure
                  ? _unjoined(
                      jaFigureWrap(card.text, locale: const Locale('ja')),
                    )
                  : _jaTitleBreaks(card.text, cap);
              expect(
                allowed.containsAll(_breaks(lines)),
                isTrue,
                reason: '$lines',
              );
            }
          });
        }
      }
    }
  });
}
