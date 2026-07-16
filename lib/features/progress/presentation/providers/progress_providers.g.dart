// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(progressRepository)
final progressRepositoryProvider = ProgressRepositoryProvider._();

final class ProgressRepositoryProvider
    extends
        $FunctionalProvider<
          ProgressRepository,
          ProgressRepository,
          ProgressRepository
        >
    with $Provider<ProgressRepository> {
  ProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProgressRepository create(Ref ref) {
    return progressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressRepository>(value),
    );
  }
}

String _$progressRepositoryHash() =>
    r'7df2f1d27155e954dbc2bca3d8c4d84a2b9af969';

/// Loads and caches impact equivalency metadata (conversion factors
/// and source URLs) from the bundled JSON asset. Cached for the
/// lifetime of the app -- factors are static scientific constants.

@ProviderFor(impactEquivalenciesData)
final impactEquivalenciesDataProvider = ImpactEquivalenciesDataProvider._();

/// Loads and caches impact equivalency metadata (conversion factors
/// and source URLs) from the bundled JSON asset. Cached for the
/// lifetime of the app -- factors are static scientific constants.

final class ImpactEquivalenciesDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EquivalencyMetadata>>,
          List<EquivalencyMetadata>,
          FutureOr<List<EquivalencyMetadata>>
        >
    with
        $FutureModifier<List<EquivalencyMetadata>>,
        $FutureProvider<List<EquivalencyMetadata>> {
  /// Loads and caches impact equivalency metadata (conversion factors
  /// and source URLs) from the bundled JSON asset. Cached for the
  /// lifetime of the app -- factors are static scientific constants.
  ImpactEquivalenciesDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'impactEquivalenciesDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$impactEquivalenciesDataHash();

  @$internal
  @override
  $FutureProviderElement<List<EquivalencyMetadata>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EquivalencyMetadata>> create(Ref ref) {
    return impactEquivalenciesData(ref);
  }
}

String _$impactEquivalenciesDataHash() =>
    r'cb3716f2bff898e31491b195a97a1f6b868f8a99';

/// Stream of today's summary for the Rainbow Sun visualization.
///
/// Keyed on the user id so the Firestore listener survives user-doc
/// writes; dayChangeProvider invalidates it at midnight.

@ProviderFor(todaySummary)
final todaySummaryProvider = TodaySummaryProvider._();

/// Stream of today's summary for the Rainbow Sun visualization.
///
/// Keyed on the user id so the Firestore listener survives user-doc
/// writes; dayChangeProvider invalidates it at midnight.

final class TodaySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailySummaryModel?>,
          DailySummaryModel?,
          Stream<DailySummaryModel?>
        >
    with
        $FutureModifier<DailySummaryModel?>,
        $StreamProvider<DailySummaryModel?> {
  /// Stream of today's summary for the Rainbow Sun visualization.
  ///
  /// Keyed on the user id so the Firestore listener survives user-doc
  /// writes; dayChangeProvider invalidates it at midnight.
  TodaySummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaySummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaySummaryHash();

  @$internal
  @override
  $StreamProviderElement<DailySummaryModel?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DailySummaryModel?> create(Ref ref) {
    return todaySummary(ref);
  }
}

String _$todaySummaryHash() => r'3b0e8e06868a051c4f75fc407ea646c9c0e01bc4';

/// User's daily goal target from their profile.

@ProviderFor(dailyGoalTarget)
final dailyGoalTargetProvider = DailyGoalTargetProvider._();

/// User's daily goal target from their profile.

final class DailyGoalTargetProvider
    extends $FunctionalProvider<int?, int?, int?>
    with $Provider<int?> {
  /// User's daily goal target from their profile.
  DailyGoalTargetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyGoalTargetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyGoalTargetHash();

  @$internal
  @override
  $ProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    return dailyGoalTarget(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$dailyGoalTargetHash() => r'b0aa8c19aa93ace7fcee6f73b9d2123c46c096c5';

/// Whether the user needs to set up their daily goal target.

@ProviderFor(needsDailyTargetSetup)
final needsDailyTargetSetupProvider = NeedsDailyTargetSetupProvider._();

/// Whether the user needs to set up their daily goal target.

final class NeedsDailyTargetSetupProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the user needs to set up their daily goal target.
  NeedsDailyTargetSetupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'needsDailyTargetSetupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$needsDailyTargetSetupHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return needsDailyTargetSetup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$needsDailyTargetSetupHash() =>
    r'396ab74d05b5178ba75d1e1e45bed1296dec1186';

/// Currently selected month for the calendar view.

@ProviderFor(SelectedMonth)
final selectedMonthProvider = SelectedMonthProvider._();

/// Currently selected month for the calendar view.
final class SelectedMonthProvider
    extends $NotifierProvider<SelectedMonth, DateTime> {
  /// Currently selected month for the calendar view.
  SelectedMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedMonthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedMonthHash();

  @$internal
  @override
  SelectedMonth create() => SelectedMonth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$selectedMonthHash() => r'fbe04c080dc8d5be5573000e2ea8215aada171ee';

/// Currently selected month for the calendar view.

abstract class _$SelectedMonth extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Calendar data for the selected month.
///
/// Keyed on the user id; refreshed explicitly after logging an action
/// and at day change instead of on every user-doc write.

@ProviderFor(monthCalendarData)
final monthCalendarDataProvider = MonthCalendarDataProvider._();

/// Calendar data for the selected month.
///
/// Keyed on the user id; refreshed explicitly after logging an action
/// and at day change instead of on every user-doc write.

final class MonthCalendarDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CalendarDayData>>,
          List<CalendarDayData>,
          FutureOr<List<CalendarDayData>>
        >
    with
        $FutureModifier<List<CalendarDayData>>,
        $FutureProvider<List<CalendarDayData>> {
  /// Calendar data for the selected month.
  ///
  /// Keyed on the user id; refreshed explicitly after logging an action
  /// and at day change instead of on every user-doc write.
  MonthCalendarDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthCalendarDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthCalendarDataHash();

  @$internal
  @override
  $FutureProviderElement<List<CalendarDayData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CalendarDayData>> create(Ref ref) {
    return monthCalendarData(ref);
  }
}

String _$monthCalendarDataHash() => r'66be10b48ed6b37d02a5d819ea6049fb80c546bf';

/// Notifier to save the daily goal target.

@ProviderFor(DailyTargetNotifier)
final dailyTargetProvider = DailyTargetNotifierProvider._();

/// Notifier to save the daily goal target.
final class DailyTargetNotifierProvider
    extends $NotifierProvider<DailyTargetNotifier, AsyncValue<void>> {
  /// Notifier to save the daily goal target.
  DailyTargetNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyTargetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyTargetNotifierHash();

  @$internal
  @override
  DailyTargetNotifier create() => DailyTargetNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$dailyTargetNotifierHash() =>
    r'7df191488d27a38d5b60cd2fdb1781a1892baecd';

/// Notifier to save the daily goal target.

abstract class _$DailyTargetNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
