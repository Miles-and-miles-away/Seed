import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/app/router.dart';

part 'home_providers.g.dart';

/// Emits an incrementing token each time the visible location *leaves* the
/// Home tab's root route (`/home`) -- whether by switching tabs or by pushing
/// a nested route (SDG detail, daily fact, challenges). Widgets such as the
/// SDG carousel watch this so they reset their scroll position while Home is
/// offscreen, leaving it already centered (no visible jump) the next time the
/// kept-alive [IndexedStack] branch is shown.
@riverpod
class HomeVisitSignal extends _$HomeVisitSignal {
  @override
  int build() {
    final delegate = ref.watch(routerProvider).routerDelegate;
    bool isHome() => delegate.currentConfiguration.uri.path == appRoutes.home;
    var wasHome = isHome();

    void onRouteChanged() {
      final nowHome = isHome();
      if (wasHome && !nowHome) state = state + 1;
      wasHome = nowHome;
    }

    delegate.addListener(onRouteChanged);
    ref.onDispose(() => delegate.removeListener(onRouteChanged));
    return 0;
  }
}
