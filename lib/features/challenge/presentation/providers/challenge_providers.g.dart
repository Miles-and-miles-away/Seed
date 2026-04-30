// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and caches challenge template data from JSON.

@ProviderFor(challengeTemplateData)
const challengeTemplateDataProvider = ChallengeTemplateDataProvider._();

/// Loads and caches challenge template data from JSON.

final class ChallengeTemplateDataProvider extends $FunctionalProvider<
        AsyncValue<ChallengeTemplateData>,
        ChallengeTemplateData,
        FutureOr<ChallengeTemplateData>>
    with
        $FutureModifier<ChallengeTemplateData>,
        $FutureProvider<ChallengeTemplateData> {
  /// Loads and caches challenge template data from JSON.
  const ChallengeTemplateDataProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'challengeTemplateDataProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$challengeTemplateDataHash();

  @$internal
  @override
  $FutureProviderElement<ChallengeTemplateData> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ChallengeTemplateData> create(Ref ref) {
    return challengeTemplateData(ref);
  }
}

String _$challengeTemplateDataHash() =>
    r'9f49b40d7d276f1c327ad351347794e576593801';

/// Today's challenge based on user ID and recent IDs.

@ProviderFor(todayChallenge)
const todayChallengeProvider = TodayChallengeProvider._();

/// Today's challenge based on user ID and recent IDs.

final class TodayChallengeProvider extends $FunctionalProvider<
        AsyncValue<DailyChallengeTemplate?>,
        DailyChallengeTemplate?,
        FutureOr<DailyChallengeTemplate?>>
    with
        $FutureModifier<DailyChallengeTemplate?>,
        $FutureProvider<DailyChallengeTemplate?> {
  /// Today's challenge based on user ID and recent IDs.
  const TodayChallengeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'todayChallengeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$todayChallengeHash();

  @$internal
  @override
  $FutureProviderElement<DailyChallengeTemplate?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DailyChallengeTemplate?> create(Ref ref) {
    return todayChallenge(ref);
  }
}

String _$todayChallengeHash() => r'fe63e0f9607da497e9763135739edc1ba0820f38';

/// Whether today's daily challenge is completed.

@ProviderFor(isTodayChallengeCompleted)
const isTodayChallengeCompletedProvider = IsTodayChallengeCompletedProvider._();

/// Whether today's daily challenge is completed.

final class IsTodayChallengeCompletedProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Whether today's daily challenge is completed.
  const IsTodayChallengeCompletedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isTodayChallengeCompletedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isTodayChallengeCompletedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isTodayChallengeCompleted(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isTodayChallengeCompletedHash() =>
    r'98034732425cc74d92a40d2b4c3e5f063b05f11c';

/// Current challenge streak.

@ProviderFor(challengeStreak)
const challengeStreakProvider = ChallengeStreakProvider._();

/// Current challenge streak.

final class ChallengeStreakProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Current challenge streak.
  const ChallengeStreakProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'challengeStreakProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$challengeStreakHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return challengeStreak(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$challengeStreakHash() => r'1788cf637abc474d21b211fd20927e687707b8d8';

/// Active multi-day challenge data.

@ProviderFor(activeMultiDayChallenge)
const activeMultiDayChallengeProvider = ActiveMultiDayChallengeProvider._();

/// Active multi-day challenge data.

final class ActiveMultiDayChallengeProvider extends $FunctionalProvider<
    ActiveMultiDayChallenge?,
    ActiveMultiDayChallenge?,
    ActiveMultiDayChallenge?> with $Provider<ActiveMultiDayChallenge?> {
  /// Active multi-day challenge data.
  const ActiveMultiDayChallengeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'activeMultiDayChallengeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activeMultiDayChallengeHash();

  @$internal
  @override
  $ProviderElement<ActiveMultiDayChallenge?> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ActiveMultiDayChallenge? create(Ref ref) {
    return activeMultiDayChallenge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActiveMultiDayChallenge? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActiveMultiDayChallenge?>(value),
    );
  }
}

String _$activeMultiDayChallengeHash() =>
    r'a8b6f4abcf309126a383c89ff5a250147c98acea';

/// Session-scoped flag: has the challenge dialog been
/// shown this session?

@ProviderFor(ChallengeDialogShown)
const challengeDialogShownProvider = ChallengeDialogShownProvider._();

/// Session-scoped flag: has the challenge dialog been
/// shown this session?
final class ChallengeDialogShownProvider
    extends $NotifierProvider<ChallengeDialogShown, bool> {
  /// Session-scoped flag: has the challenge dialog been
  /// shown this session?
  const ChallengeDialogShownProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'challengeDialogShownProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$challengeDialogShownHash();

  @$internal
  @override
  ChallengeDialogShown create() => ChallengeDialogShown();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$challengeDialogShownHash() =>
    r'd3ad5dd906a6fb86d34ff6ed51c7c6e8244a167e';

/// Session-scoped flag: has the challenge dialog been
/// shown this session?

abstract class _$ChallengeDialogShown extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<bool, bool>, bool, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// Whether the daily challenge dialog should be shown.

@ProviderFor(shouldShowChallengeDialog)
const shouldShowChallengeDialogProvider = ShouldShowChallengeDialogProvider._();

/// Whether the daily challenge dialog should be shown.

final class ShouldShowChallengeDialogProvider
    extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Whether the daily challenge dialog should be shown.
  const ShouldShowChallengeDialogProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'shouldShowChallengeDialogProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$shouldShowChallengeDialogHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return shouldShowChallengeDialog(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$shouldShowChallengeDialogHash() =>
    r'fd0664793fdce3abba7c7ae591dfc213bb098f89';

/// Notifier for multi-day challenge actions.

@ProviderFor(MultiDayChallengeNotifier)
const multiDayChallengeProvider = MultiDayChallengeNotifierProvider._();

/// Notifier for multi-day challenge actions.
final class MultiDayChallengeNotifierProvider
    extends $NotifierProvider<MultiDayChallengeNotifier, AsyncValue<void>> {
  /// Notifier for multi-day challenge actions.
  const MultiDayChallengeNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'multiDayChallengeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$multiDayChallengeNotifierHash();

  @$internal
  @override
  MultiDayChallengeNotifier create() => MultiDayChallengeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$multiDayChallengeNotifierHash() =>
    r'd1e2ffac78b01182cb1437d866bf5c8f06c19aa0';

/// Notifier for multi-day challenge actions.

abstract class _$MultiDayChallengeNotifier extends $Notifier<AsyncValue<void>> {
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
