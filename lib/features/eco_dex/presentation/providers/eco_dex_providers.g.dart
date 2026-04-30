// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eco_dex_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and caches all Eco-Dex data from the JSON asset.

@ProviderFor(ecoDexData)
const ecoDexDataProvider = EcoDexDataProvider._();

/// Loads and caches all Eco-Dex data from the JSON asset.

final class EcoDexDataProvider extends $FunctionalProvider<
        AsyncValue<EcoDexData>, EcoDexData, FutureOr<EcoDexData>>
    with $FutureModifier<EcoDexData>, $FutureProvider<EcoDexData> {
  /// Loads and caches all Eco-Dex data from the JSON asset.
  const EcoDexDataProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ecoDexDataProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoDexDataHash();

  @$internal
  @override
  $FutureProviderElement<EcoDexData> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<EcoDexData> create(Ref ref) {
    return ecoDexData(ref);
  }
}

String _$ecoDexDataHash() => r'a1ee8494b609712631df9d2873785985649518e5';

/// Set of entry icon names whose SVG ships in the asset bundle.
/// Missing entries fall back to a blank white placeholder.

@ProviderFor(ecoDexAvailableIcons)
const ecoDexAvailableIconsProvider = EcoDexAvailableIconsProvider._();

/// Set of entry icon names whose SVG ships in the asset bundle.
/// Missing entries fall back to a blank white placeholder.

final class EcoDexAvailableIconsProvider extends $FunctionalProvider<
        AsyncValue<Set<String>>, Set<String>, FutureOr<Set<String>>>
    with $FutureModifier<Set<String>>, $FutureProvider<Set<String>> {
  /// Set of entry icon names whose SVG ships in the asset bundle.
  /// Missing entries fall back to a blank white placeholder.
  const EcoDexAvailableIconsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ecoDexAvailableIconsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoDexAvailableIconsHash();

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    return ecoDexAvailableIcons(ref);
  }
}

String _$ecoDexAvailableIconsHash() =>
    r'adb3e9de8e0158e04487963d620b8a0f87da2f26';

/// User's set of discovered Eco-Dex entry IDs.

@ProviderFor(ecoDexDiscovered)
const ecoDexDiscoveredProvider = EcoDexDiscoveredProvider._();

/// User's set of discovered Eco-Dex entry IDs.

final class EcoDexDiscoveredProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// User's set of discovered Eco-Dex entry IDs.
  const EcoDexDiscoveredProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ecoDexDiscoveredProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoDexDiscoveredHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return ecoDexDiscovered(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$ecoDexDiscoveredHash() => r'a48613669be2aab8d257538840b81af8b1b38a74';

/// Total discovered count for progress display.

@ProviderFor(ecoDexDiscoveredCount)
const ecoDexDiscoveredCountProvider = EcoDexDiscoveredCountProvider._();

/// Total discovered count for progress display.

final class EcoDexDiscoveredCountProvider
    extends $FunctionalProvider<int, int, int> with $Provider<int> {
  /// Total discovered count for progress display.
  const EcoDexDiscoveredCountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ecoDexDiscoveredCountProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoDexDiscoveredCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return ecoDexDiscoveredCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$ecoDexDiscoveredCountHash() =>
    r'c0d1c295887e2df439d3e0baff3d3539629bad35';

/// All entries with their discovered state.

@ProviderFor(ecoDexEntries)
const ecoDexEntriesProvider = EcoDexEntriesProvider._();

/// All entries with their discovered state.

final class EcoDexEntriesProvider extends $FunctionalProvider<
        AsyncValue<List<EcoDexEntryState>>,
        List<EcoDexEntryState>,
        FutureOr<List<EcoDexEntryState>>>
    with
        $FutureModifier<List<EcoDexEntryState>>,
        $FutureProvider<List<EcoDexEntryState>> {
  /// All entries with their discovered state.
  const EcoDexEntriesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ecoDexEntriesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoDexEntriesHash();

  @$internal
  @override
  $FutureProviderElement<List<EcoDexEntryState>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<EcoDexEntryState>> create(Ref ref) {
    return ecoDexEntries(ref);
  }
}

String _$ecoDexEntriesHash() => r'092b47c9b4ae6a353a043530dac1df0187464997';

/// Entries filtered by category.

@ProviderFor(ecoDexEntriesByCategory)
const ecoDexEntriesByCategoryProvider = EcoDexEntriesByCategoryFamily._();

/// Entries filtered by category.

final class EcoDexEntriesByCategoryProvider extends $FunctionalProvider<
        AsyncValue<List<EcoDexEntryState>>,
        List<EcoDexEntryState>,
        FutureOr<List<EcoDexEntryState>>>
    with
        $FutureModifier<List<EcoDexEntryState>>,
        $FutureProvider<List<EcoDexEntryState>> {
  /// Entries filtered by category.
  const EcoDexEntriesByCategoryProvider._(
      {required EcoDexEntriesByCategoryFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'ecoDexEntriesByCategoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoDexEntriesByCategoryHash();

  @override
  String toString() {
    return r'ecoDexEntriesByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<EcoDexEntryState>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<EcoDexEntryState>> create(Ref ref) {
    final argument = this.argument as String;
    return ecoDexEntriesByCategory(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EcoDexEntriesByCategoryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ecoDexEntriesByCategoryHash() =>
    r'fa38eb907b6e87eddf9e0f4cd6c05c469987f548';

/// Entries filtered by category.

final class EcoDexEntriesByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<EcoDexEntryState>>, String> {
  const EcoDexEntriesByCategoryFamily._()
      : super(
          retry: null,
          name: r'ecoDexEntriesByCategoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Entries filtered by category.

  EcoDexEntriesByCategoryProvider call(
    String category,
  ) =>
      EcoDexEntriesByCategoryProvider._(argument: category, from: this);

  @override
  String toString() => r'ecoDexEntriesByCategoryProvider';
}

/// Per-category progress (discovered / total).

@ProviderFor(ecoDexCategoryProgress)
const ecoDexCategoryProgressProvider = EcoDexCategoryProgressProvider._();

/// Per-category progress (discovered / total).

final class EcoDexCategoryProgressProvider extends $FunctionalProvider<
        AsyncValue<
            Map<
                String,
                (
                  int,
                  int,
                )>>,
        Map<
            String,
            (
              int,
              int,
            )>,
        FutureOr<
            Map<
                String,
                (
                  int,
                  int,
                )>>>
    with
        $FutureModifier<
            Map<
                String,
                (
                  int,
                  int,
                )>>,
        $FutureProvider<
            Map<
                String,
                (
                  int,
                  int,
                )>> {
  /// Per-category progress (discovered / total).
  const EcoDexCategoryProgressProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ecoDexCategoryProgressProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoDexCategoryProgressHash();

  @$internal
  @override
  $FutureProviderElement<
      Map<
          String,
          (
            int,
            int,
          )>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<
      Map<
          String,
          (
            int,
            int,
          )>> create(Ref ref) {
    return ecoDexCategoryProgress(ref);
  }
}

String _$ecoDexCategoryProgressHash() =>
    r'0590842c3a00d58ab033185747a2ee8ca6e4de89';

/// Evaluates which entries a user can unlock but hasn't yet.
/// Returns IDs of newly unlockable entries.

@ProviderFor(ecoDexNewUnlocks)
const ecoDexNewUnlocksProvider = EcoDexNewUnlocksProvider._();

/// Evaluates which entries a user can unlock but hasn't yet.
/// Returns IDs of newly unlockable entries.

final class EcoDexNewUnlocksProvider extends $FunctionalProvider<
        AsyncValue<List<String>>, List<String>, FutureOr<List<String>>>
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Evaluates which entries a user can unlock but hasn't yet.
  /// Returns IDs of newly unlockable entries.
  const EcoDexNewUnlocksProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ecoDexNewUnlocksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoDexNewUnlocksHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return ecoDexNewUnlocks(ref);
  }
}

String _$ecoDexNewUnlocksHash() => r'2f1d4624b3e6020a2df7f680e62218152d381661';

/// Notifier for discovering new Eco-Dex entries.

@ProviderFor(EcoDexDiscoveryNotifier)
const ecoDexDiscoveryProvider = EcoDexDiscoveryNotifierProvider._();

/// Notifier for discovering new Eco-Dex entries.
final class EcoDexDiscoveryNotifierProvider
    extends $NotifierProvider<EcoDexDiscoveryNotifier, AsyncValue<void>> {
  /// Notifier for discovering new Eco-Dex entries.
  const EcoDexDiscoveryNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ecoDexDiscoveryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoDexDiscoveryNotifierHash();

  @$internal
  @override
  EcoDexDiscoveryNotifier create() => EcoDexDiscoveryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$ecoDexDiscoveryNotifierHash() =>
    r'3fd4b46a764c3faf4098d91fb7db1871ebbf9daa';

/// Notifier for discovering new Eco-Dex entries.

abstract class _$EcoDexDiscoveryNotifier extends $Notifier<AsyncValue<void>> {
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
