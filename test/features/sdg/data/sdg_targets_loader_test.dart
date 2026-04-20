import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/sdg/data/sdg_targets_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadSdgTargets', () {
    test('returns targets for every SDG goal', () async {
      final map = await loadSdgTargets();

      for (var n = AppConstants.sdgMinGoal; n <= AppConstants.sdgMaxGoal; n++) {
        expect(
          map.containsKey(n),
          isTrue,
          reason: 'missing targets for SDG $n',
        );
        expect(map[n], isNotEmpty, reason: 'empty target list for SDG $n');
      }
    });

    test('total target count is 169 (UN canonical count)', () async {
      final map = await loadSdgTargets();

      final total = map.values.fold<int>(0, (sum, list) => sum + list.length);
      expect(total, 169);
    });
  });
}
