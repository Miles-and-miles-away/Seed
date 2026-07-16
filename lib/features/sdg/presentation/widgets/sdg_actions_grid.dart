import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/actions/presentation/utils/handle_action_tap.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_card.dart';
import '../providers/sdg_stats_provider.dart';

const _maxVisibleActions = 6;

/// Displays a horizontal row of related actions for an SDG.
class SdgActionsGrid extends ConsumerWidget {
  const SdgActionsGrid({
    required this.goalNumber,
    required this.goalColor,
    required this.languageCode,
    super.key,
  });

  final int goalNumber;
  final Color goalColor;
  final String languageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final actions = ref.watch(sdgRelatedActionsProvider(goalNumber));

    if (actions.isEmpty) return const SizedBox.shrink();

    final visible = actions.length > _maxVisibleActions
        ? actions.sublist(0, _maxVisibleActions)
        : actions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.eco, color: goalColor, size: 20),
                const SizedBox(width: spacingSm),
                Text(
                  l10n.sdgRelatedActions,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                ref.read(selectedSdgFilterProvider.notifier).select(goalNumber);
                context.push(appRoutes.actionLog);
              },
              child: Text(l10n.sdgViewAllActions),
            ),
          ],
        ),
        const SizedBox(height: spacingMd),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: visible.length,
            separatorBuilder: (_, _) => const SizedBox(width: spacingMd),
            itemBuilder: (context, index) => SizedBox(
              width: 150,
              child: ActionCard(
                action: visible[index],
                languageCode: languageCode,
                onTap: () => handleActionTap(
                  context,
                  ref,
                  action: visible[index],
                  languageCode: languageCode,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
