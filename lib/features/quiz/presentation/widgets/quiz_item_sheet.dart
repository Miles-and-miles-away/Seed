import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/text_styles.dart';
import 'package:seed_app/features/quiz/presentation/quiz_cards.dart';
import 'package:seed_app/shared/domain/quiz_deck.dart';
import 'package:seed_app/shared/widgets/info_sheet.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

/// What a token is. The figure waits for the answer, or it would give it away.
class QuizItemSheet extends StatelessWidget {
  const QuizItemSheet({
    required this.card,
    required this.domain,
    required this.revealed,
    required this.note,
    required this.onScience,
    super.key,
  });

  final QuizCard card;
  final QuizDomain domain;
  final bool revealed;

  /// How the round's figures are measured.
  final String note;

  /// Opens the item's science sheet once this one has closed.
  final VoidCallback onScience;

  static void show(
    BuildContext context, {
    required QuizCard card,
    required QuizDomain domain,
    required bool revealed,
    required String note,
    required VoidCallback onScience,
  }) => InfoSheet.present(
    context,
    QuizItemSheet(
      card: card,
      domain: domain,
      revealed: revealed,
      note: note,
      onScience: onScience,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final labelStyle = theme.overline;
    final valueStyle = theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onSurface,
    );
    Widget text(String data, TextStyle? style) =>
        PhraseText(data, minLineWidth: infoSheetMinLineWidth, style: style);
    Widget field(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(label.toUpperCase(), labelStyle),
          text(value, valueStyle),
        ],
      ),
    );
    return InfoSheet.custom(
      title: card.title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          field(l10n.quizItemInfoType, card.groupLabel),
          field(
            l10n.quizItemInfoAmount,
            card.subtitle.isEmpty ? domain.basis(l10n) : card.subtitle,
          ),
          const SizedBox(height: spacingXs),
          text(
            note,
            theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (revealed) ...[
            const SizedBox(height: spacingLg),
            text(
              card.revealText,
              theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: domain.ink(theme.brightness, large: true),
              ),
            ),
            if (card.revealDetail.isNotEmpty)
              text(
                card.revealDetail,
                theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: spacingSm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onScience();
                },
                child: Text(l10n.quizItemInfoScience),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
