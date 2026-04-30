// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdg_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Aggregated stats for a specific SDG from the
/// denormalized sdgStats map on the user document.

@ProviderFor(sdgStats)
const sdgStatsProvider = SdgStatsFamily._();

/// Aggregated stats for a specific SDG from the
/// denormalized sdgStats map on the user document.

final class SdgStatsProvider
    extends $FunctionalProvider<SdgStats, SdgStats, SdgStats>
    with $Provider<SdgStats> {
  /// Aggregated stats for a specific SDG from the
  /// denormalized sdgStats map on the user document.
  const SdgStatsProvider._(
      {required SdgStatsFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'sdgStatsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sdgStatsHash();

  @override
  String toString() {
    return r'sdgStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<SdgStats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SdgStats create(Ref ref) {
    final argument = this.argument as int;
    return sdgStats(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SdgStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SdgStats>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SdgStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sdgStatsHash() => r'83d105172f465f50195f9f82a90495fa57b05a38';

/// Aggregated stats for a specific SDG from the
/// denormalized sdgStats map on the user document.

final class SdgStatsFamily extends $Family
    with $FunctionalFamilyOverride<SdgStats, int> {
  const SdgStatsFamily._()
      : super(
          retry: null,
          name: r'sdgStatsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Aggregated stats for a specific SDG from the
  /// denormalized sdgStats map on the user document.

  SdgStatsProvider call(
    int sdgNumber,
  ) =>
      SdgStatsProvider._(argument: sdgNumber, from: this);

  @override
  String toString() => r'sdgStatsProvider';
}

/// Filters the action library to only actions related
/// to a specific SDG.

@ProviderFor(sdgRelatedActions)
const sdgRelatedActionsProvider = SdgRelatedActionsFamily._();

/// Filters the action library to only actions related
/// to a specific SDG.

final class SdgRelatedActionsProvider extends $FunctionalProvider<
    List<ActionModel>,
    List<ActionModel>,
    List<ActionModel>> with $Provider<List<ActionModel>> {
  /// Filters the action library to only actions related
  /// to a specific SDG.
  const SdgRelatedActionsProvider._(
      {required SdgRelatedActionsFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'sdgRelatedActionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sdgRelatedActionsHash();

  @override
  String toString() {
    return r'sdgRelatedActionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<ActionModel>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<ActionModel> create(Ref ref) {
    final argument = this.argument as int;
    return sdgRelatedActions(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ActionModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ActionModel>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SdgRelatedActionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sdgRelatedActionsHash() => r'926fc5e2e214f61ee6031c57460c7a2c9274c278';

/// Filters the action library to only actions related
/// to a specific SDG.

final class SdgRelatedActionsFamily extends $Family
    with $FunctionalFamilyOverride<List<ActionModel>, int> {
  const SdgRelatedActionsFamily._()
      : super(
          retry: null,
          name: r'sdgRelatedActionsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Filters the action library to only actions related
  /// to a specific SDG.

  SdgRelatedActionsProvider call(
    int sdgNumber,
  ) =>
      SdgRelatedActionsProvider._(argument: sdgNumber, from: this);

  @override
  String toString() => r'sdgRelatedActionsProvider';
}
