import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/app_constants.dart';

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

  group('citySuggestions waterBlocked threading', () {
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

    test('a same-city pair yields no suggestions', () async {
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

  group('JourneyOptions', () {
    const legA = JourneyLeg(modeId: 'a', distanceKm: 10);
    const legB = JourneyLeg(modeId: 'b', distanceKm: 20, occupants: 2);

    test('starts as two empty options', () {
      final container = createContainer();
      expect(container.read(journeyOptionsProvider), [
        <JourneyLeg>[],
        <JourneyLeg>[],
      ]);
    });

    test('adds legs to the named option only', () {
      final container = createContainer();
      container.read(journeyOptionsProvider.notifier)
        ..addLeg(optionA, legA)
        ..addLeg(optionB, legB)
        ..addLeg(optionA, legB);
      expect(container.read(journeyOptionsProvider), [
        [legA, legB],
        [legB],
      ]);
    });

    test('updates and removes within one option', () {
      final container = createContainer();
      final notifier = container.read(journeyOptionsProvider.notifier)
        ..addLeg(optionA, legA)
        ..addLeg(optionA, legB)
        ..addLeg(optionB, legA)
        ..updateLeg(optionA, 0, const JourneyLeg(modeId: 'a', distanceKm: 99));
      expect(container.read(journeyOptionsProvider)[optionA], [
        const JourneyLeg(modeId: 'a', distanceKm: 99),
        legB,
      ]);

      notifier.removeLeg(optionA, 0);
      expect(container.read(journeyOptionsProvider), [
        [legB],
        [legA],
      ]);
    });

    // Out-of-range indices are reachable from a stale rebuild, so
    // they must no-op rather than throw and blank the screen.
    test('ignores out-of-range options and indices', () {
      final container = createContainer();
      container.read(journeyOptionsProvider.notifier)
        ..addLeg(optionA, legA)
        ..addLeg(optionCount, legB)
        ..addLeg(-1, legB)
        ..removeLeg(optionA, 5)
        ..updateLeg(optionA, -1, legB)
        ..removeLeg(optionCount, 0);
      expect(container.read(journeyOptionsProvider), [
        [legA],
        <JourneyLeg>[],
      ]);
    });

    test('clear empties both options', () {
      final container = createContainer();
      container.read(journeyOptionsProvider.notifier)
        ..addLeg(optionA, legA)
        ..addLeg(optionB, legB)
        ..clear();
      expect(container.read(journeyOptionsProvider), [
        <JourneyLeg>[],
        <JourneyLeg>[],
      ]);
    });
  });

  group('JourneyOptions index boundary', () {
    test('an index equal to the leg count is ignored', () {
      const only = JourneyLeg(modeId: 'a', distanceKm: 1);
      const other = JourneyLeg(modeId: 'b', distanceKm: 2);
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(journeyOptionsProvider.notifier)
        ..addLeg(optionA, only)
        ..updateLeg(optionA, 1, other)
        ..removeLeg(optionA, 1);

      expect(container.read(journeyOptionsProvider)[optionA], [only]);
    });
  });
}
