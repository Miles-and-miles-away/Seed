import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/energy/data/energy_behaviors_data.dart';

/// Exercises the asset loader itself (Phase 8.13).
///
/// The other data tests read the JSON off disk with File(), which does
/// not prove the asset path or the pubspec `data/app/` declaration is
/// right -- the app would fail at runtime with the tests green.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loadEnergyBehaviors resolves the bundled asset', () async {
    final behaviors = await loadEnergyBehaviors();
    expect(behaviors, hasLength(ENERGY_BEHAVIOR_COUNT));
    // Parsed, not just counted.
    final bath = behaviors.firstWhere((b) => b.id == 'bath_electric');
    expect(bath.kwhPerUnit, 5.692960);
    expect(bath.presets, isNotEmpty);
  });

  test('loadEnergyMetadata resolves both carrier factors', () async {
    final metadata = await loadEnergyMetadata();
    expect(metadata['grid_factor_g_per_kwh'], 458);
    expect(metadata['gas_factor_g_per_kwh'], 182);
  });
}
