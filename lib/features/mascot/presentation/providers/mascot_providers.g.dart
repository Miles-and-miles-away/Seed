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

final class MascotSpeciesDataProvider extends $FunctionalProvider<
        AsyncValue<List<MascotSpeciesModel>>,
        List<MascotSpeciesModel>,
        FutureOr<List<MascotSpeciesModel>>>
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
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<MascotSpeciesModel>> create(Ref ref) {
    return mascotSpeciesData(ref);
  }
}

String _$mascotSpeciesDataHash() => r'558b72453c2852607aff195d06d2725737cefa37';

@ProviderFor(mascotRepository)
final mascotRepositoryProvider = MascotRepositoryProvider._();

final class MascotRepositoryProvider extends $FunctionalProvider<
    MascotRepository,
    MascotRepository,
    MascotRepository> with $Provider<MascotRepository> {
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

String _$mascotRepositoryHash() => r'07f81837435cff1826af88d6440e0fddf751c32f';

@ProviderFor(mascotMigrationService)
final mascotMigrationServiceProvider = MascotMigrationServiceProvider._();

final class MascotMigrationServiceProvider extends $FunctionalProvider<
    MascotMigrationService,
    MascotMigrationService,
    MascotMigrationService> with $Provider<MascotMigrationService> {
  MascotMigrationServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'mascotMigrationServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$mascotMigrationServiceHash();

  @$internal
  @override
  $ProviderElement<MascotMigrationService> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MascotMigrationService create(Ref ref) {
    return mascotMigrationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MascotMigrationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MascotMigrationService>(value),
    );
  }
}

String _$mascotMigrationServiceHash() =>
    r'45636093b4f5698f35b751bd4b75f0a9166215a0';

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

final class AllMascotsProvider extends $FunctionalProvider<
        AsyncValue<List<MascotModel>>,
        List<MascotModel>,
        Stream<List<MascotModel>>>
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
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

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

final class ActiveMascotProvider extends $FunctionalProvider<
        AsyncValue<MascotModel?>, MascotModel?, Stream<MascotModel?>>
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
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<MascotModel?> create(Ref ref) {
    return activeMascot(ref);
  }
}

String _$activeMascotHash() => r'cc4ca666e43720f6a60c273957d597dfd745cf5e';

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

String _$hasMascotHash() => r'59e971edd48a72af94921ed2ac092b50ed60bb3b';

/// Species data for the active mascot.

@ProviderFor(activeSpecies)
final activeSpeciesProvider = ActiveSpeciesProvider._();

/// Species data for the active mascot.

final class ActiveSpeciesProvider extends $FunctionalProvider<
    MascotSpeciesModel?,
    MascotSpeciesModel?,
    MascotSpeciesModel?> with $Provider<MascotSpeciesModel?> {
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
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

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

final class ActiveStageDataProvider extends $FunctionalProvider<
    EvolutionStageModel?,
    EvolutionStageModel?,
    EvolutionStageModel?> with $Provider<EvolutionStageModel?> {
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
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

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
    r'5291fa758fa5fb5885057a4e78f8711bfbb15be0';

/// Next evolution stage for the active mascot, or null.

@ProviderFor(activeNextStageData)
final activeNextStageDataProvider = ActiveNextStageDataProvider._();

/// Next evolution stage for the active mascot, or null.

final class ActiveNextStageDataProvider extends $FunctionalProvider<
    EvolutionStageModel?,
    EvolutionStageModel?,
    EvolutionStageModel?> with $Provider<EvolutionStageModel?> {
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
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

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
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
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

String _$currentEggHash() => r'6571260ce35c4f62d01db31926c7926be73665ca';

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

String _$hasEggHash() => r'9f6cb87366812b22b5e55797e01c61ac8d8d4e24';

/// Egg hatching progress (0.0 to 1.0).

@ProviderFor(eggHatchingProgress)
final eggHatchingProgressProvider = EggHatchingProgressProvider._();

/// Egg hatching progress (0.0 to 1.0).

final class EggHatchingProgressProvider
    extends $FunctionalProvider<double, double, double> with $Provider<double> {
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

/// Days remaining until egg hatches.

@ProviderFor(eggDaysRemaining)
final eggDaysRemainingProvider = EggDaysRemainingProvider._();

/// Days remaining until egg hatches.

final class EggDaysRemainingProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Days remaining until egg hatches.
  EggDaysRemainingProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'eggDaysRemainingProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eggDaysRemainingHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return eggDaysRemaining(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$eggDaysRemainingHash() => r'666cca3a1dee8704c825b2aacded185c1beacb1f';

/// Whether to show the egg discovery celebration.
/// True if eggPendingDiscovery flag is set.

@ProviderFor(shouldShowEggDiscovery)
final shouldShowEggDiscoveryProvider = ShouldShowEggDiscoveryProvider._();

/// Whether to show the egg discovery celebration.
/// True if eggPendingDiscovery flag is set.

final class ShouldShowEggDiscoveryProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
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
    r'750a0523a1e65054f11ea7e3dcfe56708ed1a161';

/// Localized name for the active mascot's stage.

@ProviderFor(stageLocalizedName)
final stageLocalizedNameProvider = StageLocalizedNameFamily._();

/// Localized name for the active mascot's stage.

final class StageLocalizedNameProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Localized name for the active mascot's stage.
  StageLocalizedNameProvider._(
      {required StageLocalizedNameFamily super.from,
      required String super.argument})
      : super(
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
    return stageLocalizedName(
      ref,
      argument,
    );
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
    r'a2cedfa1046d4c8e209f53fb4b3a31c22be8079d';

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

  StageLocalizedNameProvider call(
    String locale,
  ) =>
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
          isAutoDispose: true,
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

String _$mascotNotifierHash() => r'220d65ef0dd54f9d6e665e666848f3759a5b67b5';

abstract class _$MascotNotifier extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
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
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
