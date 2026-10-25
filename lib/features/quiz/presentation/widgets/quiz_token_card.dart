import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/quiz/presentation/quiz_cards.dart';
import 'package:seed_app/shared/domain/quiz_deck.dart';
import 'package:seed_app/shared/widgets/info_affordance.dart';
import 'package:seed_app/shared/widgets/no_word_break.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

const _cardMargin = 4.0;
const _cardInset = _cardMargin + spacingLg;

/// The width a token's texts lay out at, for a token [width] wide.
double quizTokenTextWidth(double width) => width - 2 * _cardInset;

/// A token's face: names until the answer is in, then the figure, and
/// an info button last. Its texts leave semantics to the token's label.
class QuizTokenCard extends StatelessWidget {
  const QuizTokenCard({
    required this.card,
    required this.domain,
    required this.revealed,
    required this.onInfo,
    required this.width,
    this.lifted = false,
    super.key,
  });

  /// The token's full width, card margin included.
  final double width;
  final QuizCard card;
  final QuizDomain domain;
  final bool revealed;
  final VoidCallback onInfo;

  /// Raised while the finger is on it.
  final bool lifted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final textWidth = quizTokenTextWidth(width);
    Widget text(String data, TextStyle? style) => NoWordBreak(
      child: PhraseText(
        data,
        textAlign: TextAlign.center,
        minLineWidth: textWidth,
        style: style,
      ),
    );
    final noteStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Card(
      margin: const EdgeInsets.all(_cardMargin),
      semanticContainer: false,
      elevation: lifted ? 8 : null,
      color: domain.color.withValues(alpha: opacityLight),
      child: Padding(
        padding: const EdgeInsets.all(spacingLg),
        // After an empty child: texts centred, the info button at the foot.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            ExcludeSemantics(
              child: Column(
                children: [
                  text(
                    card.title,
                    theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (card.subtitle.isNotEmpty) text(card.subtitle, noteStyle),
                  if (revealed) ...[
                    const SizedBox(height: spacingSm),
                    text(
                      card.revealText,
                      theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: domain.ink(theme.brightness, large: true),
                      ),
                    ),
                    if (card.revealDetail.isNotEmpty)
                      text(card.revealDetail, noteStyle),
                  ],
                ],
              ),
            ),
            InfoIconButton(
              tooltip: l10n.quizItemInfoTooltip(card.title),
              onPressed: onInfo,
            ),
          ],
        ),
      ),
    );
  }
}
