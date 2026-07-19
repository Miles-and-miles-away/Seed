import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/transport/transport.dart';

const _tokyo = City(
  name: 'Tokyo',
  cc: 'JP',
  lat: 35.6895,
  lon: 139.6917,
  mass: 'ISL_JP',
);
const _osaka = City(
  name: 'Osaka',
  cc: 'JP',
  lat: 34.6938,
  lon: 135.5011,
  mass: 'ISL_JP',
);
const _london = City(
  name: 'London',
  cc: 'GB',
  lat: 51.5085,
  lon: -0.1257,
  mass: 'ISL_GB',
);
const _paris = City(
  name: 'Paris',
  cc: 'FR',
  lat: 48.8534,
  lon: 2.3488,
  mass: 'Eurasia',
);
const _fukuoka = City(
  name: 'Fukuoka',
  cc: 'JP',
  lat: 33.6,
  lon: 130.4167,
  mass: 'ISL_JP',
);
const _busan = City(
  name: 'Busan',
  cc: 'KR',
  lat: 35.1017,
  lon: 129.03,
  mass: 'Eurasia',
);

const _links = [
  CityLink(a: 'ISL_GB', b: 'Eurasia', kind: 'rail_tunnel'),
  CityLink(a: 'ISL_GB', b: 'Eurasia', kind: 'ferry'),
  CityLink(a: 'ISL_JP', b: 'Eurasia', kind: 'ferry'),
];

void main() {
  group('haversineKm', () {
    test('identical points are zero', () {
      expect(haversineKm(35, 139, 35, 139), 0);
    });

    test('Tokyo-Osaka is about 397 km', () {
      final d = haversineKm(_tokyo.lat, _tokyo.lon, _osaka.lat, _osaka.lon);
      expect(d, closeTo(397, 4));
    });

    test('London-Paris is about 343 km', () {
      final d = haversineKm(_london.lat, _london.lon, _paris.lat, _paris.lon);
      expect(d, closeTo(343, 4));
    });

    test('Tokyo-London is about 9560 km', () {
      final d = haversineKm(_tokyo.lat, _tokyo.lon, _london.lat, _london.lon);
      expect(d, closeTo(9560, 60));
    });

    test('is symmetric', () {
      final ab = haversineKm(_tokyo.lat, _tokyo.lon, _paris.lat, _paris.lon);
      final ba = haversineKm(_paris.lat, _paris.lon, _tokyo.lat, _tokyo.lon);
      expect(ab, ba);
    });

    test('antipodal points stay finite (no NaN from float error)', () {
      final d = haversineKm(35.6895, 139.6917, -35.6895, -40.3083);
      expect(d.isFinite, isTrue);
      expect(d, closeTo(20015, 2));
      expect(haversineKm(0, 0, 0, 180).isFinite, isTrue);
    });
  });

  group('suggestedDistancesKm', () {
    test('same landmass mid-range: ground and air, no ferry', () {
      final s = suggestedDistancesKm(_tokyo, _osaka, _links);
      expect(s.keys, unorderedEquals([kindGround, kindAir]));
      expect(s[kindGround], closeTo(397 * groundCircuityFactor, 6));
      expect(s[kindAir], closeTo(397 + flightDetourKm, 5));
    });

    test('rail tunnel link enables ground across masses', () {
      final s = suggestedDistancesKm(_london, _paris, _links);
      expect(s.keys, unorderedEquals([kindGround, kindAir, kindFerry]));
      expect(s[kindGround], closeTo(343 * groundCircuityFactor, 6));
      expect(s[kindFerry], closeTo(343, 4));
    });

    test('ferry link alone does not enable ground', () {
      // 210 km straight-line: below minFlightKm, so ferry only.
      final s = suggestedDistancesKm(_fukuoka, _busan, _links);
      expect(s.keys, unorderedEquals([kindFerry]));
    });

    test('unlinked long haul is air only', () {
      final s = suggestedDistancesKm(_tokyo, _london, _links);
      expect(s.keys, [kindAir]);
      expect(s[kindAir], closeTo(9560 + flightDetourKm, 60));
    });

    test('short same-mass hop: ground and active, no air', () {
      const a = City(name: 'A', cc: 'JP', lat: 35, lon: 139, mass: 'ISL_JP');
      const b = City(
        name: 'B',
        cc: 'JP',
        lat: 35.5,
        lon: 139.5,
        mass: 'ISL_JP',
      );
      final s = suggestedDistancesKm(a, b, _links);
      expect(s.keys, unorderedEquals([kindGround, kindActive]));
    });

    test('ground is capped at groundModeMaxKm straight-line', () {
      const a = City(name: 'A', cc: 'US', lat: 40, lon: -74, mass: 'NA');
      const b = City(name: 'B', cc: 'US', lat: 40, lon: -104, mass: 'NA');
      final s = suggestedDistancesKm(a, b, _links);
      expect(s.keys, [kindAir]);
    });

    test('per-link maxKm overrides the global ferry cap', () {
      // Fukuoka-Busan is ~210 km: inside the 500 km default,
      // outside a 200 km per-link cap.
      const capped = [
        CityLink(a: 'ISL_JP', b: 'Eurasia', kind: 'ferry', maxKm: 200),
      ];
      expect(
        suggestedDistancesKm(_fukuoka, _busan, _links).keys,
        contains(kindFerry),
      );
      expect(
        suggestedDistancesKm(_fukuoka, _busan, capped).keys,
        isNot(contains(kindFerry)),
      );
    });

    test('port catchments gate ferry links on both sides', () {
      // Ports at the two cities: tight radii admit them, a tight
      // b-side radius centered elsewhere rejects the pair, and a
      // portless link (legacy) admits on distance alone.
      const anchored = [
        CityLink(
          a: 'ISL_JP',
          b: 'Eurasia',
          kind: 'ferry',
          portALat: 33.6,
          portALon: 130.4167,
          radiusAKm: 50,
          portBLat: 35.1017,
          portBLon: 129.03,
          radiusBKm: 50,
        ),
      ];
      const rejecting = [
        CityLink(
          a: 'ISL_JP',
          b: 'Eurasia',
          kind: 'ferry',
          portALat: 33.6,
          portALon: 130.4167,
          radiusAKm: 50,
          // Port near Seoul: Busan is ~330 km away.
          portBLat: 37.566,
          portBLon: 126.978,
          radiusBKm: 50,
        ),
      ];
      expect(
        suggestedDistancesKm(_fukuoka, _busan, anchored).keys,
        contains(kindFerry),
      );
      expect(
        suggestedDistancesKm(_busan, _fukuoka, anchored).keys,
        contains(kindFerry),
        reason: 'orientation must not matter',
      );
      expect(
        suggestedDistancesKm(_fukuoka, _busan, rejecting).keys,
        isNot(contains(kindFerry)),
      );
    });

    test('waterBlocked suppresses ground and active, not air', () {
      // ~130 km apart: active-eligible, and above the 100 km
      // air-fallback floor once ground is suppressed.
      const a = City(name: 'A', cc: 'FI', lat: 60.17, lon: 24.94, mass: 'EU');
      const b = City(name: 'B', cc: 'EE', lat: 59, lon: 24.94, mass: 'EU');
      final open = suggestedDistancesKm(a, b, _links);
      expect(open.keys, unorderedEquals([kindGround, kindActive]));
      final blocked = suggestedDistancesKm(
        a,
        b,
        _links,
        waterBlocked: {cityPairKey(a, b)},
      );
      // Sub-250 km with ground gone falls back to air (>= 100 km).
      expect(blocked.keys, [kindAir]);
    });

    test('air fallback only fires at or above fallbackAirMinKm', () {
      const a = City(name: 'A', cc: 'XX', lat: 18, lon: -63, mass: 'ISL_A');
      // ~55 km away, cross-water, no link: local boat hop.
      const near = City(
        name: 'B',
        cc: 'YY',
        lat: 18.5,
        lon: -63,
        mass: 'ISL_B',
      );
      // ~167 km away: real island hop, flight is the fallback.
      const far = City(name: 'C', cc: 'ZZ', lat: 19.5, lon: -63, mass: 'ISL_C');
      expect(suggestedDistancesKm(a, near, _links), isEmpty);
      final s = suggestedDistancesKm(a, far, _links);
      expect(s.keys, [kindAir]);
    });

    test('NaN coordinates return an empty map, not a NaN flight', () {
      const bad = City(
        name: 'Bad',
        cc: 'XX',
        lat: double.nan,
        lon: 0,
        mass: 'ISL_X',
      );
      expect(suggestedDistancesKm(bad, _tokyo, _links), isEmpty);
    });

    test('real dataset: Fukuoka-Busan offers the ferry', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final cities = await loadCities();
      final links = await loadCityLinks();
      final fukuoka = cities.firstWhere((c) => c.name == 'Fukuoka');
      final busan = cities.firstWhere((c) => c.name == 'Busan');
      final s = suggestedDistancesKm(fukuoka, busan, links);
      expect(s.keys, contains(kindFerry));
      expect(s[kindFerry], closeTo(210, 8));
    });
  });

  group('real dataset geography regressions', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    late List<City> cities;
    late List<CityLink> links;
    late Set<String> waterBlocked;

    setUpAll(() async {
      cities = await loadCities();
      links = await loadCityLinks();
      waterBlocked = await loadWaterBlockedPairs();
    });

    City city(String name, String cc) =>
        cities.firstWhere((c) => c.name == name && c.cc == cc);

    Map<String, double> suggest(City a, City b) =>
        suggestedDistancesKm(a, b, links, waterBlocked: waterBlocked);

    test('Tokyo-Madrid: intercontinental ferry link is gated', () {
      final s = suggest(city('Tokyo', 'JP'), city('Madrid', 'ES'));
      expect(s.keys, isNot(contains(kindFerry)));
    });

    test('Mariehamn-Stockholm: no ground or active across the sea', () {
      final s = suggest(city('Mariehamn', 'AX'), city('Stockholm', 'SE'));
      expect(s.keys, isNot(contains(kindGround)));
      expect(s.keys, isNot(contains(kindActive)));
    });

    test('Bandar Seri Begawan-Singapore: no ground across the sea', () {
      final s = suggest(
        city('Bandar Seri Begawan', 'BN'),
        city('Singapore', 'SG'),
      );
      expect(s.keys, isNot(contains(kindGround)));
    });

    test('Naples-Palermo: no ground across the Tyrrhenian, ferry ok', () {
      final s = suggest(city('Naples', 'IT'), city('Palermo', 'IT'));
      expect(s.keys, isNot(contains(kindGround)));
      expect(s.keys, contains(kindFerry));
    });

    test('Marigot-Philipsburg: shared island suggests ground', () {
      final s = suggest(city('Marigot', 'MF'), city('Philipsburg', 'SX'));
      expect(s, isNotEmpty);
      expect(s.keys, contains(kindGround));
      expect(s.keys, contains(kindActive));
    });

    test('Zanzibar-Dar es Salaam: ferry across the channel, no ground', () {
      final s = suggest(city('Zanzibar', 'TZ'), city('Dar es Salaam', 'TZ'));
      expect(s.keys, isNot(contains(kindGround)));
      expect(s.keys, isNot(contains(kindActive)));
      expect(s.keys, contains(kindFerry));
    });

    test('London-Torshavn: no ground across the Norwegian Sea', () {
      final s = suggest(city('London', 'GB'), city('Tórshavn', 'FO'));
      expect(s.keys, isNot(contains(kindGround)));
      expect(s.keys, isNot(contains(kindActive)));
    });

    test('Moroni-Moutsamoudou: no ground or active across open ocean', () {
      final s = suggest(city('Moroni', 'KM'), city('Moutsamoudou', 'KM'));
      expect(s.keys, isNot(contains(kindGround)));
      expect(s.keys, isNot(contains(kindActive)));
    });

    test('Port Said-Gaza: no fictional Red Sea/Levant ferry', () {
      final s = suggest(city('Port Said', 'EG'), city('Gaza', 'PS'));
      expect(s.keys, isNot(contains(kindFerry)));
    });

    test('Dublin-Paris: Ireland-France ferry link is alive', () {
      final s = suggest(city('Dublin', 'IE'), city('Paris', 'FR'));
      expect(s.keys, contains(kindFerry));
    });

    test('Dublin-Amsterdam: outside the Cherbourg catchment, no ferry', () {
      // The pre-port link suggested an 851 km foot-ferry to
      // inland Groningen; ports scope the corridor to France.
      final s = suggest(city('Dublin', 'IE'), city('Amsterdam', 'NL'));
      expect(s.keys, isNot(contains(kindFerry)));
    });

    test('Gibraltar-Tangier: strait ferry inside both catchments', () {
      final s = suggest(city('Gibraltar', 'GI'), city('Tangier', 'MA'));
      expect(s.keys, contains(kindFerry));
    });

    test('Sevilla-Tangier: revived by ports (killed by the old cap)', () {
      final s = suggest(city('Sevilla', 'ES'), city('Tangier', 'MA'));
      expect(s.keys, contains(kindFerry));
    });

    test('Hiroshima-Busan: in ferry range, outside the Hakata port', () {
      final s = suggest(city('Hiroshima', 'JP'), city('Busan', 'KR'));
      expect(s.keys, isNot(contains(kindFerry)));
      expect(s.keys, contains(kindAir));
    });

    test('London-Paris: tunnel ground stays, port-gated ferry goes', () {
      // Paris is ~237 km from Calais: outside the foot-ferry
      // catchment, but the Channel Tunnel still grounds the pair.
      final s = suggest(city('London', 'GB'), city('Paris', 'FR'));
      expect(s.keys, contains(kindGround));
      expect(s.keys, isNot(contains(kindFerry)));
    });

    test('Osaka-Busan: just over the ferry gate, no ferry', () {
      final s = suggest(city('Osaka', 'JP'), city('Busan', 'KR'));
      expect(s.keys, isNot(contains(kindFerry)));
    });

    test('San Juan-Charlotte Amalie: real island hop keeps its flight', () {
      final s = suggest(city('San Juan', 'PR'), city('Charlotte Amalie', 'VI'));
      expect(s.keys, contains(kindAir));
    });

    test('Marigot-The Valley: sub-100 km boat hop suggests nothing', () {
      final s = suggest(city('Marigot', 'MF'), city('The Valley', 'AI'));
      expect(s, isEmpty);
    });

    test('Mombasa-Zanzibar: no ferry runs; ports keep the link silent', () {
      // 240 km is inside the default ferry cap; without the port
      // catchments the fictional ferry would be this pair's ONLY
      // suggestion (the Port Said-Gaza failure mode).
      final s = suggest(city('Mombasa', 'KE'), city('Zanzibar', 'TZ'));
      expect(s.keys, isNot(contains(kindFerry)));
      expect(s.keys, contains(kindAir));
    });

    test('Helsinki-Tallinn: no cycling across the Gulf of Finland', () {
      final s = suggest(city('Helsinki', 'FI'), city('Tallinn', 'EE'));
      expect(s.keys, isNot(contains(kindGround)));
      expect(s.keys, isNot(contains(kindActive)));
    });

    test('Kinshasa-Brazzaville: no walk across the unbridged Congo', () {
      final s = suggest(city('Kinshasa', 'CD'), city('Brazzaville', 'CG'));
      expect(s.keys, isNot(contains(kindGround)));
      expect(s.keys, isNot(contains(kindActive)));
    });

    test('Copenhagen-Malmo: bridged strait keeps its ground', () {
      final s = suggest(city('Copenhagen', 'DK'), city('Malmö', 'SE'));
      expect(s.keys, contains(kindGround));
    });

    test('Wellington-Christchurch: Cook Strait ferry exists', () {
      final s = suggest(city('Wellington', 'NZ'), city('Christchurch', 'NZ'));
      expect(s.keys, contains(kindFerry));
      expect(s.keys, isNot(contains(kindGround)));
    });

    test('Charlotte Amalie-Saint Croix: real ferry, not an empty map', () {
      final s = suggest(
        city('Charlotte Amalie', 'VI'),
        city('Saint Croix', 'VI'),
      );
      expect(s.keys, contains(kindFerry));
    });

    test('Malta-Palermo: no direct ferry corridor, air only', () {
      final s = suggest(city('Birkirkara', 'MT'), city('Palermo', 'IT'));
      expect(s.keys, isNot(contains(kindFerry)));
      expect(s.keys, contains(kindAir));
    });

    test('every link produces at least one suggesting pair', () {
      // Would have caught the Round 1 regression that left the
      // Ireland-France link permanently dead (closest pair 723 km
      // against the 500 km global cap).
      for (final link in links) {
        final kind = link.kind == 'rail_tunnel' ? kindGround : kindFerry;
        final aCities = cities.where((c) => c.mass == link.a).toList();
        final bCities = cities.where((c) => c.mass == link.b).toList();
        final reachable = aCities.any(
          (a) => bCities.any(
            (b) => suggestedDistancesKm(a, b, links).containsKey(kind),
          ),
        );
        expect(reachable, isTrue, reason: link.label);
      }
    });
  });
}
