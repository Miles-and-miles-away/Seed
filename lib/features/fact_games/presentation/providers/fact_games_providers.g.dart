// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact_games_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Unlocked facts the fact games can deal, one per dayOfYear.
///
/// Unlocked or viewed, as the inbox counts them: older reads predate
/// `unlockedFactDates`. Unread facts are included, so a match shows the
/// user a fact they skipped.

@ProviderFor(factGamesPool)
final factGamesPoolProvider = FactGamesPoolProvider._();

/// Unlocked facts the fact games can deal, one per dayOfYear.
///
/// Unlocked or viewed, as the inbox counts them: older reads predate
/// `unlockedFactDates`. Unread facts are included, so a match shows the
/// user a fact they skipped.

final class FactGamesPoolProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EcoFact>>,
          List<EcoFact>,
          FutureOr<List<EcoFact>>
        >
    with $FutureModifier<List<EcoFact>>, $FutureProvider<List<EcoFact>> {
  /// Unlocked facts the fact games can deal, one per dayOfYear.
  ///
  /// Unlocked or viewed, as the inbox counts them: older reads predate
  /// `unlockedFactDates`. Unread facts are included, so a match shows the
  /// user a fact they skipped.
  FactGamesPoolProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'factGamesPoolProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$factGamesPoolHash();

  @$internal
  @override
  $FutureProviderElement<List<EcoFact>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EcoFact>> create(Ref ref) {
    return factGamesPool(ref);
  }
}

String _$factGamesPoolHash() => r'a009f57b706aa792f8a4ac2425828ac907fc4114';

/// Every playable fact, locked or not: Fact recall's decoy candidates.

@ProviderFor(factGamesAllPlayable)
final factGamesAllPlayableProvider = FactGamesAllPlayableProvider._();

/// Every playable fact, locked or not: Fact recall's decoy candidates.

final class FactGamesAllPlayableProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EcoFact>>,
          List<EcoFact>,
          FutureOr<List<EcoFact>>
        >
    with $FutureModifier<List<EcoFact>>, $FutureProvider<List<EcoFact>> {
  /// Every playable fact, locked or not: Fact recall's decoy candidates.
  FactGamesAllPlayableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'factGamesAllPlayableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$factGamesAllPlayableHash();

  @$internal
  @override
  $FutureProviderElement<List<EcoFact>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EcoFact>> create(Ref ref) {
    return factGamesAllPlayable(ref);
  }
}

String _$factGamesAllPlayableHash() =>
    r'9d357352b0f61595b2c1d350f38c7646370b4029';
