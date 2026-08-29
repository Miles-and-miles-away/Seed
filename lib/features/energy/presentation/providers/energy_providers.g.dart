// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All energy behaviors from the bundled dataset.

@ProviderFor(energyBehaviors)
final energyBehaviorsProvider = EnergyBehaviorsProvider._();

/// All energy behaviors from the bundled dataset.

final class EnergyBehaviorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EnergyBehavior>>,
          List<EnergyBehavior>,
          FutureOr<List<EnergyBehavior>>
        >
    with
        $FutureModifier<List<EnergyBehavior>>,
        $FutureProvider<List<EnergyBehavior>> {
  /// All energy behaviors from the bundled dataset.
  EnergyBehaviorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'energyBehaviorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$energyBehaviorsHash();

  @$internal
  @override
  $FutureProviderElement<List<EnergyBehavior>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EnergyBehavior>> create(Ref ref) {
    return energyBehaviors(ref);
  }
}

String _$energyBehaviorsHash() => r'0d198b46338cd28eb5cf9b48788ae65ec9ceae8a';

/// Dataset metadata (scope, both carrier factors) for the methodology
/// screen and the engine's factors (Phase 8.16).

@ProviderFor(energyMetadata)
final energyMetadataProvider = EnergyMetadataProvider._();

/// Dataset metadata (scope, both carrier factors) for the methodology
/// screen and the engine's factors (Phase 8.16).

final class EnergyMetadataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Dataset metadata (scope, both carrier factors) for the methodology
  /// screen and the engine's factors (Phase 8.16).
  EnergyMetadataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'energyMetadataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$energyMetadataHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return energyMetadata(ref);
  }
}

String _$energyMetadataHash() => r'6f8e76d74e414aca6a5d70251335357216d047c9';

/// Behaviors indexed by id for routine lookups.

@ProviderFor(energyBehaviorsById)
final energyBehaviorsByIdProvider = EnergyBehaviorsByIdProvider._();

/// Behaviors indexed by id for routine lookups.

final class EnergyBehaviorsByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, EnergyBehavior>>,
          Map<String, EnergyBehavior>,
          FutureOr<Map<String, EnergyBehavior>>
        >
    with
        $FutureModifier<Map<String, EnergyBehavior>>,
        $FutureProvider<Map<String, EnergyBehavior>> {
  /// Behaviors indexed by id for routine lookups.
  EnergyBehaviorsByIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'energyBehaviorsByIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$energyBehaviorsByIdHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, EnergyBehavior>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, EnergyBehavior>> create(Ref ref) {
    return energyBehaviorsById(ref);
  }
}

String _$energyBehaviorsByIdHash() =>
    r'85596e62b1ee770153735c84cbf906d1df2901c0';

/// The two carrier factors, read from the dataset rather than hardcoded
/// so the metadata block stays the single source of truth.

@ProviderFor(energyCarrierFactors)
final energyCarrierFactorsProvider = EnergyCarrierFactorsProvider._();

/// The two carrier factors, read from the dataset rather than hardcoded
/// so the metadata block stays the single source of truth.

final class EnergyCarrierFactorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<CarrierFactors>,
          CarrierFactors,
          FutureOr<CarrierFactors>
        >
    with $FutureModifier<CarrierFactors>, $FutureProvider<CarrierFactors> {
  /// The two carrier factors, read from the dataset rather than hardcoded
  /// so the metadata block stays the single source of truth.
  EnergyCarrierFactorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'energyCarrierFactorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$energyCarrierFactorsHash();

  @$internal
  @override
  $FutureProviderElement<CarrierFactors> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CarrierFactors> create(Ref ref) {
    return energyCarrierFactors(ref);
  }
}

String _$energyCarrierFactorsHash() =>
    r'169e37038f290644faf265bbdd91c2d41ee4f6ae';

/// Ids of behaviors picked this session, most recent first.
///
/// keepAlive so the list survives closing the picker, but memory-only:
/// building two comparable routines means reaching for the same handful
/// of behaviors twice, and the payoff is within a session anyway.

@ProviderFor(RecentEnergyBehaviorIds)
final recentEnergyBehaviorIdsProvider = RecentEnergyBehaviorIdsProvider._();

/// Ids of behaviors picked this session, most recent first.
///
/// keepAlive so the list survives closing the picker, but memory-only:
/// building two comparable routines means reaching for the same handful
/// of behaviors twice, and the payoff is within a session anyway.
final class RecentEnergyBehaviorIdsProvider
    extends $NotifierProvider<RecentEnergyBehaviorIds, List<String>> {
  /// Ids of behaviors picked this session, most recent first.
  ///
  /// keepAlive so the list survives closing the picker, but memory-only:
  /// building two comparable routines means reaching for the same handful
  /// of behaviors twice, and the payoff is within a session anyway.
  RecentEnergyBehaviorIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentEnergyBehaviorIdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentEnergyBehaviorIdsHash();

  @$internal
  @override
  RecentEnergyBehaviorIds create() => RecentEnergyBehaviorIds();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$recentEnergyBehaviorIdsHash() =>
    r'b06609163f2c735e06772c8c9c9cda900bf29c43';

/// Ids of behaviors picked this session, most recent first.
///
/// keepAlive so the list survives closing the picker, but memory-only:
/// building two comparable routines means reaching for the same handful
/// of behaviors twice, and the payoff is within a session anyway.

abstract class _$RecentEnergyBehaviorIds extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The usages of both routine options, indexed [optionA] / [optionB].
///
/// keepAlive: an in-progress comparison must survive navigating away
/// and back. Memory-only -- this calculator persists and banks nothing
/// (decision 8.18).

@ProviderFor(RoutineOptions)
final routineOptionsProvider = RoutineOptionsProvider._();

/// The usages of both routine options, indexed [optionA] / [optionB].
///
/// keepAlive: an in-progress comparison must survive navigating away
/// and back. Memory-only -- this calculator persists and banks nothing
/// (decision 8.18).
final class RoutineOptionsProvider
    extends $NotifierProvider<RoutineOptions, List<List<RoutineUsage>>> {
  /// The usages of both routine options, indexed [optionA] / [optionB].
  ///
  /// keepAlive: an in-progress comparison must survive navigating away
  /// and back. Memory-only -- this calculator persists and banks nothing
  /// (decision 8.18).
  RoutineOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routineOptionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routineOptionsHash();

  @$internal
  @override
  RoutineOptions create() => RoutineOptions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<List<RoutineUsage>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<List<RoutineUsage>>>(value),
    );
  }
}

String _$routineOptionsHash() => r'f7702f197d3686cb531cbce2bad113cc7e57bd8a';

/// The usages of both routine options, indexed [optionA] / [optionB].
///
/// keepAlive: an in-progress comparison must survive navigating away
/// and back. Memory-only -- this calculator persists and banks nothing
/// (decision 8.18).

abstract class _$RoutineOptions extends $Notifier<List<List<RoutineUsage>>> {
  List<List<RoutineUsage>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<List<List<RoutineUsage>>, List<List<RoutineUsage>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<List<RoutineUsage>>, List<List<RoutineUsage>>>,
              List<List<RoutineUsage>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
