// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_choice_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Banks a chosen meal as a real action (Phase 8.12): creates the
/// custom-action template, then logs it through the standard action
/// transaction (points/streak/mascot/daily summary all handled there).
/// No caps -- users are isolated (no leaderboards), so self-reported
/// inflation only affects their own stats (scoring design decision).
/// Reuses the category-agnostic customActions collection and rules that
/// the transport bridge (8.6) already established.

@ProviderFor(FoodChoiceLogger)
final foodChoiceLoggerProvider = FoodChoiceLoggerProvider._();

/// Banks a chosen meal as a real action (Phase 8.12): creates the
/// custom-action template, then logs it through the standard action
/// transaction (points/streak/mascot/daily summary all handled there).
/// No caps -- users are isolated (no leaderboards), so self-reported
/// inflation only affects their own stats (scoring design decision).
/// Reuses the category-agnostic customActions collection and rules that
/// the transport bridge (8.6) already established.
final class FoodChoiceLoggerProvider
    extends $NotifierProvider<FoodChoiceLogger, AsyncValue<void>> {
  /// Banks a chosen meal as a real action (Phase 8.12): creates the
  /// custom-action template, then logs it through the standard action
  /// transaction (points/streak/mascot/daily summary all handled there).
  /// No caps -- users are isolated (no leaderboards), so self-reported
  /// inflation only affects their own stats (scoring design decision).
  /// Reuses the category-agnostic customActions collection and rules that
  /// the transport bridge (8.6) already established.
  FoodChoiceLoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodChoiceLoggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodChoiceLoggerHash();

  @$internal
  @override
  FoodChoiceLogger create() => FoodChoiceLogger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$foodChoiceLoggerHash() => r'1daefdfb7e16a2313636ee179376f7e6c37845ff';

/// Banks a chosen meal as a real action (Phase 8.12): creates the
/// custom-action template, then logs it through the standard action
/// transaction (points/streak/mascot/daily summary all handled there).
/// No caps -- users are isolated (no leaderboards), so self-reported
/// inflation only affects their own stats (scoring design decision).
/// Reuses the category-agnostic customActions collection and rules that
/// the transport bridge (8.6) already established.

abstract class _$FoodChoiceLogger extends $Notifier<AsyncValue<void>> {
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
