// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eco_fact_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and caches all 365 eco-facts from the JSON asset.

@ProviderFor(ecoFacts)
final ecoFactsProvider = EcoFactsProvider._();

/// Loads and caches all 365 eco-facts from the JSON asset.

final class EcoFactsProvider extends $FunctionalProvider<
        AsyncValue<List<EcoFact>>, List<EcoFact>, FutureOr<List<EcoFact>>>
    with $FutureModifier<List<EcoFact>>, $FutureProvider<List<EcoFact>> {
  /// Loads and caches all 365 eco-facts from the JSON asset.
  EcoFactsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ecoFactsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoFactsHash();

  @$internal
  @override
  $FutureProviderElement<List<EcoFact>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<EcoFact>> create(Ref ref) {
    return ecoFacts(ref);
  }
}

String _$ecoFactsHash() => r'53dd0477138c84f0af006ed6564a2f42a2074847';

/// Today's eco-fact based on the day of year.

@ProviderFor(todayEcoFact)
final todayEcoFactProvider = TodayEcoFactProvider._();

/// Today's eco-fact based on the day of year.

final class TodayEcoFactProvider extends $FunctionalProvider<
        AsyncValue<EcoFact?>, EcoFact?, FutureOr<EcoFact?>>
    with $FutureModifier<EcoFact?>, $FutureProvider<EcoFact?> {
  /// Today's eco-fact based on the day of year.
  TodayEcoFactProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todayEcoFactProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todayEcoFactHash();

  @$internal
  @override
  $FutureProviderElement<EcoFact?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<EcoFact?> create(Ref ref) {
    return todayEcoFact(ref);
  }
}

String _$todayEcoFactHash() => r'723b1a0d55ce424a2e7e705b70a163763b9965a8';

/// Whether today's fact has been viewed.

@ProviderFor(isTodayFactViewed)
final isTodayFactViewedProvider = IsTodayFactViewedProvider._();

/// Whether today's fact has been viewed.

final class IsTodayFactViewedProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Whether today's fact has been viewed.
  IsTodayFactViewedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isTodayFactViewedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isTodayFactViewedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isTodayFactViewed(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isTodayFactViewedHash() => r'6a9834b6e0be000b0d67d0d725768cc797723a89';

/// Whether the eco-fact is locked behind challenge completion.

@ProviderFor(isEcoFactLocked)
final isEcoFactLockedProvider = IsEcoFactLockedProvider._();

/// Whether the eco-fact is locked behind challenge completion.

final class IsEcoFactLockedProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Whether the eco-fact is locked behind challenge completion.
  IsEcoFactLockedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isEcoFactLockedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isEcoFactLockedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isEcoFactLocked(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isEcoFactLockedHash() => r'c485a44333867d9380d16bb043358839e84b0985';

/// True when the user has an unread, unlocked fact (drives red dot).

@ProviderFor(hasUnreadFact)
final hasUnreadFactProvider = HasUnreadFactProvider._();

/// True when the user has an unread, unlocked fact (drives red dot).

final class HasUnreadFactProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// True when the user has an unread, unlocked fact (drives red dot).
  HasUnreadFactProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'hasUnreadFactProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$hasUnreadFactHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasUnreadFact(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasUnreadFactHash() => r'70b8938b57a07576acd82845bcaccaf2d04c0638';

/// Inbox rows, newest first. Contains today's fact (locked or unlocked)
/// plus any previously-viewed facts, matching the "mail already read"
/// metaphor. Future mail types (announcements etc.) can be merged in
/// later.

@ProviderFor(ecoFactInbox)
final ecoFactInboxProvider = EcoFactInboxProvider._();

/// Inbox rows, newest first. Contains today's fact (locked or unlocked)
/// plus any previously-viewed facts, matching the "mail already read"
/// metaphor. Future mail types (announcements etc.) can be merged in
/// later.

final class EcoFactInboxProvider extends $FunctionalProvider<
        AsyncValue<List<EcoFactInboxItem>>,
        List<EcoFactInboxItem>,
        FutureOr<List<EcoFactInboxItem>>>
    with
        $FutureModifier<List<EcoFactInboxItem>>,
        $FutureProvider<List<EcoFactInboxItem>> {
  /// Inbox rows, newest first. Contains today's fact (locked or unlocked)
  /// plus any previously-viewed facts, matching the "mail already read"
  /// metaphor. Future mail types (announcements etc.) can be merged in
  /// later.
  EcoFactInboxProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ecoFactInboxProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ecoFactInboxHash();

  @$internal
  @override
  $FutureProviderElement<List<EcoFactInboxItem>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<EcoFactInboxItem>> create(Ref ref) {
    return ecoFactInbox(ref);
  }
}

String _$ecoFactInboxHash() => r'c1f49a63bf817cdba667ce876115f92f734c60eb';

/// Notifier to mark an eco-fact as viewed.

@ProviderFor(FactViewedNotifier)
final factViewedProvider = FactViewedNotifierProvider._();

/// Notifier to mark an eco-fact as viewed.
final class FactViewedNotifierProvider
    extends $NotifierProvider<FactViewedNotifier, AsyncValue<void>> {
  /// Notifier to mark an eco-fact as viewed.
  FactViewedNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'factViewedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$factViewedNotifierHash();

  @$internal
  @override
  FactViewedNotifier create() => FactViewedNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$factViewedNotifierHash() =>
    r'82bb1a04c3acfb332a7389db0a021a6c8fb206d3';

/// Notifier to mark an eco-fact as viewed.

abstract class _$FactViewedNotifier extends $Notifier<AsyncValue<void>> {
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
