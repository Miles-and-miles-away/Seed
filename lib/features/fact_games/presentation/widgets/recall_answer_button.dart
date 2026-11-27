import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';

const _answerIconSize = 18.0;

/// An answer before the question is answered, then its verdict; `other`
/// is an answer that was neither right nor chosen.
enum RecallAnswerState { idle, right, wrong, other }

/// One Fact recall answer, labelled with its figure; once answered it
/// keeps its verdict's colours and icon while disabled.
class RecallAnswerButton extends StatelessWidget {
  const RecallAnswerButton({
    required this.figure,
    required this.state,
    required this.onPressed,
    super.key,
  });

  final String figure;
  final RecallAnswerState state;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    // M3 paints its disabled colours over an answered button otherwise.
    final colours = switch (state) {
      RecallAnswerState.right => (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
        Icons.check,
      ),
      RecallAnswerState.wrong => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        Icons.close,
      ),
      _ => null,
    };
    final label = switch (state) {
      RecallAnswerState.right => '$figure, ${l10n.quizCorrect}',
      RecallAnswerState.wrong => '$figure, ${l10n.factRecallYourWrongAnswer}',
      _ => figure,
    };
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(kMinInteractiveDimension),
        textStyle: theme.textTheme.titleSmall,
        disabledBackgroundColor: colours?.$1,
        disabledForegroundColor: colours?.$2,
        side: colours == null ? null : BorderSide(color: colours.$1),
      ),
      child: Semantics(
        label: label,
        excludeSemantics: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (colours != null) ...[
              Icon(colours.$3, size: _answerIconSize),
              const SizedBox(width: spacingSm),
            ],
            Flexible(
              child: Text(
                jaFigureWrap(figure, locale: Localizations.localeOf(context)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
