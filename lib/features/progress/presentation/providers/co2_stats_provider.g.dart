// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'co2_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Aggregated CO2 totals for the Impact dashboard.
///
/// Computes the sum of `totalCo2Grams` across daily summaries in the
/// requested period and the equivalent previous-period total used for
/// the period-over-period comparison badge.
///
/// For [TimePeriod.allTime] we read `user.totalCo2Grams` directly
/// (already aggregated on the user doc) and treat the previous period
/// as zero-width so the comparison badge stays hidden.
/// Keyed on the user id (not the whole user doc) so logging an action
/// does not implicitly re-run the queries; ActionLogNotifier and
/// dayChangeProvider invalidate this explicitly when the data moves.

@ProviderFor(co2Stats)
final co2StatsProvider = Co2StatsFamily._();

/// Aggregated CO2 totals for the Impact dashboard.
///
/// Computes the sum of `totalCo2Grams` across daily summaries in the
/// requested period and the equivalent previous-period total used for
/// the period-over-period comparison badge.
///
/// For [TimePeriod.allTime] we read `user.totalCo2Grams` directly
/// (already aggregated on the user doc) and treat the previous period
/// as zero-width so the comparison badge stays hidden.
/// Keyed on the user id (not the whole user doc) so logging an action
/// does not implicitly re-run the queries; ActionLogNotifier and
/// dayChangeProvider invalidate this explicitly when the data moves.

final class Co2StatsProvider extends $FunctionalProvider<AsyncValue<Co2Stats>,
        Co2Stats, FutureOr<Co2Stats>>
    with $FutureModifier<Co2Stats>, $FutureProvider<Co2Stats> {
  /// Aggregated CO2 totals for the Impact dashboard.
  ///
  /// Computes the sum of `totalCo2Grams` across daily summaries in the
  /// requested period and the equivalent previous-period total used for
  /// the period-over-period comparison badge.
  ///
  /// For [TimePeriod.allTime] we read `user.totalCo2Grams` directly
  /// (already aggregated on the user doc) and treat the previous period
  /// as zero-width so the comparison badge stays hidden.
  /// Keyed on the user id (not the whole user doc) so logging an action
  /// does not implicitly re-run the queries; ActionLogNotifier and
  /// dayChangeProvider invalidate this explicitly when the data moves.
  Co2StatsProvider._(
      {required Co2StatsFamily super.from, required TimePeriod super.argument})
      : super(
          retry: null,
          name: r'co2StatsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$co2StatsHash();

  @override
  String toString() {
    return r'co2StatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Co2Stats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Co2Stats> create(Ref ref) {
    final argument = this.argument as TimePeriod;
    return co2Stats(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Co2StatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$co2StatsHash() => r'754b3b5e6d1fc62e8a741011e3a14a2998673eaa';

/// Aggregated CO2 totals for the Impact dashboard.
///
/// Computes the sum of `totalCo2Grams` across daily summaries in the
/// requested period and the equivalent previous-period total used for
/// the period-over-period comparison badge.
///
/// For [TimePeriod.allTime] we read `user.totalCo2Grams` directly
/// (already aggregated on the user doc) and treat the previous period
/// as zero-width so the comparison badge stays hidden.
/// Keyed on the user id (not the whole user doc) so logging an action
/// does not implicitly re-run the queries; ActionLogNotifier and
/// dayChangeProvider invalidate this explicitly when the data moves.

final class Co2StatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Co2Stats>, TimePeriod> {
  Co2StatsFamily._()
      : super(
          retry: null,
          name: r'co2StatsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Aggregated CO2 totals for the Impact dashboard.
  ///
  /// Computes the sum of `totalCo2Grams` across daily summaries in the
  /// requested period and the equivalent previous-period total used for
  /// the period-over-period comparison badge.
  ///
  /// For [TimePeriod.allTime] we read `user.totalCo2Grams` directly
  /// (already aggregated on the user doc) and treat the previous period
  /// as zero-width so the comparison badge stays hidden.
  /// Keyed on the user id (not the whole user doc) so logging an action
  /// does not implicitly re-run the queries; ActionLogNotifier and
  /// dayChangeProvider invalidate this explicitly when the data moves.

  Co2StatsProvider call(
    TimePeriod period,
  ) =>
      Co2StatsProvider._(argument: period, from: this);

  @override
  String toString() => r'co2StatsProvider';
}
