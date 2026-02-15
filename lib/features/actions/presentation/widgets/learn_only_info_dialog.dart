import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../sdg/data/sdg_data.dart';
import '../../data/models/action_model.dart';
import '../../domain/enums/action_category.dart';
import 'action_science_bottom_sheet.dart';

/// A dialog showing educational info for learn-only actions.
class LearnOnlyInfoDialog extends StatelessWidget {
  const LearnOnlyInfoDialog({
    required this.action,
    required this.languageCode,
    super.key,
  });

  final ActionModel action;
  final String languageCode;

  static Future<void> show(
    BuildContext context, {
    required ActionModel action,
    required String languageCode,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => LearnOnlyInfoDialog(
        action: action,
        languageCode: languageCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final category = ActionCategory.fromString(action.category);
    final categoryColor =
        category?.color ?? theme.colorScheme.primary;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.menu_book,
                  size: 48,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 12),
                Text(
                  action.name(languageCode),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (action
                    .description(languageCode)
                    .isNotEmpty) ...[
                  _buildDescription(
                    context,
                    theme,
                    categoryColor,
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  l10n.learnOnlyDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (action.relatedSdgs.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    l10n.learnOnlyRelatedSdgs,
                    style:
                        theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  _buildSdgRow(action.relatedSdgs, theme),
                ],
              ],
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.learnOnlyDismiss),
        ),
      ],
    );
  }

  Widget _buildDescription(
    BuildContext context,
    ThemeData theme,
    Color categoryColor,
  ) {
    final desc = action.description(languageCode);
    final hasLong =
        action.descriptionLong(languageCode).isNotEmpty;

    if (!hasLong) {
      return Text(
        desc,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      );
    }

    return GestureDetector(
      onTap: () => ActionScienceBottomSheet.show(
        context,
        action: action,
        languageCode: languageCode,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              desc,
              style:
                  theme.textTheme.bodyMedium?.copyWith(
                color: categoryColor,
                decoration: TextDecoration.underline,
                decorationColor: categoryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.info_outline,
            size: 16,
            color: categoryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSdgRow(
    List<String> sdgNumbers,
    ThemeData theme,
  ) {
    final parsed = sdgNumbers
        .map(int.tryParse)
        .whereType<int>()
        .where((n) => n >= 1 && n <= 17)
        .toList()
      ..sort();

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: parsed.map((number) {
        final sdg =
            sdgGoalMap[number] ?? sdgGoals.first;
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: sdg.color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
