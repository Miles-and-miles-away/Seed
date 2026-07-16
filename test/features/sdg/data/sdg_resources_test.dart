import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/sdg/data/sdg_resources.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SdgResource', () {
    const resource = SdgResource(
      titleEn: 'English Title',
      titleJa: 'Japanese Title',
      titleEs: 'Spanish Title',
      url: 'https://example.com',
      type: SdgResourceType.official,
    );

    test('title returns English for "en"', () {
      expect(resource.title('en'), 'English Title');
    });

    test('title returns Japanese for "ja"', () {
      expect(resource.title('ja'), 'Japanese Title');
    });

    test('title returns Spanish for "es"', () {
      expect(resource.title('es'), 'Spanish Title');
    });

    test('title falls back to English for unknown', () {
      expect(resource.title('fr'), 'English Title');
      expect(resource.title('de'), 'English Title');
    });
  });

  group('SdgResource.fromJson', () {
    test('parses JSON correctly', () {
      final resource = SdgResource.fromJson({
        'titleEn': 'EN',
        'titleJa': 'JA',
        'titleEs': 'ES',
        'url': 'https://example.com',
        'type': 'official',
      });
      expect(resource.titleEn, 'EN');
      expect(resource.type, SdgResourceType.official);
    });
  });

  group('SdgResourceType', () {
    test('has three values', () {
      expect(SdgResourceType.values.length, 3);
    });

    test('contains expected types', () {
      expect(
        SdgResourceType.values,
        containsAll([
          SdgResourceType.official,
          SdgResourceType.action,
          SdgResourceType.education,
        ]),
      );
    });
  });

  group('sdg_resources.json', () {
    late Map<int, List<SdgResource>> sdgResources;

    setUpAll(() async {
      final jsonString = await rootBundle.loadString(
        'data/app/sdg_resources.json',
      );
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      sdgResources = <int, List<SdgResource>>{};
      for (final entry in json.entries) {
        final goalNumber = int.parse(entry.key);
        final resources = (entry.value as List<dynamic>)
            .map((e) => SdgResource.fromJson(e as Map<String, dynamic>))
            .toList();
        sdgResources[goalNumber] = resources;
      }
    });

    test('contains all 17 goals', () {
      expect(sdgResources.length, 17);
    });

    test('keys are 1 through 17', () {
      for (var i = 1; i <= 17; i++) {
        expect(
          sdgResources.containsKey(i),
          isTrue,
          reason: 'Missing resources for goal $i',
        );
      }
    });

    test('each goal has at least 2 resources', () {
      for (final entry in sdgResources.entries) {
        expect(
          entry.value.length,
          greaterThanOrEqualTo(2),
          reason: 'Goal ${entry.key} has < 2 resources',
        );
      }
    });

    test('all resources have valid URLs', () {
      for (final entry in sdgResources.entries) {
        for (final resource in entry.value) {
          expect(
            resource.url,
            startsWith('https://'),
            reason:
                'Goal ${entry.key}: invalid URL '
                '${resource.url}',
          );
        }
      }
    });

    test('all resources have non-empty titles', () {
      for (final entry in sdgResources.entries) {
        for (final resource in entry.value) {
          expect(
            resource.titleEn,
            isNotEmpty,
            reason:
                'Goal ${entry.key} has empty EN '
                'title',
          );
          expect(
            resource.titleJa,
            isNotEmpty,
            reason:
                'Goal ${entry.key} has empty JA '
                'title',
          );
          expect(
            resource.titleEs,
            isNotEmpty,
            reason:
                'Goal ${entry.key} has empty ES '
                'title',
          );
        }
      }
    });

    test('each goal has an official resource', () {
      for (final entry in sdgResources.entries) {
        final hasOfficial = entry.value.any(
          (r) => r.type == SdgResourceType.official,
        );
        expect(
          hasOfficial,
          isTrue,
          reason:
              'Goal ${entry.key} missing official '
              'resource',
        );
      }
    });

    test('official resources link to UN SDG site', () {
      for (final entry in sdgResources.entries) {
        final official = entry.value.firstWhere(
          (r) => r.type == SdgResourceType.official,
        );
        expect(
          official.url,
          contains('sdgs.un.org'),
          reason:
              'Goal ${entry.key} official resource '
              'not on UN site',
        );
      }
    });
  });
}
