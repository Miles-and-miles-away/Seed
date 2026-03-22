import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'action_science_bottom_sheet.dart';

/// Result of the action log confirmation dialog.
class ActionLogConfirmationResult {
  const ActionLogConfirmationResult({
    required this.confirmed,
    this.note,
  });

  final bool confirmed;
  final String? note;
}

/// A dialog to confirm logging an action, with optional note field.
class ActionLogConfirmationDialog extends StatefulWidget {
  const ActionLogConfirmationDialog({
    required this.action,
    required this.languageCode,
    super.key,
  });

  final ActionModel action;
  final String languageCode;

  /// Shows the dialog and returns the result.
  static Future<ActionLogConfirmationResult?> show(
    BuildContext context, {
    required ActionModel action,
    required String languageCode,
  }) {
    return showDialog<ActionLogConfirmationResult>(
      context: context,
      builder: (context) => ActionLogConfirmationDialog(
        action: action,
        languageCode: languageCode,
      ),
    );
  }

  @override
  State<ActionLogConfirmationDialog> createState() =>
      _ActionLogConfirmationDialogState();
}

class _ActionLogConfirmationDialogState
    extends State<ActionLogConfirmationDialog> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final category = ActionCategory.fromString(widget.action.category);
    final categoryColor = category?.color ?? theme.colorScheme.primary;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with category color
          Container(
            padding: const EdgeInsets.all(Spacing.xxl),
            decoration: BoxDecoration(
              color: categoryColor.withValues(
                alpha: Opacities.faint,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  category?.icon ?? Icons.eco,
                  size: 48,
                  color: categoryColor,
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  widget.action.name(widget.languageCode),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.sm),
                // Points display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.lg,
                    vertical: Spacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: Radii.borderXl,
                  ),
                  child: Text(
                    l10n.pointsLabel(widget.action.points),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Description and note field
          Padding(
            padding: const EdgeInsets.all(Spacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.action
                    .description(widget.languageCode)
                    .isNotEmpty) ...[
                  _buildDescription(
                    theme,
                    l10n,
                    categoryColor,
                  ),
                  const SizedBox(height: Spacing.lg),
                ],
                // CO2 savings - tappable to show science
                if (widget.action.co2Grams > 0) ...[
                  _buildCo2Row(
                    theme,
                    l10n,
                    categoryColor,
                  ),
                  const SizedBox(height: Spacing.lg),
                ],
                // Optional note field
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: l10n.addNoteOptional,
                    hintText: l10n.noteHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.note_add_outlined),
                  ),
                  maxLines: 2,
                  maxLength: 200,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            const ActionLogConfirmationResult(confirmed: false),
          ),
          child: Text(l10n.buttonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            ActionLogConfirmationResult(
              confirmed: true,
              note: _noteController.text.trim().isEmpty
                  ? null
                  : _noteController.text.trim(),
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: categoryColor,
          ),
          child: Text(l10n.buttonConfirm),
        ),
      ],
    );
  }

  Widget _buildDescription(
    ThemeData theme,
    AppLocalizations l10n,
    Color categoryColor,
  ) {
    final desc = widget.action.description(widget.languageCode);
    final hasLong =
        widget.action.descriptionLong(widget.languageCode).isNotEmpty;

    if (!hasLong) {
      return Text(
        desc,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      );
    }

    final linkColor = theme.colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () => ActionScienceBottomSheet.show(
        context,
        action: widget.action,
        languageCode: widget.languageCode,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              desc,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: linkColor,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: linkColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: Spacing.sm),
          Icon(
            Icons.info_outline,
            size: 16,
            color: categoryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCo2Row(
    ThemeData theme,
    AppLocalizations l10n,
    Color categoryColor,
  ) {
    final hasLong =
        widget.action.descriptionLong(widget.languageCode).isNotEmpty;
    final co2Text = l10n.co2Saved(
      formatCO2Compact(widget.action.co2Grams),
    );
    final linkColor = theme.colorScheme.onSurfaceVariant;

    final row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.eco,
          size: 16,
          color: hasLong ? categoryColor : theme.colorScheme.primary,
        ),
        const SizedBox(width: Spacing.sm),
        Text(
          co2Text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: hasLong ? linkColor : theme.colorScheme.primary,
            fontWeight: hasLong ? FontWeight.w500 : null,
            decoration: hasLong ? TextDecoration.underline : null,
            decorationColor: hasLong ? linkColor : null,
          ),
        ),
        if (hasLong) ...[
          const SizedBox(width: Spacing.sm),
          Icon(
            Icons.info_outline,
            size: 14,
            color: categoryColor,
          ),
        ],
      ],
    );

    if (!hasLong) return row;

    return GestureDetector(
      onTap: () => ActionScienceBottomSheet.show(
        context,
        action: widget.action,
        languageCode: widget.languageCode,
      ),
      child: row,
    );
  }
}
