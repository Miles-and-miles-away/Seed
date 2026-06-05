// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actions_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(actionLibraryDataSource)
final actionLibraryDataSourceProvider = ActionLibraryDataSourceProvider._();

final class ActionLibraryDataSourceProvider extends $FunctionalProvider<
        ActionLibraryRemoteDataSource,
        ActionLibraryRemoteDataSource,
        ActionLibraryRemoteDataSource>
    with $Provider<ActionLibraryRemoteDataSource> {
  ActionLibraryDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'actionLibraryDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$actionLibraryDataSourceHash();

  @$internal
  @override
  $ProviderElement<ActionLibraryRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActionLibraryRemoteDataSource create(Ref ref) {
    return actionLibraryDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActionLibraryRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<ActionLibraryRemoteDataSource>(value),
    );
  }
}

String _$actionLibraryDataSourceHash() =>
    r'82b4d4fceb21ae648a4ff100fcb4ed6ed1f0ebff';

@ProviderFor(actionLogDataSource)
final actionLogDataSourceProvider = ActionLogDataSourceProvider._();

final class ActionLogDataSourceProvider extends $FunctionalProvider<
    ActionLogRemoteDataSource,
    ActionLogRemoteDataSource,
    ActionLogRemoteDataSource> with $Provider<ActionLogRemoteDataSource> {
  ActionLogDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'actionLogDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$actionLogDataSourceHash();

  @$internal
  @override
  $ProviderElement<ActionLogRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActionLogRemoteDataSource create(Ref ref) {
    return actionLogDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActionLogRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActionLogRemoteDataSource>(value),
    );
  }
}

String _$actionLogDataSourceHash() =>
    r'ed4bb939692d0a319faaff43e461b84968208a64';

@ProviderFor(actionLibraryRepository)
final actionLibraryRepositoryProvider = ActionLibraryRepositoryProvider._();

final class ActionLibraryRepositoryProvider extends $FunctionalProvider<
    ActionLibraryRepository,
    ActionLibraryRepository,
    ActionLibraryRepository> with $Provider<ActionLibraryRepository> {
  ActionLibraryRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'actionLibraryRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$actionLibraryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ActionLibraryRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActionLibraryRepository create(Ref ref) {
    return actionLibraryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActionLibraryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActionLibraryRepository>(value),
    );
  }
}

String _$actionLibraryRepositoryHash() =>
    r'93944e9e8fe9e2e07b24f5f2451bfea69df10a39';

@ProviderFor(actionLogRepository)
final actionLogRepositoryProvider = ActionLogRepositoryProvider._();

final class ActionLogRepositoryProvider extends $FunctionalProvider<
        AsyncValue<ActionLogRepository>,
        ActionLogRepository,
        FutureOr<ActionLogRepository>>
    with
        $FutureModifier<ActionLogRepository>,
        $FutureProvider<ActionLogRepository> {
  ActionLogRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'actionLogRepositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$actionLogRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<ActionLogRepository> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ActionLogRepository> create(Ref ref) {
    return actionLogRepository(ref);
  }
}

String _$actionLogRepositoryHash() =>
    r'e5c036818672f0c11a16a7920163b031ee7b42c0';

/// Watches all active actions from the action library.

@ProviderFor(actionLibrary)
final actionLibraryProvider = ActionLibraryProvider._();

/// Watches all active actions from the action library.

final class ActionLibraryProvider extends $FunctionalProvider<
        AsyncValue<List<ActionModel>>,
        List<ActionModel>,
        Stream<List<ActionModel>>>
    with
        $FutureModifier<List<ActionModel>>,
        $StreamProvider<List<ActionModel>> {
  /// Watches all active actions from the action library.
  ActionLibraryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'actionLibraryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$actionLibraryHash();

  @$internal
  @override
  $StreamProviderElement<List<ActionModel>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<ActionModel>> create(Ref ref) {
    return actionLibrary(ref);
  }
}

String _$actionLibraryHash() => r'65fe8aa5eb4fe7180c97bc5b3ec9f5b56845e419';

/// Watches action logs for the current user.

@ProviderFor(userActionLogs)
final userActionLogsProvider = UserActionLogsProvider._();

/// Watches action logs for the current user.

final class UserActionLogsProvider extends $FunctionalProvider<
        AsyncValue<List<ActionLogModel>>,
        List<ActionLogModel>,
        Stream<List<ActionLogModel>>>
    with
        $FutureModifier<List<ActionLogModel>>,
        $StreamProvider<List<ActionLogModel>> {
  /// Watches action logs for the current user.
  UserActionLogsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'userActionLogsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userActionLogsHash();

  @$internal
  @override
  $StreamProviderElement<List<ActionLogModel>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<ActionLogModel>> create(Ref ref) {
    return userActionLogs(ref);
  }
}

String _$userActionLogsHash() => r'27348877b12e183f817aa0d0d4255320913a6639';

/// Currently selected action category for filtering.
/// Null means "All" categories.

@ProviderFor(SelectedCategory)
final selectedCategoryProvider = SelectedCategoryProvider._();

/// Currently selected action category for filtering.
/// Null means "All" categories.
final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, ActionCategory?> {
  /// Currently selected action category for filtering.
  /// Null means "All" categories.
  SelectedCategoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedCategoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActionCategory? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActionCategory?>(value),
    );
  }
}

String _$selectedCategoryHash() => r'd4f7b106428b48065da9b81c72b3e8a222bb7a47';

/// Currently selected action category for filtering.
/// Null means "All" categories.

abstract class _$SelectedCategory extends $Notifier<ActionCategory?> {
  ActionCategory? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ActionCategory?, ActionCategory?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ActionCategory?, ActionCategory?>,
        ActionCategory?,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Search query for filtering actions.

@ProviderFor(ActionSearchQuery)
final actionSearchQueryProvider = ActionSearchQueryProvider._();

/// Search query for filtering actions.
final class ActionSearchQueryProvider
    extends $NotifierProvider<ActionSearchQuery, String> {
  /// Search query for filtering actions.
  ActionSearchQueryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'actionSearchQueryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$actionSearchQueryHash();

  @$internal
  @override
  ActionSearchQuery create() => ActionSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$actionSearchQueryHash() => r'b8c857e6a68e9b3e2c8919a9aa1d6b86e8b68f67';

/// Search query for filtering actions.

abstract class _$ActionSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Currently selected sort option for the action library.

@ProviderFor(SelectedSortOption)
final selectedSortOptionProvider = SelectedSortOptionProvider._();

/// Currently selected sort option for the action library.
final class SelectedSortOptionProvider
    extends $NotifierProvider<SelectedSortOption, ActionSortOption> {
  /// Currently selected sort option for the action library.
  SelectedSortOptionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedSortOptionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedSortOptionHash();

  @$internal
  @override
  SelectedSortOption create() => SelectedSortOption();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActionSortOption value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActionSortOption>(value),
    );
  }
}

String _$selectedSortOptionHash() =>
    r'04c8692800b8e1efda2f0514834323264de5a75a';

/// Currently selected sort option for the action library.

abstract class _$SelectedSortOption extends $Notifier<ActionSortOption> {
  ActionSortOption build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ActionSortOption, ActionSortOption>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ActionSortOption, ActionSortOption>,
        ActionSortOption,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

/// Selected SDG for filtering actions.
/// Null means "All" SDGs.

@ProviderFor(SelectedSdgFilter)
final selectedSdgFilterProvider = SelectedSdgFilterProvider._();

/// Selected SDG for filtering actions.
/// Null means "All" SDGs.
final class SelectedSdgFilterProvider
    extends $NotifierProvider<SelectedSdgFilter, int?> {
  /// Selected SDG for filtering actions.
  /// Null means "All" SDGs.
  SelectedSdgFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedSdgFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedSdgFilterHash();

  @$internal
  @override
  SelectedSdgFilter create() => SelectedSdgFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$selectedSdgFilterHash() => r'0332b8af7aa6bfb7ba1651a580ee2eabdff6e43a';

/// Selected SDG for filtering actions.
/// Null means "All" SDGs.

abstract class _$SelectedSdgFilter extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<int?, int?>, int?, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}

/// Gets today's action logs for the current user.
///
/// Used by smart reminders to check if user has logged an action today.

@ProviderFor(todayActions)
final todayActionsProvider = TodayActionsProvider._();

/// Gets today's action logs for the current user.
///
/// Used by smart reminders to check if user has logged an action today.

final class TodayActionsProvider extends $FunctionalProvider<
        AsyncValue<List<ActionLogModel>>,
        List<ActionLogModel>,
        FutureOr<List<ActionLogModel>>>
    with
        $FutureModifier<List<ActionLogModel>>,
        $FutureProvider<List<ActionLogModel>> {
  /// Gets today's action logs for the current user.
  ///
  /// Used by smart reminders to check if user has logged an action today.
  TodayActionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todayActionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todayActionsHash();

  @$internal
  @override
  $FutureProviderElement<List<ActionLogModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActionLogModel>> create(Ref ref) {
    return todayActions(ref);
  }
}

String _$todayActionsHash() => r'db26cc3b9364a6a9706a91fd1c915aa79f85d3dd';

/// Filtered actions (category, SDG, search) -- no sort.
/// Separated so that changing sort doesn't re-filter.

@ProviderFor(baseFilteredActions)
final baseFilteredActionsProvider = BaseFilteredActionsProvider._();

/// Filtered actions (category, SDG, search) -- no sort.
/// Separated so that changing sort doesn't re-filter.

final class BaseFilteredActionsProvider extends $FunctionalProvider<
        AsyncValue<List<ActionModel>>,
        AsyncValue<List<ActionModel>>,
        AsyncValue<List<ActionModel>>>
    with $Provider<AsyncValue<List<ActionModel>>> {
  /// Filtered actions (category, SDG, search) -- no sort.
  /// Separated so that changing sort doesn't re-filter.
  BaseFilteredActionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'baseFilteredActionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$baseFilteredActionsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<ActionModel>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<List<ActionModel>> create(Ref ref) {
    return baseFilteredActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ActionModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<ActionModel>>>(value),
    );
  }
}

String _$baseFilteredActionsHash() =>
    r'6631c1849ec23de7611061957ccaad125716246f';

/// Filtered + sorted actions. Only re-sorts when sort
/// option or language changes; filter changes propagate
/// through baseFilteredActions.

@ProviderFor(filteredActions)
final filteredActionsProvider = FilteredActionsProvider._();

/// Filtered + sorted actions. Only re-sorts when sort
/// option or language changes; filter changes propagate
/// through baseFilteredActions.

final class FilteredActionsProvider extends $FunctionalProvider<
        AsyncValue<List<ActionModel>>,
        AsyncValue<List<ActionModel>>,
        AsyncValue<List<ActionModel>>>
    with $Provider<AsyncValue<List<ActionModel>>> {
  /// Filtered + sorted actions. Only re-sorts when sort
  /// option or language changes; filter changes propagate
  /// through baseFilteredActions.
  FilteredActionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'filteredActionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$filteredActionsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<ActionModel>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<List<ActionModel>> create(Ref ref) {
    return filteredActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ActionModel>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<List<ActionModel>>>(value),
    );
  }
}

String _$filteredActionsHash() => r'd6e1da63de401f7dbc9d3f0be6bc4138a93e3174';

/// Notifier that handles logging actions.

@ProviderFor(ActionLogNotifier)
final actionLogProvider = ActionLogNotifierProvider._();

/// Notifier that handles logging actions.
final class ActionLogNotifierProvider
    extends $NotifierProvider<ActionLogNotifier, AsyncValue<ActionLogResult?>> {
  /// Notifier that handles logging actions.
  ActionLogNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'actionLogProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$actionLogNotifierHash();

  @$internal
  @override
  ActionLogNotifier create() => ActionLogNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ActionLogResult?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ActionLogResult?>>(value),
    );
  }
}

String _$actionLogNotifierHash() => r'b945f684ce40a11fbc6adaf77ab606992ef68efe';

/// Notifier that handles logging actions.

abstract class _$ActionLogNotifier
    extends $Notifier<AsyncValue<ActionLogResult?>> {
  AsyncValue<ActionLogResult?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<ActionLogResult?>, AsyncValue<ActionLogResult?>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ActionLogResult?>, AsyncValue<ActionLogResult?>>,
        AsyncValue<ActionLogResult?>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
