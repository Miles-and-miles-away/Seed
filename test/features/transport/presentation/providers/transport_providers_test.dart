import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/transport/transport.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('dataset providers', () {
    test('transportModes loads the full dataset', () async {
      final container = createContainer();
      final modes = await container.read(transportModesProvider.future);
      expect(modes.length, TRANSPORT_MODE_COUNT);
    });

    test('transportModesById indexes every mode', () async {
      final container = createContainer();
      final modes = await container.read(transportModesProvider.future);
      final byId = await container.read(transportModesByIdProvider.future);
      expect(byId.length, modes.length);
      for (final mode in modes) {
        expect(byId[mode.id], mode);
      }
    });

    test('transportCities loads the full dataset', () async {
      final container = createContainer();
      final cities = await container.read(transportCitiesProvider.future);
      expect(cities.length, CITY_COUNT);
    });

    test('transportMetadata exposes the scope statement', () async {
      final container = createContainer();
      final metadata = await container.read(transportMetadataProvider.future);
      expect(metadata['scope'], isNotEmpty);
    });
  });

  group('citySuggestions waterBlocked threading (PDR R4-10)', () {
    Future<(City, City)> helsinkiTallinn(ProviderContainer container) async {
      final cities = await container.read(transportCitiesProvider.future);
      return (
        cities.firstWhere((c) => c.name == 'Helsinki'),
        cities.firstWhere((c) => c.name == 'Tallinn'),
      );
    }

    test('Helsinki-Tallinn gets no ground or active suggestion', () async {
      final container = createContainer();
      final (helsinki, tallinn) = await helsinkiTallinn(container);
      final suggestions = await container.read(
        citySuggestionsProvider(helsinki, tallinn).future,
      );
      expect(suggestions, isNot(contains(kindGround)));
      expect(suggestions, isNot(contains(kindActive)));
    });

    test('the blocklist is what suppresses ground for the pair', () async {
      // Control: the same pair with the silent empty default WOULD
      // suggest ground, so the provider's answer above is owed to
      // its loadWaterBlockedPairs threading -- pinning the wiring.
      final container = createContainer();
      final (helsinki, tallinn) = await helsinkiTallinn(container);
      final links = await container.read(transportCityLinksProvider.future);
      final unthreaded = suggestedDistancesKm(helsinki, tallinn, links);
      expect(unthreaded, contains(kindGround));
    });

    test('a same-city pair yields no suggestions (PDR R5-19)', () async {
      // Without the provider guard the pair would suggest "~0 km"
      // ground and active estimates.
      final container = createContainer();
      final (helsinki, _) = await helsinkiTallinn(container);
      final suggestions = await container.read(
        citySuggestionsProvider(helsinki, helsinki).future,
      );
      expect(suggestions, isEmpty);
    });
  });

  group('JourneyBuilder', () {
    const legA = JourneyLeg(modeId: 'a', distanceKm: 10);
    const legB = JourneyLeg(modeId: 'b', distanceKm: 20, occupants: 2);

    // The provider is autoDispose by design (ephemeral screen
    // state); a listener stands in for the screen watching it.
    ProviderContainer createListenedContainer() =>
        createContainer()..listen(journeyBuilderProvider, (_, _) {});

    test('starts empty and adds legs in order', () {
      final container = createListenedContainer();
      final notifier = container.read(journeyBuilderProvider.notifier);
      expect(container.read(journeyBuilderProvider), isEmpty);
      notifier
        ..addLeg(legA)
        ..addLeg(legB);
      expect(container.read(journeyBuilderProvider), [legA, legB]);
    });

    test('updates the leg at an index', () {
      final container = createListenedContainer();
      container.read(journeyBuilderProvider.notifier)
        ..addLeg(legA)
        ..addLeg(legB)
        ..updateLeg(0, const JourneyLeg(modeId: 'a', distanceKm: 99));
      expect(container.read(journeyBuilderProvider), [
        const JourneyLeg(modeId: 'a', distanceKm: 99),
        legB,
      ]);
    });

    test('removes the leg at an index', () {
      final container = createListenedContainer();
      container.read(journeyBuilderProvider.notifier)
        ..addLeg(legA)
        ..addLeg(legB)
        ..removeLeg(0);
      expect(container.read(journeyBuilderProvider), [legB]);
    });
  });
}
