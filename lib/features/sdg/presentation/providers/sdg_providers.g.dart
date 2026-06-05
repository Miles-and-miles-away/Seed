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

final class SdgGoalsDataProvider extends $FunctionalProvider<
        AsyncValue<SdgGoalsData>, SdgGoalsData, FutureOr<SdgGoalsData>>
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
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<SdgGoalsData> create(Ref ref) {
    return sdgGoalsData(ref);
  }
}

String _$sdgGoalsDataHash() => r'e59077305b6d6ec14f641d73095b16d15ded125a';

/// Loads and caches SDG resource data from JSON.

@ProviderFor(sdgResourcesData)
final sdgResourcesDataProvider = SdgResourcesDataProvider._();

/// Loads and caches SDG resource data from JSON.

final class SdgResourcesDataProvider extends $FunctionalProvider<
        AsyncValue<Map<int, List<SdgResource>>>,
        Map<int, List<SdgResource>>,
        FutureOr<Map<int, List<SdgResource>>>>
    with
        $FutureModifier<Map<int, List<SdgResource>>>,
        $FutureProvider<Map<int, List<SdgResource>>> {
  /// Loads and caches SDG resource data from JSON.
  SdgResourcesDataProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sdgResourcesDataProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sdgResourcesDataHash();

  @$internal
  @override
  $FutureProviderElement<Map<int, List<SdgResource>>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, List<SdgResource>>> create(Ref ref) {
    return sdgResourcesData(ref);
  }
}

String _$sdgResourcesDataHash() => r'a15a13d7b19303e7cf98322f73535319dd3fccf4';

/// Loads and caches SDG target data from JSON.

@ProviderFor(sdgTargetsData)
final sdgTargetsDataProvider = SdgTargetsDataProvider._();

/// Loads and caches SDG target data from JSON.

final class SdgTargetsDataProvider extends $FunctionalProvider<
        AsyncValue<Map<int, List<SdgTarget>>>,
        Map<int, List<SdgTarget>>,
        FutureOr<Map<int, List<SdgTarget>>>>
    with
        $FutureModifier<Map<int, List<SdgTarget>>>,
        $FutureProvider<Map<int, List<SdgTarget>>> {
  /// Loads and caches SDG target data from JSON.
  SdgTargetsDataProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'sdgTargetsDataProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$sdgTargetsDataHash();

  @$internal
  @override
  $FutureProviderElement<Map<int, List<SdgTarget>>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<int, List<SdgTarget>>> create(Ref ref) {
    return sdgTargetsData(ref);
  }
}

String _$sdgTargetsDataHash() => r'2faa3534c247911281e728a746fa949a8d8e2675';
