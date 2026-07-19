import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/transport/transport.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadCities dataset validation', () {
    test('loads exactly $CITY_COUNT cities', () async {
      final cities = await loadCities();
      expect(cities.length, CITY_COUNT);
    });

    test('city name+country pairs are unique', () async {
      final cities = await loadCities();
      final keys = cities.map((c) => '${c.name}|${c.cc}').toSet();
      expect(keys.length, cities.length);
    });

    test('coordinates are in valid ranges', () async {
      final cities = await loadCities();
      for (final city in cities) {
        expect(city.lat, inInclusiveRange(-90, 90), reason: city.name);
        expect(city.lon, inInclusiveRange(-180, 180), reason: city.name);
      }
    });

    test('every city has a landmass tag and population', () async {
      final cities = await loadCities();
      for (final city in cities) {
        expect(city.mass, isNotEmpty, reason: city.name);
        expect(city.pop, greaterThan(0), reason: city.name);
      }
    });

    test('primary market gets dense coverage', () async {
      final cities = await loadCities();
      final jp = cities.where((c) => c.cc == 'JP').toList();
      expect(jp.length, greaterThanOrEqualTo(15));
      expect(jp.map((c) => c.name), contains('Tokyo'));
      expect(jp.map((c) => c.name), contains('Fukuoka'));
    });

    test('cities are sorted by population descending', () async {
      final cities = await loadCities();
      for (var i = 1; i < cities.length; i++) {
        expect(
          cities[i - 1].pop,
          greaterThanOrEqualTo(cities[i].pop),
          reason: cities[i].name,
        );
      }
    });
  });

  group('loadCityLinks validation', () {
    test('links have known kinds and reference existing masses', () async {
      final cities = await loadCities();
      final masses = cities.map((c) => c.mass).toSet();
      final links = await loadCityLinks();
      expect(links, isNotEmpty);
      for (final link in links) {
        expect(const {'rail_tunnel', 'ferry'}, contains(link.kind));
        expect(masses, contains(link.a), reason: link.label);
        expect(masses, contains(link.b), reason: link.label);
      }
    });

    test('Channel Tunnel and Busan-Fukuoka ferry are present', () async {
      final links = await loadCityLinks();
      expect(
        links.any(
          (l) =>
              l.kind == 'rail_tunnel' &&
              {l.a, l.b}.containsAll({'ISL_GB', 'Eurasia'}),
        ),
        isTrue,
      );
      expect(
        links.any(
          (l) =>
              l.kind == 'ferry' &&
              {l.a, l.b}.containsAll({'ISL_JP', 'Eurasia'}),
        ),
        isTrue,
      );
    });
  });
}
