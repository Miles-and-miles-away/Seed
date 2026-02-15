import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../../shared/services/analytics_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../progress/data/repositories/progress_repository.dart';
import '../../data/datasources/action_library_remote_datasource.dart';
import '../../data/datasources/action_log_remote_datasource.dart';
import '../../data/models/action_log_model.dart';
import '../../data/models/action_model.dart';
import '../../data/repositories/action_library_repository.dart';
import '../../data/repositories/action_log_repository.dart';
import '../../domain/enums/action_category.dart';
import '../../domain/enums/action_sort_option.dart';

export '../../data/repositories/action_log_repository.dart' show ActionLogResult;
export '../../domain/enums/action_sort_option.dart' show ActionSortOption;

part 'actions_providers.g.dart';

// =============================================================================
// Data Source Providers
// =============================================================================

@riverpod
ActionLibraryRemoteDataSource actionLibraryDataSource(Ref ref) {
  return ActionLibraryRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
  );
}

@riverpod
ActionLogRemoteDataSource actionLogDataSource(Ref ref) {
  return ActionLogRemoteDataSourceImpl(
    firestore: ref.watch(firestoreProvider),
  );
}

// =============================================================================
// Repository Providers
// =============================================================================

@riverpod
ActionLibraryRepository actionLibraryRepository(Ref ref) {
  return ActionLibraryRepository(
    dataSource: ref.watch(actionLibraryDataSourceProvider),
  );
}

@riverpod
ActionLogRepository actionLogRepository(Ref ref) {
  return ActionLogRepository(
    dataSource: ref.watch(actionLogDataSourceProvider),
    firestore: ref.watch(firestoreProvider),
  );
}

// =============================================================================
// Stream Providers
// =============================================================================

/// Watches all active actions from the action library.
@riverpod
Stream<List<ActionModel>> actionLibrary(Ref ref) {
  return ref.watch(actionLibraryRepositoryProvider).watchActions();
}

/// Watches action logs for the current user.
@riverpod
Stream<List<ActionLogModel>> userActionLogs(Ref ref) {
  final userAsync = ref.watch(currentUserProvider);

  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return ref.watch(actionLogRepositoryProvider).watchUserActionLogs(user.uid);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
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

  void clear() {
    state = null;
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
@Riverpod(keepAlive: true)
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

/// Gets today's action logs for the current user.
///
/// Used by smart reminders to check if user has logged an action today.
@riverpod
Future<List<ActionLogModel>> todayActions(Ref ref) async {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.asData?.value;
  if (user == null) return [];

  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);

  final logs = await ref.watch(userActionLogsProvider.future);
  return logs.where((log) => log.loggedAt.isAfter(startOfDay)).toList();
}

/// User's language code, selected from the user document
/// to avoid recomputing filters on unrelated user changes.
final userLanguageCodeProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider).asData?.value;
  return user?.language ?? 'en';
});

/// Filtered and sorted actions based on selected filters.
@riverpod
AsyncValue<List<ActionModel>> filteredActions(Ref ref) {
  final actionsAsync = ref.watch(actionLibraryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery =
      ref.watch(actionSearchQueryProvider).toLowerCase();
  final sortOption = ref.watch(selectedSortOptionProvider);
  final selectedSdg = ref.watch(selectedSdgFilterProvider);
  final lang = ref.watch(userLanguageCodeProvider);

  return actionsAsync.whenData((actions) {
    var filtered = actions;

    // Filter by category
    if (selectedCategory != null) {
      filtered = filtered
          .where(
            (a) => a.category == selectedCategory.name,
          )
          .toList();
    }

    // Filter by SDG
    if (selectedSdg != null) {
      filtered = filtered
          .where(
            (a) => a.relatedSdgs
                .contains(selectedSdg.toString()),
          )
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((a) {
        return a.nameEn
                .toLowerCase()
                .contains(searchQuery) ||
            a.nameJa
                .toLowerCase()
                .contains(searchQuery) ||
            a.nameEs
                .toLowerCase()
                .contains(searchQuery) ||
            a.descriptionEn
                .toLowerCase()
                .contains(searchQuery) ||
            a.descriptionJa
                .toLowerCase()
                .contains(searchQuery) ||
            a.descriptionEs
                .toLowerCase()
                .contains(searchQuery);
      }).toList();
    }

    return _sortActions(filtered, sortOption, lang);
  });
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
        (a, b) => a.name(languageCode)
            .compareTo(b.name(languageCode)),
      );
    case ActionSortOption.alphabeticalDesc:
      sorted.sort(
        (a, b) => b.name(languageCode)
            .compareTo(a.name(languageCode)),
      );
    case ActionSortOption.co2HighToLow:
      sorted.sort(
        (a, b) => b.co2Grams.compareTo(a.co2Grams),
      );
    case ActionSortOption.co2LowToHigh:
      sorted.sort(
        (a, b) => a.co2Grams.compareTo(b.co2Grams),
      );
    case ActionSortOption.pointsHighToLow:
      sorted.sort(
        (a, b) => b.points.compareTo(a.points),
      );
    case ActionSortOption.pointsLowToHigh:
      sorted.sort(
        (a, b) => a.points.compareTo(b.points),
      );
  }

  return sorted;
}

// =============================================================================
// Action Log Notifier
// =============================================================================

/// Notifier that handles logging actions.
@riverpod
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
    AppLogger.debug('ActionLog: logAction called for ${action.nameEn}');
    state = const AsyncValue.loading();

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

    // Capture repositories before async operations
    final actionLogRepo = ref.read(actionLogRepositoryProvider);
    final progressRepo = ref.read(progressRepositoryProvider);

    final result = await AsyncValue.guard(() async {
      return actionLogRepo.logAction(
            userId: user.uid,
            action: action,
            languageCode: languageCode,
            note: note,
          );
    });

    // Update daily summary for progress tracking and log analytics
    if (result.hasValue && result.asData?.value != null) {
      final sdgNumbers = action.relatedSdgs
          .map(int.tryParse)
          .whereType<int>()
          .toList();

      AppLogger.debug('ActionLog: Calling recordAction for progress tracking');
      try {
        await progressRepo.recordAction(
              userId: user.uid,
              points: action.points,
              co2Grams: action.co2Grams,
              sdgNumbers: sdgNumbers,
            );
        AppLogger.debug('ActionLog: recordAction completed');

        // Track analytics event
        await AnalyticsService.instance.logActionLogged(
          actionId: action.id,
          category: action.category,
          points: action.points,
          co2Grams: action.co2Grams,
          sdgs: action.relatedSdgs,
        );

        // Track streak milestone if applicable
        final actionResult = result.asData?.value;
        if (actionResult?.shouldShowMilestone ?? false) {
          await AnalyticsService.instance.logStreakMilestone(
            days: actionResult!.newStreakDays,
          );
        }
      } on Exception catch (e) {
        AppLogger.error('ActionLog: recordAction failed', error: e);
      }
    }

    if (!ref.mounted) return result.asData?.value;
    state = result;
    return result.asData?.value;
  }

  /// Resets the state after showing confirmation.
  void reset() {
    state = const AsyncValue.data(null);
  }
}
