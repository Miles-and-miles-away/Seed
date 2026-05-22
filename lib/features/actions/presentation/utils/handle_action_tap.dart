import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/achievements/presentation/screens/achievement_celebration_screen.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/eco_dex/eco_dex.dart';
import 'package:seed_app/features/mascot/mascot.dart';
import 'package:seed_app/features/settings/data/models/user_settings_model.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import 'package:seed_app/features/settings/presentation/widgets/streak_milestone_dialog.dart';
import '../providers/actions_providers.dart';
import '../widgets/action_log_confirmation_dialog.dart';
import '../widgets/learn_only_info_dialog.dart';
import '../widgets/points_animation_overlay.dart';

/// Handles tapping an action card: shows the appropriate
/// dialog and logs the action if confirmed.
Future<void> handleActionTap(
  BuildContext context,
  WidgetRef ref, {
  required ActionModel action,
  required String languageCode,
}) async {
  if (action.isLearnOnly) {
    await LearnOnlyInfoDialog.show(
      context,
      action: action,
      languageCode: languageCode,
    );
    return;
  }

  final result = await ActionLogConfirmationDialog.show(
    context,
    action: action,
    languageCode: languageCode,
  );

  if (result == null || !result.confirmed) return;
  if (!context.mounted) return;

  final logResult = await ref.read(actionLogProvider.notifier).logAction(
        action,
        note: result.note,
        languageCode: languageCode,
      );

  if (!context.mounted) return;

  if (logResult != null) {
    final category = ActionCategory.fromString(action.category);

    PointsAnimationOverlay.show(
      context,
      points: action.points,
      color: category?.color,
    );

    ref.read(mascotAnimationTriggerProvider.notifier).triggerBounce();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).actionLogged(action.points),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );

    if (logResult.challengeCompleted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).challengeCompletedSnackbar,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
      );
    }

    // Eco-Dex discovery evaluation
    if (context.mounted) {
      final newEntries =
          await ref.read(ecoDexDiscoveryProvider.notifier).discoverNewEntries();
      if (newEntries.isNotEmpty && context.mounted) {
        final ecoDex = await ref.read(ecoDexDataProvider.future);
        final entry = ecoDex.entries.firstWhere(
          (e) => e.id == newEntries.first,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).ecoDexNewDiscoveryMessage(
                entry.name(languageCode),
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    }

    if (logResult.shouldShowMilestone && context.mounted) {
      final settings = await ref.read(userSettingsProvider.future);
      final milestoneWeek = logResult.crossedMilestoneWeek!;
      final alreadySeen = settings.hasSeenMilestone(milestoneWeek);

      if (!alreadySeen && context.mounted) {
        await showStreakMilestoneCelebration(
          context,
          weekNumber: milestoneWeek,
          totalDays: logResult.newStreakDays,
        );
      }
    }

    if (logResult.didUnlockAchievement && context.mounted) {
      await showAchievementCelebrations(
        context,
        definitions: logResult.newlyUnlockedAchievements,
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).errorGeneric,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
