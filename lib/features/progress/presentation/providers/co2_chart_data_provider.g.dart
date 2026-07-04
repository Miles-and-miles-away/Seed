// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'co2_chart_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Daily-points + average for the trend scatter chart.
///
/// The window is a rolling N-day range tied to the dashboard's
/// [TimePeriod] selection (7 / 30 / 90 days -- see
/// [TimePeriodRange.trendWindowDays]). Each daily summary in the
/// window contributes one point; missing days are simply absent.
/// The average is taken across days with data only -- folding in
/// implicit zeros would pull the line down for users who skip days.
/// One fetch of the trend window shared by the trend and category
/// charts (they previously each ran the identical query). Keyed on
/// the user id; refreshed explicitly after logging and at day change.

@ProviderFor(trendWindowSummaries)
final trendWindowSummariesProvider = TrendWindowSummariesFamily._();

/// Daily-points + average for the trend scatter chart.
///
/// The window is a rolling N-day range tied to the dashboard's
/// [TimePeriod] selection (7 / 30 / 90 days -- see
/// [TimePeriodRange.trendWindowDays]). Each daily summary in the
/// window contributes one point; missing days are simply absent.
/// The average is taken across days with data only -- folding in
/// implicit zeros would pull the line down for users who skip days.
/// One fetch of the trend window shared by the trend and category
/// charts (they previously each ran the identical query). Keyed on
/// the user id; refreshed explicitly after logging and at day change.

final class TrendWindowSummariesProvider extends $FunctionalProvider<
        AsyncValue<List<DailySummaryModel>>,
        List<DailySummaryModel>,
        FutureOr<List<DailySummaryModel>>>
    with
        $FutureModifier<List<DailySummaryModel>>,
        $FutureProvider<List<DailySummaryModel>> {
  /// Daily-points + average for the trend scatter chart.
  ///
  /// The window is a rolling N-day range tied to the dashboard's
  /// [TimePeriod] selection (7 / 30 / 90 days -- see
  /// [TimePeriodRange.trendWindowDays]). Each daily summary in the
  /// window contributes one point; missing days are simply absent.
  /// The average is taken across days with data only -- folding in
  /// implicit zeros would pull the line down for users who skip days.
  /// One fetch of the trend window shared by the trend and category
  /// charts (they previously each ran the identical query). Keyed on
  /// the user id; refreshed explicitly after logging and at day change.
  TrendWindowSummariesProvider._(
      {required TrendWindowSummariesFamily super.from,
      required TimePeriod super.argument})
      : super(
          retry: null,
          name: r'trendWindowSummariesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$trendWindowSummariesHash();

  @override
  String toString() {
    return r'trendWindowSummariesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DailySummaryModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<DailySummaryModel>> create(Ref ref) {
    final argument = this.argument as TimePeriod;
    return trendWindowSummaries(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TrendWindowSummariesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trendWindowSummariesHash() =>
    r'143cdd5145ce40efca72dee7f5bd147d9704f133';

/// Daily-points + average for the trend scatter chart.
///
/// The window is a rolling N-day range tied to the dashboard's
/// [TimePeriod] selection (7 / 30 / 90 days -- see
/// [TimePeriodRange.trendWindowDays]). Each daily summary in the
/// window contributes one point; missing days are simply absent.
/// The average is taken across days with data only -- folding in
/// implicit zeros would pull the line down for users who skip days.
/// One fetch of the trend window shared by the trend and category
/// charts (they previously each ran the identical query). Keyed on
/// the user id; refreshed explicitly after logging and at day change.

final class TrendWindowSummariesFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<DailySummaryModel>>,
            TimePeriod> {
  TrendWindowSummariesFamily._()
      : super(
          retry: null,
          name: r'trendWindowSummariesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Daily-points + average for the trend scatter chart.
  ///
  /// The window is a rolling N-day range tied to the dashboard's
  /// [TimePeriod] selection (7 / 30 / 90 days -- see
  /// [TimePeriodRange.trendWindowDays]). Each daily summary in the
  /// window contributes one point; missing days are simply absent.
  /// The average is taken across days with data only -- folding in
  /// implicit zeros would pull the line down for users who skip days.
  /// One fetch of the trend window shared by the trend and category
  /// charts (they previously each ran the identical query). Keyed on
  /// the user id; refreshed explicitly after logging and at day change.

  TrendWindowSummariesProvider call(
    TimePeriod period,
  ) =>
      TrendWindowSummariesProvider._(argument: period, from: this);

  @override
  String toString() => r'trendWindowSummariesProvider';
}

@ProviderFor(co2TrendData)
final co2TrendDataProvider = Co2TrendDataFamily._();

final class Co2TrendDataProvider extends $FunctionalProvider<
        AsyncValue<Co2TrendData>, Co2TrendData, FutureOr<Co2TrendData>>
    with $FutureModifier<Co2TrendData>, $FutureProvider<Co2TrendData> {
  Co2TrendDataProvider._(
      {required Co2TrendDataFamily super.from,
      required TimePeriod super.argument})
      : super(
          retry: null,
          name: r'co2TrendDataProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$co2TrendDataHash();

  @override
  String toString() {
    return r'co2TrendDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Co2TrendData> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Co2TrendData> create(Ref ref) {
    final argument = this.argument as TimePeriod;
    return co2TrendData(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Co2TrendDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$co2TrendDataHash() => r'd339ace592ba2ca56b2009a1a3768c4034d8bb92';

final class Co2TrendDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Co2TrendData>, TimePeriod> {
  Co2TrendDataFamily._()
      : super(
          retry: null,
          name: r'co2TrendDataProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  Co2TrendDataProvider call(
    TimePeriod period,
  ) =>
      Co2TrendDataProvider._(argument: period, from: this);

  @override
  String toString() => r'co2TrendDataProvider';
}

/// Top-N category breakdown for the donut, aggregated across daily
/// summaries in the same trend window as [co2TrendData].
///
/// Categories beyond the top [_kTopCategoryCount] roll into a single
/// "Other" slice so the donut stays legible. Unknown category keys
/// (e.g. data written by a future build that introduced a new
/// category) flow into Other rather than being dropped.

@ProviderFor(co2CategoryData)
final co2CategoryDataProvider = Co2CategoryDataFamily._();

/// Top-N category breakdown for the donut, aggregated across daily
/// summaries in the same trend window as [co2TrendData].
///
/// Categories beyond the top [_kTopCategoryCount] roll into a single
/// "Other" slice so the donut stays legible. Unknown category keys
/// (e.g. data written by a future build that introduced a new
/// category) flow into Other rather than being dropped.

final class Co2CategoryDataProvider extends $FunctionalProvider<
        AsyncValue<Co2CategoryData>, Co2CategoryData, FutureOr<Co2CategoryData>>
    with $FutureModifier<Co2CategoryData>, $FutureProvider<Co2CategoryData> {
  /// Top-N category breakdown for the donut, aggregated across daily
  /// summaries in the same trend window as [co2TrendData].
  ///
  /// Categories beyond the top [_kTopCategoryCount] roll into a single
  /// "Other" slice so the donut stays legible. Unknown category keys
  /// (e.g. data written by a future build that introduced a new
  /// category) flow into Other rather than being dropped.
  Co2CategoryDataProvider._(
      {required Co2CategoryDataFamily super.from,
      required TimePeriod super.argument})
      : super(
          retry: null,
          name: r'co2CategoryDataProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$co2CategoryDataHash();

  @override
  String toString() {
    return r'co2CategoryDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Co2CategoryData> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Co2CategoryData> create(Ref ref) {
    final argument = this.argument as TimePeriod;
    return co2CategoryData(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Co2CategoryDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$co2CategoryDataHash() => r'4fb62169425be95cd5531b04e6734efbcc88708d';

/// Top-N category breakdown for the donut, aggregated across daily
/// summaries in the same trend window as [co2TrendData].
///
/// Categories beyond the top [_kTopCategoryCount] roll into a single
/// "Other" slice so the donut stays legible. Unknown category keys
/// (e.g. data written by a future build that introduced a new
/// category) flow into Other rather than being dropped.

final class Co2CategoryDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Co2CategoryData>, TimePeriod> {
  Co2CategoryDataFamily._()
      : super(
          retry: null,
          name: r'co2CategoryDataProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Top-N category breakdown for the donut, aggregated across daily
  /// summaries in the same trend window as [co2TrendData].
  ///
  /// Categories beyond the top [_kTopCategoryCount] roll into a single
  /// "Other" slice so the donut stays legible. Unknown category keys
  /// (e.g. data written by a future build that introduced a new
  /// category) flow into Other rather than being dropped.

  Co2CategoryDataProvider call(
    TimePeriod period,
  ) =>
      Co2CategoryDataProvider._(argument: period, from: this);

  @override
  String toString() => r'co2CategoryDataProvider';
}
