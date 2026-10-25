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

String _$factGamesPoolHash() => r'd452b1577b04a01c36471c31a4062b9f6459ba52';
