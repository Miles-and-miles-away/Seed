import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';

/// The live footprint line under an editor sheet's quantity field.
class EntryPreviewLine extends StatelessWidget {
  const EntryPreviewLine(this.grams, {super.key});

  final int grams;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: spacingSm),
      child: Text(
        l10n.calculatorEntryPreview(formatCO2Compact(grams)),
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// An editor sheet's closing row: Cancel / Save when the entry is bound
/// to [fixedOption], otherwise "Add to A" / "Add to B".
class EditorSheetActions extends StatelessWidget {
  const EditorSheetActions({required this.onSave, this.fixedOption, super.key});

  /// The column the entry is bound to, or null to ask.
  final int? fixedOption;

  final void Function(int option) onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fixed = fixedOption;
    if (fixed != null) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.buttonCancel),
            ),
          ),
          const SizedBox(width: spacingMd),
          Expanded(
            child: FilledButton(
              onPressed: () => onSave(fixed),
              child: Text(l10n.buttonSave),
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: FilledButton.tonal(
            onPressed: () => onSave(optionA),
            child: Text(l10n.calculatorAddToA),
          ),
        ),
        const SizedBox(width: spacingMd),
        Expanded(
          child: FilledButton.tonal(
            onPressed: () => onSave(optionB),
            child: Text(l10n.calculatorAddToB),
          ),
        ),
      ],
    );
  }
}
