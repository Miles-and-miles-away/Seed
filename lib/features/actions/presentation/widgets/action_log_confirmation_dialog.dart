import 'dart:async';

import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/external_link.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/core/utils/readable_color.dart';
import 'package:seed_app/core/utils/utf16_length_limiting_text_input_formatter.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';

/// Result of the action log confirmation dialog.
class ActionLogConfirmationResult {
  const ActionLogConfirmationResult({required this.confirmed, this.note});

  final bool confirmed;
  final String? note;
}

/// A dialog to confirm logging an action, with optional note field.
///
/// Set [readOnly] to `true` to reuse the same visual layout as an
/// info-only view (no note field, single Close button). Used from the
/// progress page when tapping a previously-logged action.
class ActionLogConfirmationDialog extends StatefulWidget {
  const ActionLogConfirmationDialog({
    required this.action,
    required this.languageCode,
    this.readOnly = false,
    super.key,
  });

  final ActionModel action;
  final String languageCode;
  final bool readOnly;

  /// Shows the dialog and returns the result.
  static Future<ActionLogConfirmationResult?> show(
    BuildContext context, {
    required ActionModel action,
    required String languageCode,
    bool readOnly = false,
  }) {
    return showDialog<ActionLogConfirmationResult>(
      context: context,
      builder: (context) => ActionLogConfirmationDialog(
        action: action,
        languageCode: languageCode,
        readOnly: readOnly,
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
  bool _scienceExpanded = false;

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
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with category color
          Container(
            padding: const EdgeInsets.all(spacingXxl),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: opacityFaint),
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
                const SizedBox(height: spacingMd),
                Text(
                  widget.action.name(widget.languageCode),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacingSm),
                // Points display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacingLg,
                    vertical: spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: borderRadiusXl,
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
            padding: const EdgeInsets.all(spacingXxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInfoSection(theme, l10n, categoryColor),
                // Optional note field (logging flow only)
                if (!widget.readOnly)
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: l10n.addNoteOptional,
                      hintText: l10n.noteHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.note_add_outlined),
                    ),
                    maxLines: 2,
                    maxLength: AppConstants.maxNoteLength,
                    // Cap on UTF-16 units to match the Firestore rule's
                    // .size().
                    inputFormatters: [
                      Utf16LengthLimitingTextInputFormatter(
                        AppConstants.maxNoteLength,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: widget.readOnly
          ? [
              FilledButton(
                onPressed: () => Navigator.of(
                  context,
                ).pop(const ActionLogConfirmationResult(confirmed: false)),
                style: FilledButton.styleFrom(backgroundColor: categoryColor),
                child: Text(l10n.buttonClose),
              ),
            ]
          : [
              TextButton(
                onPressed: () => Navigator.of(
                  context,
                ).pop(const ActionLogConfirmationResult(confirmed: false)),
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
                style: FilledButton.styleFrom(backgroundColor: categoryColor),
                child: Text(l10n.buttonConfirm),
              ),
            ],
    );
  }

  Widget _buildInfoSection(
    ThemeData theme,
    AppLocalizations l10n,
    Color categoryColor,
  ) {
    final desc = widget.action.description(widget.languageCode);
    final hasDesc = desc.isNotEmpty;
    final hasCo2 = widget.action.co2Grams > 0;
    final hasLong = widget.action
        .descriptionLong(widget.languageCode)
        .isNotEmpty;

    if (!hasDesc && !hasCo2) return const SizedBox.shrink();

    final descWidget = hasDesc
        ? Text(
            desc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        : null;

    final co2Widget = hasCo2
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.eco, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: spacingSm),
              Text(
                l10n.co2Saved(formatCO2Compact(widget.action.co2Grams)),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          )
        : null;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ?descWidget,
        if (descWidget != null && co2Widget != null)
          const SizedBox(height: spacingSm),
        ?co2Widget,
      ],
    );

    if (!hasLong) {
      return Padding(
        padding: const EdgeInsets.only(bottom: spacingLg),
        child: content,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: spacingLg),
      child: Material(
        color: categoryColor.withValues(alpha: opacityVeryFaint),
        borderRadius: borderRadiusMd,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () => setState(() => _scienceExpanded = !_scienceExpanded),
              child: Padding(
                padding: const EdgeInsets.all(spacingLg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: content),
                    const SizedBox(width: spacingSm),
                    AnimatedRotation(
                      turns: _scienceExpanded ? 0.5 : 0,
                      duration: durationFast,
                      child: Icon(
                        Icons.expand_more,
                        size: 20,
                        color: categoryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: durationFast,
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: _scienceExpanded
                  ? _buildScienceContent(theme, categoryColor)
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScienceContent(ThemeData theme, Color categoryColor) {
    final linkColor = readableOn(categoryColor, theme.colorScheme.surface);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(spacingLg, 0, spacingLg, spacingLg),
      child: MarkdownBlock(
        data: appendExternalLinkArrow(
          widget.action.descriptionLong(widget.languageCode),
        ),
        config: markdownConfigFor(context).copy(
          configs: [
            PConfig(
              textStyle: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: theme.colorScheme.onSurface,
              ),
            ),
            externalLinkConfig(context, color: linkColor, onTap: _onLinkTap),
          ],
        ),
      ),
    );
  }

  void _onLinkTap(String url) {
    unawaited(openExternalUrl(context, url));
  }
}
