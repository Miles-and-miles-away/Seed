// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mascot_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and caches mascot species data from JSON.

@ProviderFor(mascotSpeciesData)
final mascotSpeciesDataProvider = MascotSpeciesDataProvider._();

/// Loads and caches mascot species data from JSON.

final class MascotSpeciesDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MascotSpeciesModel>>,
          List<MascotSpeciesModel>,
          FutureOr<List<MascotSpeciesModel>>
        >
    with
        $FutureModifier<List<MascotSpeciesModel>>,
        $FutureProvider<List<MascotSpeciesModel>> {
  /// Loads and caches mascot species data from JSON.
  MascotSpeciesDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotSpeciesDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotSpeciesDataHash();

  @$internal
  @override
  $FutureProviderElement<List<MascotSpeciesModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MascotSpeciesModel>> create(Ref ref) {
    return mascotSpeciesData(ref);
  }
}

String _$mascotSpeciesDataHash() => r'558b72453c2852607aff195d06d2725737cefa37';

@ProviderFor(mascotRepository)
final mascotRepositoryProvider = MascotRepositoryProvider._();

final class MascotRepositoryProvider
    extends
        $FunctionalProvider<
          MascotRepository,
          MascotRepository,
          MascotRepository
        >
    with $Provider<MascotRepository> {
  MascotRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotRepositoryHash();

  @$internal
  @override
  $ProviderElement<MascotRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MascotRepository create(Ref ref) {
    return mascotRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MascotRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MascotRepository>(value),
    );
  }
}

String _$mascotRepositoryHash() => r'16023de0e8a2ebc97e4ba784213f7b3181c4a0d6';

/// All mascots for the current user.
///
/// Derived from the user document already streamed by
/// [currentUserProvider]; opening a second Firestore listener on the
/// same document would only duplicate decode work.

@ProviderFor(allMascots)
final allMascotsProvider = AllMascotsProvider._();

/// All mascots for the current user.
///
/// Derived from the user document already streamed by
/// [currentUserProvider]; opening a second Firestore listener on the
/// same document would only duplicate decode work.

final class AllMascotsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MascotModel>>,
          List<MascotModel>,
          Stream<List<MascotModel>>
        >
    with
        $FutureModifier<List<MascotModel>>,
        $StreamProvider<List<MascotModel>> {
  /// All mascots for the current user.
  ///
  /// Derived from the user document already streamed by
  /// [currentUserProvider]; opening a second Firestore listener on the
  /// same document would only duplicate decode work.
  AllMascotsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allMascotsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allMascotsHash();

  @$internal
  @override
  $StreamProviderElement<List<MascotModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MascotModel>> create(Ref ref) {
    return allMascots(ref);
  }
}

String _$allMascotsHash() => r'cbef656f60a6cff78533a1b79d40205f8a238c7a';

/// The active mascot for the current user (derived, see [allMascots]).

@ProviderFor(activeMascot)
final activeMascotProvider = ActiveMascotProvider._();

/// The active mascot for the current user (derived, see [allMascots]).

final class ActiveMascotProvider
    extends
        $FunctionalProvider<
          AsyncValue<MascotModel?>,
          MascotModel?,
          Stream<MascotModel?>
        >
    with $FutureModifier<MascotModel?>, $StreamProvider<MascotModel?> {
  /// The active mascot for the current user (derived, see [allMascots]).
  ActiveMascotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeMascotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeMascotHash();

  @$internal
  @override
  $StreamProviderElement<MascotModel?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<MascotModel?> create(Ref ref) {
    return activeMascot(ref);
  }
}

String _$activeMascotHash() => r'd857a04e27f32eda2a13a28d708eceee2c52d930';

/// Whether the current user has at least one mascot.

@ProviderFor(hasMascot)
final hasMascotProvider = HasMascotProvider._();

/// Whether the current user has at least one mascot.

final class HasMascotProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the current user has at least one mascot.
  HasMascotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasMascotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasMascotHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasMascot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasMascotHash() => r'9eb4e7ea75e0d09e570e4047381f679a8341f7e2';

/// Species data for the active mascot.

@ProviderFor(activeSpecies)
final activeSpeciesProvider = ActiveSpeciesProvider._();

/// Species data for the active mascot.

final class ActiveSpeciesProvider
    extends
        $FunctionalProvider<
          MascotSpeciesModel?,
          MascotSpeciesModel?,
          MascotSpeciesModel?
        >
    with $Provider<MascotSpeciesModel?> {
  /// Species data for the active mascot.
  ActiveSpeciesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSpeciesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSpeciesHash();

  @$internal
  @override
  $ProviderElement<MascotSpeciesModel?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MascotSpeciesModel? create(Ref ref) {
    return activeSpecies(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MascotSpeciesModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MascotSpeciesModel?>(value),
    );
  }
}

String _$activeSpeciesHash() => r'5379e04b9409ff23e5e478d4835a4e808a997014';

/// Theme seed color for the active mascot's species (green fallback
/// when signed out or before data loads).

@ProviderFor(activeSpeciesThemeSeed)
final activeSpeciesThemeSeedProvider = ActiveSpeciesThemeSeedProvider._();

/// Theme seed color for the active mascot's species (green fallback
/// when signed out or before data loads).

final class ActiveSpeciesThemeSeedProvider
    extends $FunctionalProvider<Color, Color, Color>
    with $Provider<Color> {
  /// Theme seed color for the active mascot's species (green fallback
  /// when signed out or before data loads).
  ActiveSpeciesThemeSeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSpeciesThemeSeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSpeciesThemeSeedHash();

  @$internal
  @override
  $ProviderElement<Color> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Color create(Ref ref) {
    return activeSpeciesThemeSeed(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Color>(value),
    );
  }
}

String _$activeSpeciesThemeSeedHash() =>
    r'59bb1ad9e771b063f143a565a8a98c71d9d13063';

/// Evolution stage index (1-4) for the active mascot.
/// Computes species inline to avoid double-watching
/// activeMascotProvider through activeSpeciesProvider.

@ProviderFor(activeMascotStage)
final activeMascotStageProvider = ActiveMascotStageProvider._();

/// Evolution stage index (1-4) for the active mascot.
/// Computes species inline to avoid double-watching
/// activeMascotProvider through activeSpeciesProvider.

final class ActiveMascotStageProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Evolution stage index (1-4) for the active mascot.
  /// Computes species inline to avoid double-watching
  /// activeMascotProvider through activeSpeciesProvider.
  ActiveMascotStageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeMascotStageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeMascotStageHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return activeMascotStage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$activeMascotStageHash() => r'adc2ca84291b21e842fed4c5ad87901a8672b4c8';

/// Evolution stage data for the active mascot.

@ProviderFor(activeStageData)
final activeStageDataProvider = ActiveStageDataProvider._();

/// Evolution stage data for the active mascot.

final class ActiveStageDataProvider
    extends
        $FunctionalProvider<
          EvolutionStageModel?,
          EvolutionStageModel?,
          EvolutionStageModel?
        >
    with $Provider<EvolutionStageModel?> {
  /// Evolution stage data for the active mascot.
  ActiveStageDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeStageDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeStageDataHash();

  @$internal
  @override
  $ProviderElement<EvolutionStageModel?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EvolutionStageModel? create(Ref ref) {
    return activeStageData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EvolutionStageModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EvolutionStageModel?>(value),
    );
  }
}

String _$activeStageDataHash() => r'd898a7ef9f67061e8660462fe9aff94da41d0137';

/// Asset path for the active mascot's current stage.

@ProviderFor(activeMascotAssetPath)
final activeMascotAssetPathProvider = ActiveMascotAssetPathProvider._();

/// Asset path for the active mascot's current stage.

final class ActiveMascotAssetPathProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Asset path for the active mascot's current stage.
  ActiveMascotAssetPathProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeMascotAssetPathProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeMascotAssetPathHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return activeMascotAssetPath(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$activeMascotAssetPathHash() =>
    r'e29b607208175becf39eaeab8a9172405c4ec77b';

/// Next evolution stage for the active mascot, or null.

@ProviderFor(activeNextStageData)
final activeNextStageDataProvider = ActiveNextStageDataProvider._();

/// Next evolution stage for the active mascot, or null.

final class ActiveNextStageDataProvider
    extends
        $FunctionalProvider<
          EvolutionStageModel?,
          EvolutionStageModel?,
          EvolutionStageModel?
        >
    with $Provider<EvolutionStageModel?> {
  /// Next evolution stage for the active mascot, or null.
  ActiveNextStageDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeNextStageDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeNextStageDataHash();

  @$internal
  @override
  $ProviderElement<EvolutionStageModel?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EvolutionStageModel? create(Ref ref) {
    return activeNextStageData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EvolutionStageModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EvolutionStageModel?>(value),
    );
  }
}

String _$activeNextStageDataHash() =>
    r'edf4ec19b5dce58a66019d0f85886e4a54aa9cc3';

/// Whether the active mascot has a new unseen evolution.

@ProviderFor(hasNewEvolution)
final hasNewEvolutionProvider = HasNewEvolutionProvider._();

/// Whether the active mascot has a new unseen evolution.

final class HasNewEvolutionProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the active mascot has a new unseen evolution.
  HasNewEvolutionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasNewEvolutionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasNewEvolutionHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasNewEvolution(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasNewEvolutionHash() => r'52f45bafcaf7176144903155474ee3574f5c20b2';

/// The user's current egg (derived from user data).

@ProviderFor(currentEgg)
final currentEggProvider = CurrentEggProvider._();

/// The user's current egg (derived from user data).

final class CurrentEggProvider
    extends $FunctionalProvider<EggModel?, EggModel?, EggModel?>
    with $Provider<EggModel?> {
  /// The user's current egg (derived from user data).
  CurrentEggProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentEggProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentEggHash();

  @$internal
  @override
  $ProviderElement<EggModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EggModel? create(Ref ref) {
    return currentEgg(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EggModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EggModel?>(value),
    );
  }
}

String _$currentEggHash() => r'6e6cd7c8522d524ccd679c20be1119630c95eee1';

/// Whether the user has an egg.

@ProviderFor(hasEgg)
final hasEggProvider = HasEggProvider._();

/// Whether the user has an egg.

final class HasEggProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the user has an egg.
  HasEggProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasEggProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasEggHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasEgg(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasEggHash() => r'001d7c8b459b39dc8ed56e683a3fb21ae8804383';

/// Egg hatching progress (0.0 to 1.0).

@ProviderFor(eggHatchingProgress)
final eggHatchingProgressProvider = EggHatchingProgressProvider._();

/// Egg hatching progress (0.0 to 1.0).

final class EggHatchingProgressProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  /// Egg hatching progress (0.0 to 1.0).
  EggHatchingProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eggHatchingProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eggHatchingProgressHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return eggHatchingProgress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$eggHatchingProgressHash() =>
    r'1e21a80390cefe4ee20f0e6a3b17cfdc27588aac';

/// Whether to show the egg discovery celebration.
/// True if eggPendingDiscovery flag is set.

@ProviderFor(shouldShowEggDiscovery)
final shouldShowEggDiscoveryProvider = ShouldShowEggDiscoveryProvider._();

/// Whether to show the egg discovery celebration.
/// True if eggPendingDiscovery flag is set.

final class ShouldShowEggDiscoveryProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether to show the egg discovery celebration.
  /// True if eggPendingDiscovery flag is set.
  ShouldShowEggDiscoveryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shouldShowEggDiscoveryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shouldShowEggDiscoveryHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return shouldShowEggDiscovery(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$shouldShowEggDiscoveryHash() =>
    r'712e57b5753ed0e258dc43ec3bef0daaad4ee59a';

/// Localized name for the active mascot's stage.

@ProviderFor(stageLocalizedName)
final stageLocalizedNameProvider = StageLocalizedNameFamily._();

/// Localized name for the active mascot's stage.

final class StageLocalizedNameProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Localized name for the active mascot's stage.
  StageLocalizedNameProvider._({
    required StageLocalizedNameFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stageLocalizedNameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stageLocalizedNameHash();

  @override
  String toString() {
    return r'stageLocalizedNameProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as String;
    return stageLocalizedName(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StageLocalizedNameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stageLocalizedNameHash() =>
    r'50cc488cbfd5f20a70c3d1b9fdae6f2c61c2a20b';

/// Localized name for the active mascot's stage.

final class StageLocalizedNameFamily extends $Family
    with $FunctionalFamilyOverride<String?, String> {
  StageLocalizedNameFamily._()
    : super(
        retry: null,
        name: r'stageLocalizedNameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Localized name for the active mascot's stage.

  StageLocalizedNameProvider call(String locale) =>
      StageLocalizedNameProvider._(argument: locale, from: this);

  @override
  String toString() => r'stageLocalizedNameProvider';
}

@ProviderFor(MascotNotifier)
final mascotProvider = MascotNotifierProvider._();

final class MascotNotifierProvider
    extends $NotifierProvider<MascotNotifier, AsyncValue<void>> {
  MascotNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotNotifierHash();

  @$internal
  @override
  MascotNotifier create() => MascotNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$mascotNotifierHash() => r'b314ebb4e7d6be3d99dab09106dd2be9299f77d5';

abstract class _$MascotNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(MascotAnimationTrigger)
final mascotAnimationTriggerProvider = MascotAnimationTriggerProvider._();

final class MascotAnimationTriggerProvider
    extends $NotifierProvider<MascotAnimationTrigger, bool> {
  MascotAnimationTriggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotAnimationTriggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotAnimationTriggerHash();

  @$internal
  @override
  MascotAnimationTrigger create() => MascotAnimationTrigger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mascotAnimationTriggerHash() =>
    r'5a731cd1cd6cb04ba255ed8ef6f5d59e5a05b4fb';

abstract class _$MascotAnimationTrigger extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Fires the mascot smile animation, e.g. before opening the action log.
///
/// Rive-animated mascots play their smile timeline; static SVG mascots
/// ignore it.

@ProviderFor(MascotSmileTrigger)
final mascotSmileTriggerProvider = MascotSmileTriggerProvider._();

/// Fires the mascot smile animation, e.g. before opening the action log.
///
/// Rive-animated mascots play their smile timeline; static SVG mascots
/// ignore it.
final class MascotSmileTriggerProvider
    extends $NotifierProvider<MascotSmileTrigger, bool> {
  /// Fires the mascot smile animation, e.g. before opening the action log.
  ///
  /// Rive-animated mascots play their smile timeline; static SVG mascots
  /// ignore it.
  MascotSmileTriggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mascotSmileTriggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mascotSmileTriggerHash();

  @$internal
  @override
  MascotSmileTrigger create() => MascotSmileTrigger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mascotSmileTriggerHash() =>
    r'6146970c03b45858fc8f68211d15d11be7ff4ff8';

/// Fires the mascot smile animation, e.g. before opening the action log.
///
/// Rive-animated mascots play their smile timeline; static SVG mascots
/// ignore it.

abstract class _$MascotSmileTrigger extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
