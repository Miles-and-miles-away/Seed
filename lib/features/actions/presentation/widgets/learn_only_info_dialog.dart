import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'action_science_bottom_sheet.dart';

/// A dialog showing educational info for learn-only actions.
class LearnOnlyInfoDialog extends ConsumerWidget {
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
      builder: (context) =>
          LearnOnlyInfoDialog(action: action, languageCode: languageCode),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final category = ActionCategory.fromString(action.category);
    final categoryColor = category?.color ?? theme.colorScheme.primary;
    final goalMap = ref.watch(sdgGoalsDataProvider).value?.goalMap ?? {};

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(spacingXxl),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: opacityVeryFaint),
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
                const SizedBox(height: spacingMd),
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
            padding: const EdgeInsets.all(spacingXxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (action.description(languageCode).isNotEmpty) ...[
                  _buildDescription(context, theme, categoryColor),
                  const SizedBox(height: spacingLg),
                ],
                Text(
                  l10n.learnOnlyDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (action.relatedSdgs.isNotEmpty) ...[
                  const SizedBox(height: spacingLg),
                  Text(
                    l10n.learnOnlyRelatedSdgs,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: spacingSm),
                  _buildSdgRow(action.relatedSdgs, goalMap, theme),
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
    final hasLong = action.descriptionLong(languageCode).isNotEmpty;

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
              style: theme.textTheme.bodyMedium?.copyWith(
                color: categoryColor,
                decoration: TextDecoration.underline,
                decorationColor: categoryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: spacingSm),
          Icon(Icons.info_outline, size: 16, color: categoryColor),
        ],
      ),
    );
  }

  Widget _buildSdgRow(
    List<String> sdgNumbers,
    Map<int, SdgGoal> goalMap,
    ThemeData theme,
  ) {
    final parsed =
        sdgNumbers
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
        final sdg = goalMap[number];
        final color = sdg?.color ?? Colors.grey;
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
