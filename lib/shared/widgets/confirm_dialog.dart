import 'package:flutter/material.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

/// Cancel / confirm prompt. Resolves true only when [confirmLabel] is
/// tapped; dismissing the barrier counts as cancel.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String message,
  required String confirmLabel,
  String? title,
  bool destructive = false,
}) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: title == null
          ? null
          : PhraseText(title, minLineWidth: phraseDialogMinLineWidth),
      content: PhraseText(message, minLineWidth: phraseDialogMinLineWidth),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(l10n.buttonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(dialogContext).colorScheme.error,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
