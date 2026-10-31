// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fact_games_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Facts the fact games can deal in [locale]: the user's unlocked
/// eco-facts (one per dayOfYear), their discovered Eco-Dex entries, and
/// every SDG and action fact, whose screens are open to all.
///
/// Eco-facts count when unlocked or viewed, as the inbox counts them:
/// older reads predate `unlockedFactDates`. Unread facts are included, so
/// a match shows the user a fact they skipped.

@ProviderFor(factGamesPool)
final factGamesPoolProvider = FactGamesPoolFamily._();

/// Facts the fact games can deal in [locale]: the user's unlocked
/// eco-facts (one per dayOfYear), their discovered Eco-Dex entries, and
/// every SDG and action fact, whose screens are open to all.
///
/// Eco-facts count when unlocked or viewed, as the inbox counts them:
/// older reads predate `unlockedFactDates`. Unread facts are included, so
/// a match shows the user a fact they skipped.

final class FactGamesPoolProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameFact>>,
          List<GameFact>,
          FutureOr<List<GameFact>>
        >
    with $FutureModifier<List<GameFact>>, $FutureProvider<List<GameFact>> {
  /// Facts the fact games can deal in [locale]: the user's unlocked
  /// eco-facts (one per dayOfYear), their discovered Eco-Dex entries, and
  /// every SDG and action fact, whose screens are open to all.
  ///
  /// Eco-facts count when unlocked or viewed, as the inbox counts them:
  /// older reads predate `unlockedFactDates`. Unread facts are included, so
  /// a match shows the user a fact they skipped.
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

String _$factGamesPoolHash() => r'0639bc077ae709cc849be31fafe419e92e5de708';

/// Facts the fact games can deal in [locale]: the user's unlocked
/// eco-facts (one per dayOfYear), their discovered Eco-Dex entries, and
/// every SDG and action fact, whose screens are open to all.
///
/// Eco-facts count when unlocked or viewed, as the inbox counts them:
/// older reads predate `unlockedFactDates`. Unread facts are included, so
/// a match shows the user a fact they skipped.

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

  /// Facts the fact games can deal in [locale]: the user's unlocked
  /// eco-facts (one per dayOfYear), their discovered Eco-Dex entries, and
  /// every SDG and action fact, whose screens are open to all.
  ///
  /// Eco-facts count when unlocked or viewed, as the inbox counts them:
  /// older reads predate `unlockedFactDates`. Unread facts are included, so
  /// a match shows the user a fact they skipped.

  FactGamesPoolProvider call(String locale) =>
      FactGamesPoolProvider._(argument: locale, from: this);

  @override
  String toString() => r'factGamesPoolProvider';
}

/// Every text fact, locked or not: Fact recall's decoy candidates.

@ProviderFor(factGamesAllPlayable)
final factGamesAllPlayableProvider = FactGamesAllPlayableFamily._();

/// Every text fact, locked or not: Fact recall's decoy candidates.

final class FactGamesAllPlayableProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameFact>>,
          List<GameFact>,
          FutureOr<List<GameFact>>
        >
    with $FutureModifier<List<GameFact>>, $FutureProvider<List<GameFact>> {
  /// Every text fact, locked or not: Fact recall's decoy candidates.
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
    r'b6619ea9addc4ef00ad28906b10aa1ab46e8a5ee';

/// Every text fact, locked or not: Fact recall's decoy candidates.

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

  /// Every text fact, locked or not: Fact recall's decoy candidates.

  FactGamesAllPlayableProvider call(String locale) =>
      FactGamesAllPlayableProvider._(argument: locale, from: this);

  @override
  String toString() => r'factGamesAllPlayableProvider';
}

/// Calculator comparisons in [locale], Fact recall only: always available
/// and never counted towards the lock. A calculator whose data fails to
/// load gives no comparisons rather than an error.

@ProviderFor(factGamesCalculatorFacts)
final factGamesCalculatorFactsProvider = FactGamesCalculatorFactsFamily._();

/// Calculator comparisons in [locale], Fact recall only: always available
/// and never counted towards the lock. A calculator whose data fails to
/// load gives no comparisons rather than an error.

final class FactGamesCalculatorFactsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameFact>>,
          List<GameFact>,
          FutureOr<List<GameFact>>
        >
    with $FutureModifier<List<GameFact>>, $FutureProvider<List<GameFact>> {
  /// Calculator comparisons in [locale], Fact recall only: always available
  /// and never counted towards the lock. A calculator whose data fails to
  /// load gives no comparisons rather than an error.
  FactGamesCalculatorFactsProvider._({
    required FactGamesCalculatorFactsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'factGamesCalculatorFactsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$factGamesCalculatorFactsHash();

  @override
  String toString() {
    return r'factGamesCalculatorFactsProvider'
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
    return factGamesCalculatorFacts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FactGamesCalculatorFactsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$factGamesCalculatorFactsHash() =>
    r'be47441485db46f66fc8555cedc043f0c18c1682';

/// Calculator comparisons in [locale], Fact recall only: always available
/// and never counted towards the lock. A calculator whose data fails to
/// load gives no comparisons rather than an error.

final class FactGamesCalculatorFactsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GameFact>>, String> {
  FactGamesCalculatorFactsFamily._()
    : super(
        retry: null,
        name: r'factGamesCalculatorFactsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Calculator comparisons in [locale], Fact recall only: always available
  /// and never counted towards the lock. A calculator whose data fails to
  /// load gives no comparisons rather than an error.

  FactGamesCalculatorFactsProvider call(String locale) =>
      FactGamesCalculatorFactsProvider._(argument: locale, from: this);

  @override
  String toString() => r'factGamesCalculatorFactsProvider';
}
