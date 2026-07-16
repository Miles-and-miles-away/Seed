// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdg_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and caches SDG goal data from JSON.

@ProviderFor(sdgGoalsData)
final sdgGoalsDataProvider = SdgGoalsDataProvider._();

/// Loads and caches SDG goal data from JSON.

final class SdgGoalsDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<SdgGoalsData>,
          SdgGoalsData,
          FutureOr<SdgGoalsData>
        >
    with $FutureModifier<SdgGoalsData>, $FutureProvider<SdgGoalsData> {
  /// Loads and caches SDG goal data from JSON.
  SdgGoalsDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sdgGoalsDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sdgGoalsDataHash();

  @$internal
  @override
  $FutureProviderElement<SdgGoalsData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SdgGoalsData> create(Ref ref) {
    return sdgGoalsData(ref);
  }
}

String _$sdgGoalsDataHash() => r'e59077305b6d6ec14f641d73095b16d15ded125a';

/// Loads and caches SDG resource data from JSON.
///
/// keepAlive: static bundled data; autoDispose would re-parse the
/// asset on every screen revisit.

@ProviderFor(sdgResourcesData)
final sdgResourcesDataProvider = SdgResourcesDataProvider._();

/// Loads and caches SDG resource data from JSON.
///
/// keepAlive: static bundled data; autoDispose would re-parse the
/// asset on every screen revisit.

final class SdgResourcesDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, List<SdgResource>>>,
          Map<int, List<SdgResource>>,
          FutureOr<Map<int, List<SdgResource>>>
        >
    with
        $FutureModifier<Map<int, List<SdgResource>>>,
        $FutureProvider<Map<int, List<SdgResource>>> {
  /// Loads and caches SDG resource data from JSON.
  ///
  /// keepAlive: static bundled data; autoDispose would re-parse the
  /// asset on every screen revisit.
  SdgResourcesDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sdgResourcesDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sdgResourcesDataHash();

  @$internal
  @override
  $FutureProviderElement<Map<int, List<SdgResource>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, List<SdgResource>>> create(Ref ref) {
    return sdgResourcesData(ref);
  }
}

String _$sdgResourcesDataHash() => r'da8ee1965a30685ca10692c6183a44a1bfbe0fe7';

/// Loads and caches SDG target data from JSON.
///
/// keepAlive: static bundled data; autoDispose would re-parse the
/// 120 KB asset on every screen revisit.

@ProviderFor(sdgTargetsData)
final sdgTargetsDataProvider = SdgTargetsDataProvider._();

/// Loads and caches SDG target data from JSON.
///
/// keepAlive: static bundled data; autoDispose would re-parse the
/// 120 KB asset on every screen revisit.

final class SdgTargetsDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<int, List<SdgTarget>>>,
          Map<int, List<SdgTarget>>,
          FutureOr<Map<int, List<SdgTarget>>>
        >
    with
        $FutureModifier<Map<int, List<SdgTarget>>>,
        $FutureProvider<Map<int, List<SdgTarget>>> {
  /// Loads and caches SDG target data from JSON.
  ///
  /// keepAlive: static bundled data; autoDispose would re-parse the
  /// 120 KB asset on every screen revisit.
  SdgTargetsDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sdgTargetsDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sdgTargetsDataHash();

  @$internal
  @override
  $FutureProviderElement<Map<int, List<SdgTarget>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, List<SdgTarget>>> create(Ref ref) {
    return sdgTargetsData(ref);
  }
}

String _$sdgTargetsDataHash() => r'e2c8047d415d9b4442dfac6eba639af7ed0f5a66';
