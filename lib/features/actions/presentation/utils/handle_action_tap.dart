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
import 'package:seed_app/shared/widgets/celebration_overlay.dart';
import '../providers/actions_providers.dart';
import '../widgets/action_log_confirmation_dialog.dart';
import '../widgets/learn_only_info_dialog.dart';
import '../widgets/points_animation_overlay.dart';

const _maxLogWait = Duration(seconds: 30);

// One waiting message for each messenger, shared by every log in flight.
final _waiting =
    Expando<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>();

// The egg reset message of each messenger, until it closes.
final _eggReset =
    Expando<ScaffoldFeatureController<SnackBar, SnackBarClosedReason>>();

/// Tells the user that a missed day started the egg's count again.
void showEggResetMessage(
  ScaffoldMessengerState messenger,
  AppLocalizations l10n,
) {
  final shown = _eggReset[messenger] = messenger.showSnackBar(
    SnackBar(
      content: Text(l10n.eggStreakResetMessage),
      behavior: SnackBarBehavior.floating,
    ),
  );
  unawaited(
    shown.closed.whenComplete(() {
      if (_eggReset[messenger] == shown) _eggReset[messenger] = null;
    }),
  );
}

/// Logs [action], with a message while the log waits out the rules' gap.
Future<ActionLogResult?> logActionWithWaitMessage(
  BuildContext context,
  WidgetRef ref,
  ActionModel action, {
  required String languageCode,
  String? note,
  bool countsAsUnique = true,
}) async {
  final notifier = ref.read(actionLogProvider.notifier);
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context);
  var eggResetCleared = false;
  if (_waiting[messenger] == null &&
      (notifier.isBusy || actionLogCooldown() > Duration.zero)) {
    // Unlike the other messages, the egg reset is still news after the wait.
    eggResetCleared = _eggReset[messenger] != null;
    _eggReset[messenger] = null;
    // Emptied first: a queued message would show after the wait is over.
    messenger
      ..clearSnackBars()
      ..removeCurrentSnackBar();
    final waiting = _waiting[messenger] = messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.actionLogging),
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
    countsAsUnique: countsAsUnique,
  );
  if (!notifier.isBusy && messenger.mounted) {
    _waiting[messenger]?.close();
    _waiting[messenger] = null;
  }
  if (eggResetCleared && _eggReset[messenger] == null && messenger.mounted) {
    showEggResetMessage(messenger, l10n);
  }
  return result;
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

  await _logAndReport(
    context,
    ref,
    action: action,
    note: result.note,
    languageCode: languageCode,
  );
}

Future<void> _logAndReport(
  BuildContext context,
  WidgetRef ref, {
  required ActionModel action,
  required String? note,
  required String languageCode,
}) async {
  // The notifier drops a repeat of a log still waiting or in flight.
  if (ref.read(actionLogProvider.notifier).isPending(action.id)) return;

  final logResult = await logActionWithWaitMessage(
    context,
    ref,
    action,
    note: note,
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

    // The day's first log dances and the goal-crossing log jumps, but not
    // when a dialog or the inbox follows: the overlay would float over it.
    final firstToday = logResult.newGoalCount == 1;
    final goalReached =
        logResult.newGoalCount == ref.read(effectiveDailyGoalTargetProvider);
    if ((firstToday || goalReached) &&
        newIds.isEmpty &&
        !logResult.shouldShowMilestone &&
        !logResult.challengeCompleted) {
      MascotCheer.show(
        context,
        bottomClearance: appBottomNavHeight(context),
        streakDays: firstToday ? logResult.newStreakDays : null,
      );
    }

    if (!logResult.challengeCompleted ||
        ref.read(mascotCelebrationPendingProvider)) {
      return;
    }
    // The shell shows celebrations on this route, which go would drop.
    await celebrationsDone(context);
    if (!context.mounted) return;
    // Pushing a Home-branch page from a root route duplicates the shell.
    if (StatefulNavigationShell.maybeOf(context) != null) {
      unawaited(context.push(appRoutes.dailyFact));
    } else {
      context.go(appRoutes.dailyFact);
    }
  } else {
    final logState = ref.read(actionLogProvider);
    // Null result with no error means this action is already being
    // logged -- nothing to report.
    if (logState.isLoading || !logState.hasError) return;

    final messenger = ScaffoldMessenger.of(context);
    final message = logErrorMessage(context, logState.error);
    final errorColor = Theme.of(context).colorScheme.error;
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: errorColor,
        persist: false,
        action: isOfflineError(logState.error)
            ? SnackBarAction(
                label: AppLocalizations.of(context).buttonRetry,
                textColor: Theme.of(context).colorScheme.onError,
                onPressed: () {
                  // Retry needs its screen, so repeat that nothing was saved.
                  if (!context.mounted) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(message),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: errorColor,
                      ),
                    );
                    return;
                  }
                  unawaited(
                    _logAndReport(
                      context,
                      ref,
                      action: action,
                      note: note,
                      languageCode: languageCode,
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }
}
