// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact_games_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Unlocked facts the fact games can deal in [locale], one per dayOfYear.
///
/// Unlocked or viewed, as the inbox counts them: older reads predate
/// `unlockedFactDates`. Unread facts are included, so a match shows the
/// user a fact they skipped.

@ProviderFor(factGamesPool)
final factGamesPoolProvider = FactGamesPoolFamily._();

/// Unlocked facts the fact games can deal in [locale], one per dayOfYear.
///
/// Unlocked or viewed, as the inbox counts them: older reads predate
/// `unlockedFactDates`. Unread facts are included, so a match shows the
/// user a fact they skipped.

final class FactGamesPoolProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameFact>>,
          List<GameFact>,
          FutureOr<List<GameFact>>
        >
    with $FutureModifier<List<GameFact>>, $FutureProvider<List<GameFact>> {
  /// Unlocked facts the fact games can deal in [locale], one per dayOfYear.
  ///
  /// Unlocked or viewed, as the inbox counts them: older reads predate
  /// `unlockedFactDates`. Unread facts are included, so a match shows the
  /// user a fact they skipped.
  FactGamesPoolProvider._({
    required FactGamesPoolFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'factGamesPoolProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$factGamesPoolHash();

  @override
  String toString() {
    return r'factGamesPoolProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GameFact>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GameFact>> create(Ref ref) {
    final argument = this.argument as String;
    return factGamesPool(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FactGamesPoolProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$factGamesPoolHash() => r'a6bc4b7c02fcc24db9250ac06ba5d2be51024c16';

/// Unlocked facts the fact games can deal in [locale], one per dayOfYear.
///
/// Unlocked or viewed, as the inbox counts them: older reads predate
/// `unlockedFactDates`. Unread facts are included, so a match shows the
/// user a fact they skipped.

final class FactGamesPoolFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GameFact>>, String> {
  FactGamesPoolFamily._()
    : super(
        retry: null,
        name: r'factGamesPoolProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Unlocked facts the fact games can deal in [locale], one per dayOfYear.
  ///
  /// Unlocked or viewed, as the inbox counts them: older reads predate
  /// `unlockedFactDates`. Unread facts are included, so a match shows the
  /// user a fact they skipped.

  FactGamesPoolProvider call(String locale) =>
      FactGamesPoolProvider._(argument: locale, from: this);

  @override
  String toString() => r'factGamesPoolProvider';
}

/// Every playable fact, locked or not: Fact recall's decoy candidates.

@ProviderFor(factGamesAllPlayable)
final factGamesAllPlayableProvider = FactGamesAllPlayableFamily._();

/// Every playable fact, locked or not: Fact recall's decoy candidates.

final class FactGamesAllPlayableProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameFact>>,
          List<GameFact>,
          FutureOr<List<GameFact>>
        >
    with $FutureModifier<List<GameFact>>, $FutureProvider<List<GameFact>> {
  /// Every playable fact, locked or not: Fact recall's decoy candidates.
  FactGamesAllPlayableProvider._({
    required FactGamesAllPlayableFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'factGamesAllPlayableProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$factGamesAllPlayableHash();

  @override
  String toString() {
    return r'factGamesAllPlayableProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GameFact>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GameFact>> create(Ref ref) {
    final argument = this.argument as String;
    return factGamesAllPlayable(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FactGamesAllPlayableProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$factGamesAllPlayableHash() =>
    r'34f4f71d38ecac29ce7f58c2bdd75846a8e0362e';

/// Every playable fact, locked or not: Fact recall's decoy candidates.

final class FactGamesAllPlayableFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GameFact>>, String> {
  FactGamesAllPlayableFamily._()
    : super(
        retry: null,
        name: r'factGamesAllPlayableProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Every playable fact, locked or not: Fact recall's decoy candidates.

  FactGamesAllPlayableProvider call(String locale) =>
      FactGamesAllPlayableProvider._(argument: locale, from: this);

  @override
  String toString() => r'factGamesAllPlayableProvider';
}
