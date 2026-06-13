// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Emits an incrementing token each time the visible location *leaves* the
/// Home tab's root route (`/home`) -- whether by switching tabs or by pushing
/// a nested route (SDG detail, daily fact, challenges). Widgets such as the
/// SDG carousel watch this so they reset their scroll position while Home is
/// offscreen, leaving it already centered (no visible jump) the next time the
/// kept-alive [IndexedStack] branch is shown.

@ProviderFor(HomeVisitSignal)
final homeVisitSignalProvider = HomeVisitSignalProvider._();

/// Emits an incrementing token each time the visible location *leaves* the
/// Home tab's root route (`/home`) -- whether by switching tabs or by pushing
/// a nested route (SDG detail, daily fact, challenges). Widgets such as the
/// SDG carousel watch this so they reset their scroll position while Home is
/// offscreen, leaving it already centered (no visible jump) the next time the
/// kept-alive [IndexedStack] branch is shown.
final class HomeVisitSignalProvider
    extends $NotifierProvider<HomeVisitSignal, int> {
  /// Emits an incrementing token each time the visible location *leaves* the
  /// Home tab's root route (`/home`) -- whether by switching tabs or by pushing
  /// a nested route (SDG detail, daily fact, challenges). Widgets such as the
  /// SDG carousel watch this so they reset their scroll position while Home is
  /// offscreen, leaving it already centered (no visible jump) the next time the
  /// kept-alive [IndexedStack] branch is shown.
  HomeVisitSignalProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'homeVisitSignalProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$homeVisitSignalHash();

  @$internal
  @override
  HomeVisitSignal create() => HomeVisitSignal();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$homeVisitSignalHash() => r'81b20dff3b60e2fa84bfbf79e5cbbf1588cd8825';

/// Emits an incrementing token each time the visible location *leaves* the
/// Home tab's root route (`/home`) -- whether by switching tabs or by pushing
/// a nested route (SDG detail, daily fact, challenges). Widgets such as the
/// SDG carousel watch this so they reset their scroll position while Home is
/// offscreen, leaving it already centered (no visible jump) the next time the
/// kept-alive [IndexedStack] branch is shown.

abstract class _$HomeVisitSignal extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleCreate(ref, build);
  }
}
