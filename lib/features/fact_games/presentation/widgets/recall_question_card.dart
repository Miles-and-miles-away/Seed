import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/fact_games/domain/fact_recall_round.dart';
import 'package:seed_app/shared/widgets/no_word_break.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

const _bodyLineHeight = 1.5;

/// Narrowest width of text in the question card, on a 320pt phone.
const _cardTextMinWidth =
    phraseNarrowestScreenWidth - 2 * spacingXxl - 2 * spacingLg;

/// The fact's title and text: blanked before an answer, then in full
/// with the figure in bold.
class RecallQuestionCard extends StatelessWidget {
  const RecallQuestionCard({
    required this.question,
    required this.answered,
    super.key,
  });

  final RecallQuestion question;
  final bool answered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      height: _bodyLineHeight,
    );
    final spoken = answered
        ? question.revealed
        : question.revealed.replaceAll(
            question.answer,
            l10n.factRecallBlankSpoken,
          );
    final figure = jaFigureWrap(
      question.answer,
      locale: Localizations.localeOf(context),
    );
    final parts = question.revealed.split(question.answer);
    return Semantics(
      label: '${question.title}\n$spoken',
      excludeSemantics: true,
      child: Card(
        color: theme.colorScheme.surfaceContainerLow,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NoWordBreak(
                alignment: AlignmentDirectional.topStart,
                child: PhraseText(
                  question.title,
                  minLineWidth: _cardTextMinWidth,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: spacingSm),
              NoWordBreak(
                alignment: AlignmentDirectional.topStart,
                child: answered
                    ? PhraseText.rich(
                        TextSpan(
                          children: [
                            for (final (i, part) in parts.indexed) ...[
                              if (i > 0)
                                TextSpan(
                                  text: figure,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              TextSpan(text: part),
                            ],
                          ],
                        ),
                        minLineWidth: _cardTextMinWidth,
                        style: textStyle,
                      )
                    : PhraseText(
                        question.blanked,
                        minLineWidth: _cardTextMinWidth,
                        style: textStyle,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
