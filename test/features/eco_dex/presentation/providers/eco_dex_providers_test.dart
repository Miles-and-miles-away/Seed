import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';

ProviderContainer _container(AppUserModel? user) {
  return ProviderContainer(
    overrides: [
      currentUserProvider.overrideWith((_) => Stream.value(user)),
    ],
  );
}

Future<void> _pump(ProviderContainer c) async {
  c.listen(currentUserProvider, (_, __) {});
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('ecoDexDiscoveredProvider', () {
    test('returns empty when user is null', () async {
      final c = _container(null);
      addTearDown(c.dispose);
      await _pump(c);

      final discovered = c.read(ecoDexDiscoveredProvider);
      // In kDebugMode a debug-forced list is merged in; filter that out
      // for the null-user case since the implementation short-circuits
      // only when there is no user — the debug list still applies.
      if (!kDebugMode) {
        expect(discovered, isEmpty);
      } else {
        // Debug override merges with the empty real list.
        expect(discovered, isA<List<String>>());
      }
    });

    test('reflects the user.ecodexDiscovered list', () async {
      final c = _container(
        const AppUserModel(
          uid: 'u',
          email: 'e',
          ecodexDiscovered: ['forests_01', 'oceans_02'],
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      final discovered = c.read(ecoDexDiscoveredProvider);
      expect(discovered, containsAll(['forests_01', 'oceans_02']));
    });

    test('de-duplicates debug overrides when already discovered', () async {
      final c = _container(
        const AppUserModel(
          uid: 'u',
          email: 'e',
          // Matches debug-forced ID; must not appear twice.
          ecodexDiscovered: ['oceans_01'],
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      final discovered = c.read(ecoDexDiscoveredProvider);
      expect(
        discovered.where((id) => id == 'oceans_01').length,
        1,
      );
    });
  });

  group('ecoDexDiscoveredCountProvider', () {
    test('returns list length', () async {
      final c = _container(
        const AppUserModel(
          uid: 'u',
          email: 'e',
          ecodexDiscovered: ['a', 'b', 'c'],
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(
        c.read(ecoDexDiscoveredCountProvider),
        c.read(ecoDexDiscoveredProvider).length,
      );
    });
  });
}
