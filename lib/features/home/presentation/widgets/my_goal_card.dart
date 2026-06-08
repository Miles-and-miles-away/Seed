import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Card showing the user's personal sustainability goal on the home
/// screen, prompting them to set one when none exists yet.
class MyGoalCard extends ConsumerWidget {
  const MyGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(currentUserProvider);
    final goal = userAsync.value?.personalGoal;
    // Until the user stream emits its first value, show a placeholder so an
    // existing goal doesn't flash the empty prompt on cold load.
    final loading = !userAsync.hasValue;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: loading ? null : () => _editGoal(context, ref, goal),
        child: Padding(
          padding: const EdgeInsets.all(spacingLg),
          child: Row(
            children: [
              Icon(
                Icons.flag_outlined,
                color: colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.myGoalTitle,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: spacingXs),
                    if (loading)
                      const SkeletonLine()
                    else
                      Text(
                        goal == null
                            ? l10n.myGoalEmptyPrompt
                            : localizedPersonalGoal(goal, l10n),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: goal == null
                              ? colorScheme.onSurfaceVariant
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
              if (!loading) ...[
                const SizedBox(width: spacingMd),
                Icon(
                  goal == null ? Icons.add_circle_outline : Icons.edit_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editGoal(
    BuildContext context,
    WidgetRef ref,
    String? currentGoal,
  ) async {
    final l10n = AppLocalizations.of(context);
    final goal = await GoalPickerSheet.show(context, initialGoal: currentGoal);
    if (goal == null || goal == currentGoal || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      // Optimistic: the card reflects the new goal via the user stream;
      // only surface a message if the write actually fails.
      await ref.read(authProvider.notifier).updatePersonalGoal(goal);
    } on Exception {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    }
  }
}
