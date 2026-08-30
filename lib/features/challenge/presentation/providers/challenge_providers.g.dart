// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and caches challenge template data from JSON.

@ProviderFor(challengeTemplateData)
final challengeTemplateDataProvider = ChallengeTemplateDataProvider._();

/// Loads and caches challenge template data from JSON.

final class ChallengeTemplateDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChallengeTemplateData>,
          ChallengeTemplateData,
          FutureOr<ChallengeTemplateData>
        >
    with
        $FutureModifier<ChallengeTemplateData>,
        $FutureProvider<ChallengeTemplateData> {
  /// Loads and caches challenge template data from JSON.
  ChallengeTemplateDataProvider._()
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ChallengeTemplateData> create(Ref ref) {
    return challengeTemplateData(ref);
  }
}

String _$challengeTemplateDataHash() =>
    r'9f49b40d7d276f1c327ad351347794e576593801';

/// Today's challenge based on user ID and recent IDs.

@ProviderFor(todayChallenge)
final todayChallengeProvider = TodayChallengeProvider._();

/// Today's challenge based on user ID and recent IDs.

final class TodayChallengeProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailyChallengeTemplate?>,
          DailyChallengeTemplate?,
          FutureOr<DailyChallengeTemplate?>
        >
    with
        $FutureModifier<DailyChallengeTemplate?>,
        $FutureProvider<DailyChallengeTemplate?> {
  /// Today's challenge based on user ID and recent IDs.
  TodayChallengeProvider._()
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
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DailyChallengeTemplate?> create(Ref ref) {
    return todayChallenge(ref);
  }
}

String _$todayChallengeHash() => r'a33fdb91c54dd2ef4414f393fedebf993570d26f';

/// Whether today's daily challenge is completed.

@ProviderFor(isTodayChallengeCompleted)
final isTodayChallengeCompletedProvider = IsTodayChallengeCompletedProvider._();

/// Whether today's daily challenge is completed.

final class IsTodayChallengeCompletedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether today's daily challenge is completed.
  IsTodayChallengeCompletedProvider._()
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

/// Current challenge streak as the user should see it.
///
/// The stored value is only corrected by the next completion, so
/// after a missed day it still holds the old streak; a completion
/// date before yesterday means the streak is already broken.

@ProviderFor(challengeStreak)
final challengeStreakProvider = ChallengeStreakProvider._();

/// Current challenge streak as the user should see it.
///
/// The stored value is only corrected by the next completion, so
/// after a missed day it still holds the old streak; a completion
/// date before yesterday means the streak is already broken.

final class ChallengeStreakProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Current challenge streak as the user should see it.
  ///
  /// The stored value is only corrected by the next completion, so
  /// after a missed day it still holds the old streak; a completion
  /// date before yesterday means the streak is already broken.
  ChallengeStreakProvider._()
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

String _$challengeStreakHash() => r'05057cf9ebc5b6af057416b5d0422e39982f3812';

/// Active multi-day challenge data.

@ProviderFor(activeMultiDayChallenge)
final activeMultiDayChallengeProvider = ActiveMultiDayChallengeProvider._();

/// Active multi-day challenge data.

final class ActiveMultiDayChallengeProvider
    extends
        $FunctionalProvider<
          ActiveMultiDayChallenge?,
          ActiveMultiDayChallenge?,
          ActiveMultiDayChallenge?
        >
    with $Provider<ActiveMultiDayChallenge?> {
  /// Active multi-day challenge data.
  ActiveMultiDayChallengeProvider._()
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
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

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
final challengeDialogShownProvider = ChallengeDialogShownProvider._();

/// Session-scoped flag: has the challenge dialog been
/// shown this session?
final class ChallengeDialogShownProvider
    extends $NotifierProvider<ChallengeDialogShown, bool> {
  /// Session-scoped flag: has the challenge dialog been
  /// shown this session?
  ChallengeDialogShownProvider._()
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

/// Whether the daily challenge dialog should be shown.

@ProviderFor(shouldShowChallengeDialog)
final shouldShowChallengeDialogProvider = ShouldShowChallengeDialogProvider._();

/// Whether the daily challenge dialog should be shown.

final class ShouldShowChallengeDialogProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the daily challenge dialog should be shown.
  ShouldShowChallengeDialogProvider._()
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
///
/// Kept alive: callers only `read` it, so as autoDispose it was disposed
/// while awaiting the template load and the following `state` write threw.

@ProviderFor(MultiDayChallengeNotifier)
final multiDayChallengeProvider = MultiDayChallengeNotifierProvider._();

/// Notifier for multi-day challenge actions.
///
/// Kept alive: callers only `read` it, so as autoDispose it was disposed
/// while awaiting the template load and the following `state` write threw.
final class MultiDayChallengeNotifierProvider
    extends $NotifierProvider<MultiDayChallengeNotifier, AsyncValue<void>> {
  /// Notifier for multi-day challenge actions.
  ///
  /// Kept alive: callers only `read` it, so as autoDispose it was disposed
  /// while awaiting the template load and the following `state` write threw.
  MultiDayChallengeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'multiDayChallengeProvider',
        isAutoDispose: false,
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
    r'8d855c6acb951ef20b79f6ea72e68e0121747ae6';

/// Notifier for multi-day challenge actions.
///
/// Kept alive: callers only `read` it, so as autoDispose it was disposed
/// while awaiting the template load and the following `state` write threw.

abstract class _$MultiDayChallengeNotifier extends $Notifier<AsyncValue<void>> {
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
