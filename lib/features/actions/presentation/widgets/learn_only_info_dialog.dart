import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/text_styles.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_dialog_header.dart';
import 'package:seed_app/features/actions/presentation/widgets/sdg_badge.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:seed_app/shared/widgets/info_affordance.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';
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
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ActionDialogHeader(
            tint: categoryColor.withValues(alpha: opacityVeryFaint),
            icon: Icons.menu_book,
            iconColor: theme.colorScheme.outline,
            title: action.name(languageCode),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(spacingXxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (action.description(languageCode).isNotEmpty) ...[
                  _buildDescription(context, theme),
                  const SizedBox(height: spacingLg),
                ],
                PhraseText(
                  l10n.learnOnlyDescription,
                  minLineWidth: phraseDialogMinLineWidth,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (action.relatedSdgs.isNotEmpty) ...[
                  const SizedBox(height: spacingLg),
                  Text(
                    l10n.learnOnlyRelatedSdgs.toUpperCase(),
                    style: theme.overline,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: spacingSm),
                  _buildSdgRow(action.relatedSdgs, goalMap),
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

  Widget _buildDescription(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context);
    final description = PhraseText(
      action.description(languageCode),
      locale: Locale(languageCode),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
    if (action.descriptionLong(languageCode).isEmpty) return description;

    return Center(
      child: TermWithInfo(
        term: description,
        tooltip: l10n.actionScienceTooltip,
        onPressed: () => ActionScienceBottomSheet.show(
          context,
          action: action,
          languageCode: languageCode,
        ),
      ),
    );
  }

  Widget _buildSdgRow(List<String> sdgNumbers, Map<int, SdgGoal> goalMap) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final number in parsedSdgNumbers(sdgNumbers))
          SdgNumberBadge(
            '$number',
            goalMap[number]?.color ?? Colors.grey,
            diameter: 28,
          ),
      ],
    );
  }
}
