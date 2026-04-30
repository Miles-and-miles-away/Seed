// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dailySummaryRemoteDataSource)
const dailySummaryRemoteDataSourceProvider =
    DailySummaryRemoteDataSourceProvider._();

final class DailySummaryRemoteDataSourceProvider extends $FunctionalProvider<
    DailySummaryRemoteDataSource,
    DailySummaryRemoteDataSource,
    DailySummaryRemoteDataSource> with $Provider<DailySummaryRemoteDataSource> {
  const DailySummaryRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dailySummaryRemoteDataSourceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dailySummaryRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<DailySummaryRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DailySummaryRemoteDataSource create(Ref ref) {
    return dailySummaryRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailySummaryRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailySummaryRemoteDataSource>(value),
    );
  }
}

String _$dailySummaryRemoteDataSourceHash() =>
    r'b9d29e359623237698fe0930c63f7e42d00d17bc';

@ProviderFor(progressRepository)
const progressRepositoryProvider = ProgressRepositoryProvider._();

final class ProgressRepositoryProvider extends $FunctionalProvider<
    ProgressRepository,
    ProgressRepository,
    ProgressRepository> with $Provider<ProgressRepository> {
  const ProgressRepositoryProvider._()
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
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

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
    r'502739b259ce7fb20113cb6d656f7952ff08856a';

/// Stream of today's summary for the Rainbow Sun visualization.

@ProviderFor(todaySummary)
const todaySummaryProvider = TodaySummaryProvider._();

/// Stream of today's summary for the Rainbow Sun visualization.

final class TodaySummaryProvider extends $FunctionalProvider<
        AsyncValue<DailySummaryModel?>,
        DailySummaryModel?,
        Stream<DailySummaryModel?>>
    with
        $FutureModifier<DailySummaryModel?>,
        $StreamProvider<DailySummaryModel?> {
  /// Stream of today's summary for the Rainbow Sun visualization.
  const TodaySummaryProvider._()
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
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DailySummaryModel?> create(Ref ref) {
    return todaySummary(ref);
  }
}

String _$todaySummaryHash() => r'78b79acbe1d5d6d751bdaabd08b808790e6838bf';

/// User's daily goal target from their profile.

@ProviderFor(dailyGoalTarget)
const dailyGoalTargetProvider = DailyGoalTargetProvider._();

/// User's daily goal target from their profile.

final class DailyGoalTargetProvider
    extends $FunctionalProvider<int?, int?, int?> with $Provider<int?> {
  /// User's daily goal target from their profile.
  const DailyGoalTargetProvider._()
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

String _$dailyGoalTargetHash() => r'423f4e73583f0dc1f47ff9ef65154efe0157c1db';

/// Whether the user needs to set up their daily goal target.

@ProviderFor(needsDailyTargetSetup)
const needsDailyTargetSetupProvider = NeedsDailyTargetSetupProvider._();

/// Whether the user needs to set up their daily goal target.

final class NeedsDailyTargetSetupProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Whether the user needs to set up their daily goal target.
  const NeedsDailyTargetSetupProvider._()
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
    r'd6cfcc6a2e8e8343d6770e462d0237dbf842e8a0';

/// Currently selected month for the calendar view.

@ProviderFor(SelectedMonth)
const selectedMonthProvider = SelectedMonthProvider._();

/// Currently selected month for the calendar view.
final class SelectedMonthProvider
    extends $NotifierProvider<SelectedMonth, DateTime> {
  /// Currently selected month for the calendar view.
  const SelectedMonthProvider._()
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
    final created = build();
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<DateTime, DateTime>, DateTime, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// Calendar data for the selected month.

@ProviderFor(monthCalendarData)
const monthCalendarDataProvider = MonthCalendarDataProvider._();

/// Calendar data for the selected month.

final class MonthCalendarDataProvider extends $FunctionalProvider<
        AsyncValue<List<CalendarDayData>>,
        List<CalendarDayData>,
        FutureOr<List<CalendarDayData>>>
    with
        $FutureModifier<List<CalendarDayData>>,
        $FutureProvider<List<CalendarDayData>> {
  /// Calendar data for the selected month.
  const MonthCalendarDataProvider._()
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
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<CalendarDayData>> create(Ref ref) {
    return monthCalendarData(ref);
  }
}

String _$monthCalendarDataHash() => r'79aea9a6cf1278cda037f8ee2b44c80883cffbe5';

/// Notifier to save the daily goal target.

@ProviderFor(DailyTargetNotifier)
const dailyTargetProvider = DailyTargetNotifierProvider._();

/// Notifier to save the daily goal target.
final class DailyTargetNotifierProvider
    extends $NotifierProvider<DailyTargetNotifier, AsyncValue<void>> {
  /// Notifier to save the daily goal target.
  const DailyTargetNotifierProvider._()
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
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
