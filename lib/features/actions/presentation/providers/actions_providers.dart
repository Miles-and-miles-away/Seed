import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/utils/app_logger.dart';
import 'package:seed_app/features/actions/data/datasources/action_library_remote_datasource.dart';
import 'package:seed_app/features/actions/data/datasources/action_log_remote_datasource.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/data/repositories/action_log_repository.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/domain/enums/action_sort_option.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/challenge.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_chart_data_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_stats_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/shared/providers/analytics_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

export 'package:seed_app/features/actions/data/repositories/action_log_repository.dart'
    show ActionLogResult;
export 'package:seed_app/features/actions/domain/enums/action_sort_option.dart'
    show ActionSortOption;

part 'actions_providers.g.dart';

// =============================================================================
// Data Source Providers
// =============================================================================

@riverpod
ActionLibraryRemoteDataSource actionLibraryDataSource(Ref ref) {
  return ActionLibraryRemoteDataSource(firestore: ref.watch(firestoreProvider));
}

@riverpod
ActionLogRemoteDataSource actionLogDataSource(Ref ref) {
  return ActionLogRemoteDataSource(firestore: ref.watch(firestoreProvider));
}

// =============================================================================
// Repository Providers
// =============================================================================

/// Kept alive: every caller only `read`s it, so as autoDispose it was
/// disposed mid-build and the `ref.watch` after its awaits threw.
@Riverpod(keepAlive: true)
Future<ActionLogRepository> actionLogRepository(Ref ref) async {
  final challengeData = await ref.watch(challengeTemplateDataProvider.future);
  final speciesData = await ref.watch(mascotSpeciesDataProvider.future);
  return ActionLogRepository(
    dataSource: ref.watch(actionLogDataSourceProvider),
    firestore: ref.watch(firestoreProvider),
    dailyChallengeTemplates: challengeData.daily,
    multiDayChallengeTemplates: challengeData.multiDay,
    mascotSpecies: speciesData,
    clock: ref.watch(clockProvider),
  );
}

// =============================================================================
// Stream Providers
// =============================================================================

/// Page size for the action history; each "load more" extends the
/// live query by this many entries.
const actionHistoryPageSize = 50;

/// Loads the active actions from the action library.
///
/// keepAlive + one-shot get: the library is read-only reference data,
/// so a persistent snapshots() listener adds overhead for no benefit.
/// Content changes ship with reseeds and are picked up on app start.
@Riverpod(keepAlive: true)
Future<List<ActionModel>> actionLibrary(Ref ref) {
  return ref.watch(actionLibraryDataSourceProvider).getActions();
}

/// How many pages of history the user has requested.
@riverpod
class ActionHistoryPages extends _$ActionHistoryPages {
  @override
  int build() => 1;

  void loadMore() => state++;
}

/// Watches action logs for the current user, bounded to the requested
/// number of history pages (the log grows forever; streaming it whole
/// scales cost and memory with user loyalty).
@riverpod
Stream<List<ActionLogModel>> userActionLogs(Ref ref) async* {
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    yield [];
    return;
  }
  final pages = ref.watch(actionHistoryPagesProvider);
  final repo = await ref.watch(actionLogRepositoryProvider.future);
  yield* repo.watchUserActionLogs(userId, limit: pages * actionHistoryPageSize);
}

// =============================================================================
// State Providers
// =============================================================================

/// Currently selected action category for filtering.
/// Null means "All" categories.
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  ActionCategory? build() => null;

  // ignore: use_setters_to_change_properties
  void select(ActionCategory? category) {
    state = category;
  }
}

/// Search query for filtering actions.
@riverpod
class ActionSearchQuery extends _$ActionSearchQuery {
  @override
  String build() => '';

  // ignore: use_setters_to_change_properties
  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Currently selected sort option for the action library.
@riverpod
class SelectedSortOption extends _$SelectedSortOption {
  @override
  ActionSortOption build() => ActionSortOption.alphabeticalAsc;

  // ignore: use_setters_to_change_properties
  void select(ActionSortOption option) {
    state = option;
  }
}

/// Selected SDG for filtering actions.
/// Null means "All" SDGs.
@riverpod
class SelectedSdgFilter extends _$SelectedSdgFilter {
  @override
  int? build() => null;

  // ignore: use_setters_to_change_properties
  void select(int? sdgNumber) {
    state = sdgNumber;
  }

  void clear() {
    state = null;
  }
}

/// Midnight starting [day] and midnight starting the day after.
(DateTime, DateTime) _dayBounds(DateTime day) => (
  DateTime(day.year, day.month, day.day),
  DateTime(day.year, day.month, day.day + 1),
);

/// One-shot fetch of the logs for a single calendar day (used by the
/// calendar's day-detail sheet; a range query instead of streaming
/// the whole history).
@riverpod
Future<List<ActionLogModel>> actionsForDay(Ref ref, DateTime day) async {
  final userId = ref.watch(userIdProvider);
  if (userId == null) return const [];

  final (start, end) = _dayBounds(day);
  final repo = await ref.watch(actionLogRepositoryProvider.future);
  return repo.getActionLogsForRange(userId, start, end);
}

/// Streams today's action logs for the current user via a day-range
/// query (bounded reads; stays live as new actions land).
///
/// Invalidated at midnight by dayChangeProvider so the captured day
/// rolls over.
@riverpod
Stream<List<ActionLogModel>> todayActions(Ref ref) async* {
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    yield [];
    return;
  }

  final (start, end) = _dayBounds(ref.watch(clockProvider)());

  final repo = await ref.watch(actionLogRepositoryProvider.future);
  yield* repo.watchActionLogsForRange(userId, start, end);
}

/// User's language code, selected from the user document
/// to avoid recomputing filters on unrelated user changes.
final userLanguageCodeProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider).asData?.value;
  return user?.language ?? 'en';
});

/// Filtered actions (category, SDG, search) -- no sort.
/// Separated so that changing sort doesn't re-filter.
@riverpod
AsyncValue<List<ActionModel>> baseFilteredActions(Ref ref) {
  final actionsAsync = ref.watch(actionLibraryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(actionSearchQueryProvider).toLowerCase();
  final selectedSdg = ref.watch(selectedSdgFilterProvider);

  return actionsAsync.whenData((actions) {
    var filtered = actions;

    if (selectedCategory != null) {
      filtered = filtered
          .where((a) => a.category == selectedCategory.name)
          .toList();
    }

    if (selectedSdg != null) {
      filtered = filtered
          .where((a) => a.relatedSdgs.contains(selectedSdg.toString()))
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((a) {
        return a.nameEn.toLowerCase().contains(searchQuery) ||
            a.nameJa.toLowerCase().contains(searchQuery) ||
            a.nameEs.toLowerCase().contains(searchQuery) ||
            a.descriptionEn.toLowerCase().contains(searchQuery) ||
            a.descriptionJa.toLowerCase().contains(searchQuery) ||
            a.descriptionEs.toLowerCase().contains(searchQuery);
      }).toList();
    }

    return filtered;
  });
}

/// Filtered + sorted actions. Only re-sorts when sort
/// option or language changes; filter changes propagate
/// through baseFilteredActions.
@riverpod
AsyncValue<List<ActionModel>> filteredActions(Ref ref) {
  final baseAsync = ref.watch(baseFilteredActionsProvider);
  final sortOption = ref.watch(selectedSortOptionProvider);
  final lang = ref.watch(userLanguageCodeProvider);

  return baseAsync.whenData(
    (actions) => _sortActions(actions, sortOption, lang),
  );
}

/// Sorts actions by the selected option, using locale-aware
/// names for alphabetical sorting.
List<ActionModel> _sortActions(
  List<ActionModel> actions,
  ActionSortOption sortOption,
  String languageCode,
) {
  final sorted = List<ActionModel>.from(actions);

  switch (sortOption) {
    case ActionSortOption.alphabeticalAsc:
      sorted.sort(
        (a, b) => a.name(languageCode).compareTo(b.name(languageCode)),
      );
    case ActionSortOption.alphabeticalDesc:
      sorted.sort(
        (a, b) => b.name(languageCode).compareTo(a.name(languageCode)),
      );
    case ActionSortOption.co2HighToLow:
      sorted.sort((a, b) => b.co2Grams.compareTo(a.co2Grams));
    case ActionSortOption.co2LowToHigh:
      sorted.sort((a, b) => a.co2Grams.compareTo(b.co2Grams));
    case ActionSortOption.pointsHighToLow:
      sorted.sort((a, b) => b.points.compareTo(a.points));
    case ActionSortOption.pointsLowToHigh:
      sorted.sort((a, b) => a.points.compareTo(b.points));
  }

  return sorted;
}

// =============================================================================
// Action Log Notifier
// =============================================================================

/// Notifier that handles logging actions.
///
/// Kept alive: nothing watches it, so as autoDispose it was disposed
/// mid-log, silently skipping the stats invalidation and the error state.
@Riverpod(keepAlive: true)
class ActionLogNotifier extends _$ActionLogNotifier {
  @override
  AsyncValue<ActionLogResult?> build() => const AsyncValue.data(null);

  /// Logs an action for the current user.
  ///
  /// Returns an [ActionLogResult] containing the logged action and
  /// any streak milestone information.
  Future<ActionLogResult?> logAction(
    ActionModel action, {
    String? note,
    String languageCode = 'en',
  }) async {
    // In-flight guard: two concurrent callers would double-log.
    if (state.isLoading) return null;

    appLogger.debug('ActionLog: logAction called for ${action.nameEn}');

    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.asData?.value;
    if (user == null) {
      if (!ref.mounted) return null;
      state = AsyncValue.error(
        Exception('User not authenticated'),
        StackTrace.current,
      );
      return null;
    }

    state = const AsyncValue.loading();

    // The repository future loads bundled JSON and can reject, so it
    // stays inside the guard or state strands in loading forever.
    // The daily summary is written inside the logAction transaction,
    // so only analytics remain as follow-up work here.
    final result = await AsyncValue.guard(() async {
      final actionLogRepo = await ref.read(actionLogRepositoryProvider.future);
      return actionLogRepo.logAction(
        userId: user.uid,
        action: action,
        languageCode: languageCode,
        note: note,
      );
    });

    if (result.hasError) {
      appLogger.error(
        'ActionLog: logAction failed',
        error: result.error,
        stackTrace: result.stackTrace,
      );
    }

    if (result.hasValue && result.asData?.value != null) {
      // The chart/stats providers are keyed on the user id (not the
      // whole user doc) to avoid re-querying on every doc change, so
      // refresh them explicitly at the one moment their data moves.
      if (ref.mounted) {
        ref
          ..invalidate(co2StatsProvider)
          ..invalidate(co2TrendDataProvider)
          ..invalidate(co2CategoryDataProvider)
          ..invalidate(monthCalendarDataProvider);
      }

      // Telemetry must never gate the points animation, which fires as
      // soon as this method returns.
      unawaited(_logAnalytics(action, result.asData?.value));
    }

    if (!ref.mounted) return result.asData?.value;
    state = result;
    return result.asData?.value;
  }

  Future<void> _logAnalytics(
    ActionModel action,
    ActionLogResult? result,
  ) async {
    if (!ref.mounted) return;
    final analytics = ref.read(analyticsServiceProvider);
    try {
      await analytics.logActionLogged(
        actionId: action.id,
        category: action.category,
        points: action.points,
        co2Grams: action.co2Grams,
        sdgs: action.relatedSdgs,
      );
      if (result?.shouldShowMilestone ?? false) {
        await analytics.logStreakMilestone(days: result!.newStreakDays);
      }
    } on Exception catch (e) {
      appLogger.error('ActionLog: analytics failed', error: e);
    }
  }
}
