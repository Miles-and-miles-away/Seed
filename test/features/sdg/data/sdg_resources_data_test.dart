import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/sdg/data/sdg_resources_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadSdgResources', () {
    test('every resource has a non-empty title and URL', () async {
      final map = await loadSdgResources();

      expect(map, isNotEmpty);
      for (final entry in map.entries) {
        for (final r in entry.value) {
          expect(
            r.titleEn,
            isNotEmpty,
            reason: 'SDG ${entry.key} resource missing title',
          );
          expect(
            r.url,
            isNotEmpty,
            reason: 'SDG ${entry.key} resource missing url',
          );
        }
      }
    });

    test('all keys are positive SDG goal numbers', () async {
      final map = await loadSdgResources();

      for (final k in map.keys) {
        expect(k, greaterThan(0));
        expect(k, lessThanOrEqualTo(17));
      }
    });
  });
}
