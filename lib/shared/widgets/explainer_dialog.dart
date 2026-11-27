import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

/// A plain-language explanation with a single Close action.
Future<void> showExplainerDialog(
  BuildContext context, {
  required String title,
  required String body,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: PhraseText(title, minLineWidth: phraseDialogMinLineWidth),
      content: PhraseText(body, minLineWidth: phraseDialogMinLineWidth),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(l10n.buttonClose),
        ),
      ],
    ),
  );
}
