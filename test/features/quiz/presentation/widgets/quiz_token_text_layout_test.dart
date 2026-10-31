import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/energy/energy.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/quiz/quiz.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/shared/domain/quiz_deck.dart';

import '../../../../helpers/dataset_helpers.dart';
import '../../../../helpers/test_helpers.dart';

/// Every card the three decks can deal, as the screen builds it.
List<(QuizDomain, QuizCard)> _cards(String language) {
  final l10n = lookupAppLocalizations(Locale(language));
  final energy = rawDatasetRoot('data/app/energy_behaviors.json');
  final behaviors = datasetEntries(
    energy,
    'behaviors',
  ).map(EnergyBehavior.fromJson).toList();
  final anchor = behaviors.firstWhere(
    (b) => b.id == EnergyRankedTable.defaultAnchorId,
  );
  final metadata = energy['metadata'] as Map<String, dynamic>;
  return [
    for (final behavior in behaviors)
      if (behavior.carrier != EnergyCarrier.gas)
        (
          QuizDomain.energy,
          energyQuizCard(
            l10n,
            language,
            behavior,
            anchorKwh: EnergyCalculator.defaultPresetKwh(anchor),
            anchorPhrase: energyAnchorUnitPhrase(l10n, anchor.id),
            gridFactor: (metadata['grid_factor_g_per_kwh'] as num).toDouble(),
          ),
        ),
    for (final item in rawDatasetList(
      'data/app/food_items.json',
      'items',
    ).map(FoodItem.fromJson))
      if (item.sourceTier == 1 && item.defaultServing != null)
        (QuizDomain.food, foodQuizCard(l10n, language, item)),
    for (final mode in rawDatasetList(
      'data/app/transport_modes.json',
      'modes',
    ).map(TransportMode.fromJson))
      if (!mode.perVehicle)
        (QuizDomain.transport, transportQuizCard(l10n, language, mode)),
  ];
}

Widget _app(String language, Widget child) => MaterialApp(
  locale: Locale(language),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: language == 'ja' ? ThemeData(fontFamily: 'FlutterTest') : null,
  home: Material(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: spacingXxl),
      child: child,
    ),
  ),
);

void main() {
  setUpAll(loadTestFonts);

  testWidgets('a wider phone keeps a Japanese phrase on one line', (
    tester,
  ) async {
    // The device check found this split inside 給湯 at 411pt, with the
    // phrase cap sized for a 320pt token.
    const screen = 411.0;
    final tokenWidth = (screen - 2 * spacingXxl - spacingMd) / 2;
    sizeViewport(tester, size: const Size(screen, 800));
    final (domain, card) = _cards(
      'ja',
    ).firstWhere((entry) => entry.$2.id == 'energy:shower_electric');
    await tester.pumpWidget(
      _app(
        'ja',
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: tokenWidth,
            child: QuizTokenCard(
              card: card,
              domain: domain,
              revealed: true,
              width: tokenWidth,
              onInfo: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(renderedLines(tester, find.text(card.title)), ['シャワー', '（電気給湯）']);
  });

  for (final language in ['en', 'es', 'ja']) {
    // The stress width, and the Pixel width the device check ran at.
    for (final screen in [320.0, 411.0]) {
      for (final scale in [1.0, 1.3, 2.0]) {
        final at = '${screen.round()}pt in $language at text scale $scale';

        testWidgets('token text keeps its size and its words at $at', (
          tester,
        ) async {
          final width = language == 'es'
              ? screen * robotoToSfWidthFactor
              : screen;
          final tokenWidth = (width - 2 * spacingXxl - spacingMd) / 2;
          final textWidth = quizTokenTextWidth(tokenWidth);
          sizeViewport(tester, size: Size(width, 2400));
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          final cards = _cards(language);
          expect(cards.length, greaterThan(150));

          await tester.pumpWidget(
            _app(
              language,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (domain, card) in cards)
                    SizedBox(
                      key: ValueKey(card.id),
                      width: tokenWidth,
                      child: QuizTokenCard(
                        card: card,
                        domain: domain,
                        revealed: true,
                        width: tokenWidth,
                        onInfo: () {},
                      ),
                    ),
                ],
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);

          final bad = <String>[];
          for (final (_, card) in cards) {
            final token = find.byKey(ValueKey(card.id));
            for (final (text, shrink, needed) in noWordBreakScales(
              tester,
              token,
              language: language,
            )) {
              // A long run may shrink as far as it needs to, but the
              // phrase joins must not shrink it further; their letter
              // spacing may cost a pixel.
              if (shrink < needed - 0.015) {
                bad.add('${card.id}: "$text" shrinks to $shrink');
              }
            }
            final texts = find.descendant(
              of: token,
              matching: find.byType(RichText),
            );
            for (final element in texts.evaluate()) {
              final lines = renderedLines(
                tester,
                find.byElementPredicate((e) => e == element),
              );
              final style =
                  (element.renderObject! as RenderParagraph).text.style!;
              final glyph =
                  MediaQuery.textScalerOf(element).scale(style.fontSize!) +
                  (style.letterSpacing ?? 0);
              for (final b in breaksInsideWords(
                lines,
                language,
                maxPhrase: phraseCap(textWidth, glyph),
              )) {
                bad.add('${card.id}: $b');
              }
            }
          }
          expect(bad, isEmpty);
        });

        testWidgets('paired tokens reserve exactly the taller one at $at', (
          tester,
        ) async {
          final width = language == 'es'
              ? screen * robotoToSfWidthFactor
              : screen;
          final tokenWidth = (width - 2 * spacingXxl - spacingMd) / 2;
          sizeViewport(tester, size: Size(width, 2400));
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          final cards = _cards(language);

          for (final revealed in [false, true]) {
            Widget token((QuizDomain, QuizCard) entry) => QuizTokenCard(
              key: ValueKey(entry.$2.id),
              card: entry.$2,
              domain: entry.$1,
              revealed: revealed,
              width: tokenWidth,
              onInfo: () {},
            );

            await tester.pumpWidget(
              _app(
                language,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in cards)
                      SizedBox(width: tokenWidth, child: token(entry)),
                  ],
                ),
              ),
            );
            await tester.pumpAndSettle();
            final natural = {
              for (final (_, card) in cards)
                card.id: tester.getSize(find.byKey(ValueKey(card.id))).height,
            };

            // Each card beside the next, as the screen lays a round out.
            final pairs = [
              for (var i = 0; i + 1 < cards.length; i += 2)
                (cards[i], cards[i + 1]),
            ];
            await tester.pumpWidget(
              _app(
                language,
                Column(
                  children: [
                    for (final (a, b) in pairs)
                      QuizTokenPair(
                        key: ValueKey('${a.$2.id}|${b.$2.id}'),
                        gap: spacingMd,
                        left: token(a),
                        right: token(b),
                      ),
                  ],
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);

            final bad = <String>[];
            for (final (a, b) in pairs) {
              final row = tester
                  .getSize(find.byKey(ValueKey('${a.$2.id}|${b.$2.id}')))
                  .height;
              final taller = max(natural[a.$2.id]!, natural[b.$2.id]!);
              if ((row - taller).abs() > 0.5) {
                bad.add('${a.$2.id} | ${b.$2.id}: $row, not $taller');
              }
            }
            expect(bad, isEmpty, reason: 'revealed: $revealed');
          }
        });
      }
    }
  }
}
