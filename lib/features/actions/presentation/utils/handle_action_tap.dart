import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/app_bottom_nav.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/log_error_message.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/eco_dex/eco_dex.dart';
import 'package:seed_app/features/mascot/mascot.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/settings/presentation/providers/settings_providers.dart';
import '../providers/actions_providers.dart';
import '../widgets/action_log_confirmation_dialog.dart';
import '../widgets/learn_only_info_dialog.dart';
import '../widgets/points_animation_overlay.dart';

const _maxLogWait = Duration(seconds: 30);

// One waiting message for each messenger, shared by every log in flight.
final _waiting =
    Expando<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>();

/// Logs [action], with a message while the log waits out the rules' gap.
Future<ActionLogResult?> logActionWithWaitMessage(
  BuildContext context,
  WidgetRef ref,
  ActionModel action, {
  required String languageCode,
  String? note,
}) async {
  final notifier = ref.read(actionLogProvider.notifier);
  final messenger = ScaffoldMessenger.of(context);
  if (_waiting[messenger] == null &&
      (notifier.isBusy || actionLogCooldown() > Duration.zero)) {
    // Emptied first: a queued message would show after the wait is over.
    messenger
      ..clearSnackBars()
      ..removeCurrentSnackBar();
    final waiting = _waiting[messenger] = messenger.showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).actionLogging),
        behavior: SnackBarBehavior.floating,
        duration: _maxLogWait,
      ),
    );
    unawaited(
      waiting.closed.whenComplete(() {
        if (_waiting[messenger] == waiting) _waiting[messenger] = null;
      }),
    );
  }

  final result = await notifier.logAction(
    action,
    note: note,
    languageCode: languageCode,
  );
  if (!notifier.isBusy && messenger.mounted) {
    _waiting[messenger]?.close();
    _waiting[messenger] = null;
  }
  return result;
}

Future<void> _untilMilestoneSeen(WidgetRef ref) async {
  if (ref.read(pendingStreakMilestoneProvider) == null) return;
  final seen = Completer<void>();
  final sub = ref.listenManual(pendingStreakMilestoneProvider, (_, next) {
    if (next == null && !seen.isCompleted) seen.complete();
  });
  await seen.future;
  sub.close();
}

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

  // The notifier drops a repeat of a log still waiting or in flight.
  if (ref.read(actionLogProvider.notifier).isPending(action.id)) return;

  final logResult = await logActionWithWaitMessage(
    context,
    ref,
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).actionLogged(action.points)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );

    if (logResult.challengeCompleted) {
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

    final newIds = await discoverAndCelebrateEcoDex(
      context,
      ref,
      minActionsCount: logResult.newTotalActionsCount,
    );
    if (!context.mounted) return;

    // Only the crossing log cheers, and not when a dialog or the inbox
    // follows: the root overlay would float over them.
    final goalReached =
        logResult.newGoalCount == ref.read(effectiveDailyGoalTargetProvider);
    if (goalReached &&
        newIds.isEmpty &&
        !logResult.shouldShowMilestone &&
        !logResult.challengeCompleted) {
      MascotCheer.show(context, bottomClearance: appBottomNavHeight(context));
    }

    if (!logResult.challengeCompleted) return;
    // The shell shows the milestone on this route, which go would drop.
    await _untilMilestoneSeen(ref);
    // A pending evolution dialog sits on this route too.
    if (context.mounted && !ref.read(mascotCelebrationPendingProvider)) {
      // Pushing a Home-branch page from a root route duplicates the shell.
      if (StatefulNavigationShell.maybeOf(context) != null) {
        unawaited(context.push(appRoutes.dailyFact));
      } else {
        context.go(appRoutes.dailyFact);
      }
    }
  } else {
    final logState = ref.read(actionLogProvider);
    // Null result with no error means this action is already being
    // logged -- nothing to report.
    if (logState.isLoading || !logState.hasError) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(logErrorMessage(context, logState.error)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
