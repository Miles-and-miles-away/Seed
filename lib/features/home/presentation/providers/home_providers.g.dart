// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Emits an incrementing token each time the Home tab's root route
/// (`/home`) becomes the visible location -- whether by switching tabs or
/// by popping a nested route (SDG detail, daily fact, challenges) back to
/// Home. Widgets such as the SDG carousel watch this so every return to
/// Home restarts their scroll position rather than retaining wherever the
/// kept-alive [IndexedStack] branch was left.

@ProviderFor(HomeVisitSignal)
final homeVisitSignalProvider = HomeVisitSignalProvider._();

/// Emits an incrementing token each time the Home tab's root route
/// (`/home`) becomes the visible location -- whether by switching tabs or
/// by popping a nested route (SDG detail, daily fact, challenges) back to
/// Home. Widgets such as the SDG carousel watch this so every return to
/// Home restarts their scroll position rather than retaining wherever the
/// kept-alive [IndexedStack] branch was left.
final class HomeVisitSignalProvider
    extends $NotifierProvider<HomeVisitSignal, int> {
  /// Emits an incrementing token each time the Home tab's root route
  /// (`/home`) becomes the visible location -- whether by switching tabs or
  /// by popping a nested route (SDG detail, daily fact, challenges) back to
  /// Home. Widgets such as the SDG carousel watch this so every return to
  /// Home restarts their scroll position rather than retaining wherever the
  /// kept-alive [IndexedStack] branch was left.
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

String _$homeVisitSignalHash() => r'6f3317efd4af2c0ea5d561e40e3421c05a1793bc';

/// Emits an incrementing token each time the Home tab's root route
/// (`/home`) becomes the visible location -- whether by switching tabs or
/// by popping a nested route (SDG detail, daily fact, challenges) back to
/// Home. Widgets such as the SDG carousel watch this so every return to
/// Home restarts their scroll position rather than retaining wherever the
/// kept-alive [IndexedStack] branch was left.

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
