import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/features/home/presentation/providers/home_providers.dart';

void main() {
  testWidgets('HomeVisitSignal counts each tab switch away from /home', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: appRoutes.home,
      routes: [
        GoRoute(
          path: appRoutes.home,
          builder: (_, _) => const Text('home'),
          routes: [GoRoute(path: 'sub', builder: (_, _) => const Text('sub'))],
        ),
        GoRoute(
          path: appRoutes.progress,
          builder: (_, _) => const Text('progress'),
        ),
        GoRoute(
          path: appRoutes.mascot,
          builder: (_, _) => const Text('mascot'),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [routerProvider.overrideWithValue(router)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.text('home')),
    );
    final emitted = <int>[];
    container.listen(
      homeVisitSignalProvider,
      (_, next) => emitted.add(next),
      fireImmediately: true,
    );
    expect(emitted, [0]);

    router.go(appRoutes.progress);
    await tester.pumpAndSettle();
    expect(emitted, [0, 1]);

    // Moving between two other tabs is not a departure either.
    router.go(appRoutes.mascot);
    await tester.pumpAndSettle();
    expect(emitted, [0, 1]);

    // Coming back is not a departure.
    router.go(appRoutes.home);
    await tester.pumpAndSettle();
    expect(emitted, [0, 1]);

    router.go(appRoutes.progress);
    await tester.pumpAndSettle();
    expect(emitted, [0, 1, 2]);

    // A route pushed on top of Home keeps the configuration uri at
    // /home, so the carousel keeps the goal the user tapped.
    router.go(appRoutes.home);
    await tester.pumpAndSettle();
    unawaited(router.push('${appRoutes.home}/sub'));
    await tester.pumpAndSettle();
    expect(find.text('sub'), findsOneWidget);
    expect(emitted, [0, 1, 2]);
  });
}
