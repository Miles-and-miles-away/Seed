// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Emits an incrementing token each time the user switches away from the
/// Home tab. Widgets such as the SDG carousel watch this so they reset their
/// scroll position while Home is offscreen, leaving it already centered (no
/// visible jump) the next time the kept-alive [IndexedStack] branch is shown.
///
/// Routes pushed on top of Home (SDG detail, daily fact, challenges) do not
/// count: go_router keeps the configuration uri at `/home` for imperative
/// pushes, and popping back should return the user to the goal they tapped.

@ProviderFor(HomeVisitSignal)
final homeVisitSignalProvider = HomeVisitSignalProvider._();

/// Emits an incrementing token each time the user switches away from the
/// Home tab. Widgets such as the SDG carousel watch this so they reset their
/// scroll position while Home is offscreen, leaving it already centered (no
/// visible jump) the next time the kept-alive [IndexedStack] branch is shown.
///
/// Routes pushed on top of Home (SDG detail, daily fact, challenges) do not
/// count: go_router keeps the configuration uri at `/home` for imperative
/// pushes, and popping back should return the user to the goal they tapped.
final class HomeVisitSignalProvider
    extends $NotifierProvider<HomeVisitSignal, int> {
  /// Emits an incrementing token each time the user switches away from the
  /// Home tab. Widgets such as the SDG carousel watch this so they reset their
  /// scroll position while Home is offscreen, leaving it already centered (no
  /// visible jump) the next time the kept-alive [IndexedStack] branch is shown.
  ///
  /// Routes pushed on top of Home (SDG detail, daily fact, challenges) do not
  /// count: go_router keeps the configuration uri at `/home` for imperative
  /// pushes, and popping back should return the user to the goal they tapped.
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

/// Emits an incrementing token each time the user switches away from the
/// Home tab. Widgets such as the SDG carousel watch this so they reset their
/// scroll position while Home is offscreen, leaving it already centered (no
/// visible jump) the next time the kept-alive [IndexedStack] branch is shown.
///
/// Routes pushed on top of Home (SDG detail, daily fact, challenges) do not
/// count: go_router keeps the configuration uri at `/home` for imperative
/// pushes, and popping back should return the user to the goal they tapped.

abstract class _$HomeVisitSignal extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
