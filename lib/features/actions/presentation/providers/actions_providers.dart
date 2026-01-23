import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/action_library_remote_datasource.dart';
import '../../data/datasources/action_log_remote_datasource.dart';
import '../../data/models/action_log_model.dart';
import '../../data/models/action_model.dart';
import '../../data/repositories/action_library_repository.dart';
import '../../data/repositories/action_log_repository.dart';
import '../../domain/enums/action_category.dart';

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

/// Filtered actions based on selected category and search query.
@riverpod
List<ActionModel> filteredActions(Ref ref) {
  final actionsAsync = ref.watch(actionLibraryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(actionSearchQueryProvider).toLowerCase();

  return actionsAsync.when(
    data: (actions) {
      var filtered = actions;

      // Filter by category
      if (selectedCategory != null) {
        filtered = filtered
            .where((a) => a.category == selectedCategory.name)
            .toList();
      }

      // Filter by search query
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where((a) {
          return a.nameEn.toLowerCase().contains(searchQuery) ||
              a.nameJa.toLowerCase().contains(searchQuery) ||
              a.descriptionEn.toLowerCase().contains(searchQuery) ||
              a.descriptionJa.toLowerCase().contains(searchQuery);
        }).toList();
      }

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

// =============================================================================
// Action Log Notifier
// =============================================================================

/// Notifier that handles logging actions.
@riverpod
class ActionLogNotifier extends _$ActionLogNotifier {
  @override
  AsyncValue<ActionLogModel?> build() => const AsyncValue.data(null);

  /// Logs an action for the current user.
  Future<ActionLogModel?> logAction(
    ActionModel action, {
    String? note,
    String languageCode = 'en',
  }) async {
    state = const AsyncValue.loading();

    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.asData?.value;
    if (user == null) {
      state = AsyncValue.error(
        Exception('User not authenticated'),
        StackTrace.current,
      );
      return null;
    }

    state = await AsyncValue.guard(() async {
      return ref.read(actionLogRepositoryProvider).logAction(
            userId: user.uid,
            action: action,
            languageCode: languageCode,
            note: note,
          );
    });

    return state.asData?.value;
  }

  /// Resets the state after showing confirmation.
  void reset() {
    state = const AsyncValue.data(null);
  }
}
