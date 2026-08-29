import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/transport/transport.dart';

String? _jaName(List<City> cities, String name, String cc) =>
    cities.firstWhere((c) => c.name == name && c.cc == cc).nameJa;

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

    test('every city name is typable on an ASCII keyboard', () async {
      // 135 names carry diacritics; an unfolded one is unreachable by
      // ordinary typing in every locale, English included.
      final cities = await loadCities();
      for (final city in cities) {
        expect(
          foldForSearch(city.name),
          matches(RegExp(r'^[ -~]+$')),
          reason: city.name,
        );
      }
    });

    test('sourced localized names cover most of the list', () async {
      final cities = await loadCities();
      final ja = cities.where((c) => c.nameJa != null).toList();
      final es = cities.where((c) => c.nameEs != null).toList();
      expect(ja.length, greaterThan(700));
      expect(es.length, greaterThan(250));
      for (final city in cities) {
        expect(city.nameJa, isNot(''), reason: city.name);
        expect(city.nameEs, isNot(''), reason: city.name);
        expect(city.localizedName('en'), city.name, reason: city.name);
      }
      // Partial coverage is the expected outcome: unlocalized cities
      // fall back to the English name rather than a transliteration.
      final plain = cities.firstWhere((c) => c.nameEs == null);
      expect(plain.localizedName('es'), plain.name);
    });

    test('island-suffixed JA names are a reviewed keep', () async {
      // Wikidata models these four places as islands and 島 is the
      // ordinary Japanese rendering for them, so the entity is right
      // and the suffix stays rather than being read as a bad match.
      final cities = await loadCities();
      expect(_jaName(cities, 'Taipa', 'MO'), 'タイパ島');
      expect(_jaName(cities, 'Saipan', 'MP'), 'サイパン島');
      expect(_jaName(cities, 'Providenciales', 'TC'), 'プロビデンシアレス島');
      expect(_jaName(cities, 'West Island', 'CC'), 'ウェスト島');
    });

    test('alternate-label matches never reach the JA names', () async {
      // Matching Wikidata skos:altLabel instead of the primary label
      // resolves both of these to a nearer, different place that the
      // coordinate gate cannot catch, so the enrichment matches the
      // primary label only. Reinstating altLabel breaks these pins.
      final cities = await loadCities();
      // Cape Bojador, a headland 1.5 km offshore, answers to
      // "Boujdour" and would ship カボ・ボハドール over the city.
      expect(_jaName(cities, 'Boujdour', 'EH'), 'ブジュール');
      // Sekondi-Takoradi, the twin city 6 km away, answers to
      // "Sekondi"; neither source localizes Sekondi itself.
      expect(_jaName(cities, 'Sekondi', 'GH'), isNull);
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
