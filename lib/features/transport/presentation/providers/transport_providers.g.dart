// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All transport modes from the bundled dataset.

@ProviderFor(transportModes)
final transportModesProvider = TransportModesProvider._();

/// All transport modes from the bundled dataset.

final class TransportModesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransportMode>>,
          List<TransportMode>,
          FutureOr<List<TransportMode>>
        >
    with
        $FutureModifier<List<TransportMode>>,
        $FutureProvider<List<TransportMode>> {
  /// All transport modes from the bundled dataset.
  TransportModesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transportModesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transportModesHash();

  @$internal
  @override
  $FutureProviderElement<List<TransportMode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TransportMode>> create(Ref ref) {
    return transportModes(ref);
  }
}

String _$transportModesHash() => r'd1868de92a7bafbaef6fb8a067d95051aed9b995';

/// Dataset metadata (scope statement, grid factor) for the
/// methodology sheet (Phase 8.4).

@ProviderFor(transportMetadata)
final transportMetadataProvider = TransportMetadataProvider._();

/// Dataset metadata (scope statement, grid factor) for the
/// methodology sheet (Phase 8.4).

final class TransportMetadataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Dataset metadata (scope statement, grid factor) for the
  /// methodology sheet (Phase 8.4).
  TransportMetadataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transportMetadataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transportMetadataHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return transportMetadata(ref);
  }
}

String _$transportMetadataHash() => r'6e4dbd514c3c52b2094a6722da59b0a61906f269';

/// Modes indexed by id for calculator lookups.

@ProviderFor(transportModesById)
final transportModesByIdProvider = TransportModesByIdProvider._();

/// Modes indexed by id for calculator lookups.

final class TransportModesByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, TransportMode>>,
          Map<String, TransportMode>,
          FutureOr<Map<String, TransportMode>>
        >
    with
        $FutureModifier<Map<String, TransportMode>>,
        $FutureProvider<Map<String, TransportMode>> {
  /// Modes indexed by id for calculator lookups.
  TransportModesByIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transportModesByIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transportModesByIdHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, TransportMode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, TransportMode>> create(Ref ref) {
    return transportModesById(ref);
  }
}

String _$transportModesByIdHash() =>
    r'9ed7e5ca91341a1894b6c5d00c47777ebe7c95cb';

/// Cities available for the distance-prefill pickers.

@ProviderFor(transportCities)
final transportCitiesProvider = TransportCitiesProvider._();

/// Cities available for the distance-prefill pickers.

final class TransportCitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<City>>,
          List<City>,
          FutureOr<List<City>>
        >
    with $FutureModifier<List<City>>, $FutureProvider<List<City>> {
  /// Cities available for the distance-prefill pickers.
  TransportCitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transportCitiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transportCitiesHash();

  @$internal
  @override
  $FutureProviderElement<List<City>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<City>> create(Ref ref) {
    return transportCities(ref);
  }
}

String _$transportCitiesHash() => r'7eb54f75951d5328c05d3a4ad3e9e05d425225b3';

/// Fixed landmass crossings (rail tunnels, ferry corridors).

@ProviderFor(transportCityLinks)
final transportCityLinksProvider = TransportCityLinksProvider._();

/// Fixed landmass crossings (rail tunnels, ferry corridors).

final class TransportCityLinksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CityLink>>,
          List<CityLink>,
          FutureOr<List<CityLink>>
        >
    with $FutureModifier<List<CityLink>>, $FutureProvider<List<CityLink>> {
  /// Fixed landmass crossings (rail tunnels, ferry corridors).
  TransportCityLinksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transportCityLinksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transportCityLinksHash();

  @$internal
  @override
  $FutureProviderElement<List<CityLink>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CityLink>> create(Ref ref) {
    return transportCityLinks(ref);
  }
}

String _$transportCityLinksHash() =>
    r'a256fd97d805ff0fc54b35040873dec9761dcd27';

/// Same-mass city pairs whose straight line crosses open water.

@ProviderFor(transportWaterBlockedPairs)
final transportWaterBlockedPairsProvider =
    TransportWaterBlockedPairsProvider._();

/// Same-mass city pairs whose straight line crosses open water.

final class TransportWaterBlockedPairsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          FutureOr<Set<String>>
        >
    with $FutureModifier<Set<String>>, $FutureProvider<Set<String>> {
  /// Same-mass city pairs whose straight line crosses open water.
  TransportWaterBlockedPairsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transportWaterBlockedPairsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transportWaterBlockedPairsHash();

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    return transportWaterBlockedPairs(ref);
  }
}

String _$transportWaterBlockedPairsHash() =>
    r'5388c618a77f268972660a8032ba682e4add0309';

/// Suggested distances per journey kind for a city pair.
///
/// Threads the water-blocked pair set into [suggestedDistancesKm]
/// (review requirement): without it, cross-water same-mass pairs like
/// Helsinki-Tallinn would get fictional ground/cycling estimates.
/// Every UI consumer must go through this provider, never call
/// [suggestedDistancesKm] with its silent empty default.

@ProviderFor(citySuggestions)
final citySuggestionsProvider = CitySuggestionsFamily._();

/// Suggested distances per journey kind for a city pair.
///
/// Threads the water-blocked pair set into [suggestedDistancesKm]
/// (review requirement): without it, cross-water same-mass pairs like
/// Helsinki-Tallinn would get fictional ground/cycling estimates.
/// Every UI consumer must go through this provider, never call
/// [suggestedDistancesKm] with its silent empty default.

final class CitySuggestionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, double>>,
          Map<String, double>,
          FutureOr<Map<String, double>>
        >
    with
        $FutureModifier<Map<String, double>>,
        $FutureProvider<Map<String, double>> {
  /// Suggested distances per journey kind for a city pair.
  ///
  /// Threads the water-blocked pair set into [suggestedDistancesKm]
  /// (review requirement): without it, cross-water same-mass pairs like
  /// Helsinki-Tallinn would get fictional ground/cycling estimates.
  /// Every UI consumer must go through this provider, never call
  /// [suggestedDistancesKm] with its silent empty default.
  CitySuggestionsProvider._({
    required CitySuggestionsFamily super.from,
    required (City, City) super.argument,
  }) : super(
         retry: null,
         name: r'citySuggestionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$citySuggestionsHash();

  @override
  String toString() {
    return r'citySuggestionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, double>> create(Ref ref) {
    final argument = this.argument as (City, City);
    return citySuggestions(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CitySuggestionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$citySuggestionsHash() => r'810f6c616dc9e1da385162c1f0a8fb8d261119b8';

/// Suggested distances per journey kind for a city pair.
///
/// Threads the water-blocked pair set into [suggestedDistancesKm]
/// (review requirement): without it, cross-water same-mass pairs like
/// Helsinki-Tallinn would get fictional ground/cycling estimates.
/// Every UI consumer must go through this provider, never call
/// [suggestedDistancesKm] with its silent empty default.

final class CitySuggestionsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Map<String, double>>, (City, City)> {
  CitySuggestionsFamily._()
    : super(
        retry: null,
        name: r'citySuggestionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Suggested distances per journey kind for a city pair.
  ///
  /// Threads the water-blocked pair set into [suggestedDistancesKm]
  /// (review requirement): without it, cross-water same-mass pairs like
  /// Helsinki-Tallinn would get fictional ground/cycling estimates.
  /// Every UI consumer must go through this provider, never call
  /// [suggestedDistancesKm] with its silent empty default.

  CitySuggestionsProvider call(City from, City to) =>
      CitySuggestionsProvider._(argument: (from, to), from: this);

  @override
  String toString() => r'citySuggestionsProvider';
}

/// Ephemeral journey legs for the builder screen.
///
/// autoDispose by design: journeys are screen state, never persisted
/// (Phase 8 plan), so leaving the calculator resets the journey.

@ProviderFor(JourneyBuilder)
final journeyBuilderProvider = JourneyBuilderProvider._();

/// Ephemeral journey legs for the builder screen.
///
/// autoDispose by design: journeys are screen state, never persisted
/// (Phase 8 plan), so leaving the calculator resets the journey.
final class JourneyBuilderProvider
    extends $NotifierProvider<JourneyBuilder, List<JourneyLeg>> {
  /// Ephemeral journey legs for the builder screen.
  ///
  /// autoDispose by design: journeys are screen state, never persisted
  /// (Phase 8 plan), so leaving the calculator resets the journey.
  JourneyBuilderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journeyBuilderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journeyBuilderHash();

  @$internal
  @override
  JourneyBuilder create() => JourneyBuilder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<JourneyLeg> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<JourneyLeg>>(value),
    );
  }
}

String _$journeyBuilderHash() => r'ea8947c9987ed04abfa81d1702efe4033c1672bb';

/// Ephemeral journey legs for the builder screen.
///
/// autoDispose by design: journeys are screen state, never persisted
/// (Phase 8 plan), so leaving the calculator resets the journey.

abstract class _$JourneyBuilder extends $Notifier<List<JourneyLeg>> {
  List<JourneyLeg> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<JourneyLeg>, List<JourneyLeg>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<JourneyLeg>, List<JourneyLeg>>,
              List<JourneyLeg>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Snapshotted journeys staged for side-by-side comparison (8.3).
///
/// autoDispose like [JourneyBuilder]: comparisons are ephemeral
/// screen state, never persisted (Phase 8 plan). Each entry is a
/// full multi-leg journey snapshot, so a door-to-door flight option
/// keeps its airport legs.

@ProviderFor(JourneyComparison)
final journeyComparisonProvider = JourneyComparisonProvider._();

/// Snapshotted journeys staged for side-by-side comparison (8.3).
///
/// autoDispose like [JourneyBuilder]: comparisons are ephemeral
/// screen state, never persisted (Phase 8 plan). Each entry is a
/// full multi-leg journey snapshot, so a door-to-door flight option
/// keeps its airport legs.
final class JourneyComparisonProvider
    extends $NotifierProvider<JourneyComparison, List<List<JourneyLeg>>> {
  /// Snapshotted journeys staged for side-by-side comparison (8.3).
  ///
  /// autoDispose like [JourneyBuilder]: comparisons are ephemeral
  /// screen state, never persisted (Phase 8 plan). Each entry is a
  /// full multi-leg journey snapshot, so a door-to-door flight option
  /// keeps its airport legs.
  JourneyComparisonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journeyComparisonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journeyComparisonHash();

  @$internal
  @override
  JourneyComparison create() => JourneyComparison();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<List<JourneyLeg>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<List<JourneyLeg>>>(value),
    );
  }
}

String _$journeyComparisonHash() => r'd18eca737c52b0ff29a6a56e0024605876e676fc';

/// Snapshotted journeys staged for side-by-side comparison (8.3).
///
/// autoDispose like [JourneyBuilder]: comparisons are ephemeral
/// screen state, never persisted (Phase 8 plan). Each entry is a
/// full multi-leg journey snapshot, so a door-to-door flight option
/// keeps its airport legs.

abstract class _$JourneyComparison extends $Notifier<List<List<JourneyLeg>>> {
  List<List<JourneyLeg>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<List<List<JourneyLeg>>, List<List<JourneyLeg>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<List<JourneyLeg>>, List<List<JourneyLeg>>>,
              List<List<JourneyLeg>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
