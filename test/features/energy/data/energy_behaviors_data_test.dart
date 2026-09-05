import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/energy/data/energy_behaviors_data.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';

import '../../../helpers/dataset_helpers.dart';

/// Dataset validation for data/app/energy_behaviors.json (Phase 8.13).
///
/// Reads the file from disk rather than through the asset bundle so the
/// checks cover the shipped JSON itself.
void main() {
  late Map<String, dynamic> root;
  late List<Map<String, dynamic>> raw;
  late List<EnergyBehavior> behaviors;

  setUpAll(() {
    root = rawDatasetRoot('data/app/energy_behaviors.json');
    raw = datasetEntries(root, 'behaviors');
    behaviors = raw.map(EnergyBehavior.fromJson).toList();
  });

  test('ships the researched behavior count', () {
    expect(behaviors, hasLength(ENERGY_BEHAVIOR_COUNT));
  });

  test('ids are unique', () {
    expect(behaviors.map((b) => b.id).toSet(), hasLength(behaviors.length));
  });

  test('an unknown carrier or unit throws rather than becoming null', () {
    // The old version of this test asserted isNotEmpty on two sets
    // built from 33 rows, which cannot fail while the file has any
    // rows at all. This actually exercises the failure mode.
    // ArgumentError is what json_serializable's $enumDecode throws;
    // throwsA(anything) also passed on unrelated TypeErrors.
    final valid = raw.first;
    expect(
      () => EnergyBehavior.fromJson({...valid, 'carrier': 'kerosene'}),
      throwsArgumentError,
    );
    expect(
      () => EnergyBehavior.fromJson({...valid, 'unit': 'fortnight'}),
      throwsArgumentError,
    );
  });

  test('all three locales are present for every behavior', () {
    for (final b in behaviors) {
      expect(b.nameEn, isNotEmpty, reason: '${b.id} name_en');
      expect(b.nameJa, isNotEmpty, reason: '${b.id} name_ja');
      expect(b.nameEs, isNotEmpty, reason: '${b.id} name_es');
      expect(b.name('en'), b.nameEn);
      expect(b.name('ja'), b.nameJa);
      expect(b.name('es'), b.nameEs);
      // Unknown locale falls back to English rather than blank.
      expect(b.name('de'), b.nameEn);
    }
  });

  test('kWh is positive, and zero only for the none carrier', () {
    for (final b in behaviors) {
      expect(b.kwhPerUnit, greaterThanOrEqualTo(0), reason: b.id);
      if (b.kwhPerUnit == 0) {
        expect(
          b.carrier,
          EnergyCarrier.none,
          reason: '${b.id} is zero but draws on a carrier',
        );
      } else {
        expect(
          b.carrier,
          isNot(EnergyCarrier.none),
          reason: '${b.id} has carrier none but a nonzero kWh',
        );
      }
    }
  });

  test('line_dry is the only zero-carrier entry', () {
    final none = behaviors.where((b) => b.carrier == EnergyCarrier.none);
    expect(none.map((b) => b.id), ['line_dry']);
  });

  test('every behavior has a non-empty comparable_group', () {
    for (final b in behaviors) {
      expect(b.comparableGroup, isNotEmpty, reason: b.id);
    }
  });

  test('every behavior ships the unit its research assigned', () {
    // The unit follows the physics of the behavior, not its group, so
    // three groups legitimately mix units: hot_water (shower per
    // minute, bath per use), cook (bake cycle, minute, hour) and
    // device (hour, use, day). Pinning each unit individually is the
    // guard that a group-level rule cannot give -- the oven in
    // particular must stay per bake cycle, because no per-hour oven
    // figure exists anywhere and a future edit "correcting" it to
    // hourly is the documented risk (RESEARCH_ENERGY.md section 3.4).
    const expected = {
      'shower_electric': EnergyUnit.minute,
      'shower_heatpump': EnergyUnit.minute,
      'shower_gas': EnergyUnit.minute,
      'bath_electric': EnergyUnit.use,
      'bath_gas': EnergyUnit.use,
      'dishwasher_eco': EnergyUnit.use,
      'dishwasher_normal': EnergyUnit.use,
      'wash_cold': EnergyUnit.use,
      'wash_warm': EnergyUnit.use,
      'wash_hot': EnergyUnit.use,
      'dryer_vented': EnergyUnit.use,
      'dryer_heatpump': EnergyUnit.use,
      'line_dry': EnergyUnit.use,
      'aircon_heating': EnergyUnit.hour,
      'portable_electric_heater': EnergyUnit.hour,
      'kotatsu': EnergyUnit.hour,
      'electric_blanket': EnergyUnit.hour,
      'aircon_cooling': EnergyUnit.hour,
      'fan': EnergyUnit.hour,
      'kettle': EnergyUnit.use,
      'ih_hob': EnergyUnit.use,
      'gas_hob': EnergyUnit.use,
      'oven': EnergyUnit.use,
      'microwave': EnergyUnit.minute,
      'rice_cooker': EnergyUnit.use,
      'rice_cook_keepwarm': EnergyUnit.use,
      'led_bulb': EnergyUnit.hour,
      'incandescent_bulb': EnergyUnit.hour,
      'tv': EnergyUnit.hour,
      'phone_charge': EnergyUnit.use,
      'laptop_charge': EnergyUnit.use,
      'standby': EnergyUnit.day,
    };
    expect(expected, hasLength(ENERGY_BEHAVIOR_COUNT));
    for (final b in behaviors) {
      expect(b.unit, expected[b.id], reason: b.id);
    }
  });

  test('presets are present, positive and uniquely identified', () {
    for (final b in behaviors) {
      expect(b.presets, isNotEmpty, reason: '${b.id} has no presets');
      expect(
        b.presets.map((p) => p.id).toSet(),
        hasLength(b.presets.length),
        reason: '${b.id} has duplicate preset ids',
      );
      for (final p in b.presets) {
        expect(p.units, greaterThan(0), reason: '${b.id}/${p.id}');
        expect(p.nameEn, isNotEmpty, reason: '${b.id}/${p.id} en');
        expect(p.nameJa, isNotEmpty, reason: '${b.id}/${p.id} ja');
        expect(p.nameEs, isNotEmpty, reason: '${b.id}/${p.id} es');
      }
    }
  });

  test('every default_preset_id resolves to one of its own presets', () {
    for (final b in behaviors) {
      expect(b.defaultPresetId, isNotEmpty, reason: b.id);
      expect(b.defaultPreset, isNotNull, reason: '${b.id} dangling default');
      expect(b.defaultPreset!.id, b.defaultPresetId);
    }
  });

  test('every behavior explains its arithmetic', () {
    for (final b in behaviors) {
      expect(b.calculationNotes, isNotEmpty, reason: b.id);
    }
  });

  test('every citation carries a name and a real URL', () {
    for (final b in behaviors) {
      for (final s in b.sources) {
        expect(s.name, isNotEmpty, reason: b.id);
        expect(s.url, startsWith('http'), reason: '${b.id}: ${s.name}');
        expect(s.accessed, isNotEmpty, reason: '${b.id}: ${s.name}');
      }
    }
  });

  test('the entries shipped without a citation are the known ones', () {
    // Each of these says why in its own calculation_notes:
    //  - line_dry is zero by definition;
    //  - microwave rests on an aggregator-sourced efficiency range;
    //  - laptop_charge, led_bulb and incandescent_bulb rest on
    //    manufacturer specs quoted verbatim in RESEARCH_ENERGY section
    //    3.5 whose URLs that pass never captured.
    // A sixth appearing here means an entry lost its sourcing. The two
    // lighting entries were added to this list on 2026-08-29 after a
    // review found they had been given citations borrowed from
    // data/seed/co2_actions_database.json with a rewritten access date;
    // shipping no citation is the honest state until the primary is
    // re-sourced.
    final unsourced = behaviors
        .where((b) => b.sources.isEmpty)
        .map((b) => b.id);
    expect(
      unsourced,
      unorderedEquals([
        'line_dry',
        'microwave',
        'led_bulb',
        'incandescent_bulb',
        'laptop_charge',
      ]),
    );
  });

  test('every citation carries an access date this project can support', () {
    // RESEARCH_ENERGY.md states 2026-08-02 for every source in its
    // sections 1 and 3. 2026-08-29 is the oven citation, re-fetched to
    // settle its regulation number; 2026-08-30 is the fan's Panasonic
    // spec, live-verified when the entry was added. Any other value
    // means a citation was imported from another dataset or invented --
    // which is how the two lighting entries went wrong.
    const allowed = {'2026-08-02', '2026-08-29', '2026-08-30'};
    for (final b in behaviors) {
      for (final s in b.sources) {
        expect(allowed, contains(s.accessed), reason: '${b.id}: ${s.name}');
      }
    }
    final oven = behaviors.firstWhere((b) => b.id == 'oven');
    expect(oven.sources.single.accessed, '2026-08-29');
    expect(oven.sources.single.name, contains('66/2014'));
  });

  test('confidence is one of the four documented levels', () {
    const levels = {'high', 'medium_high', 'medium', 'low'};
    for (final b in behaviors) {
      expect(levels, contains(b.confidence), reason: b.id);
    }
  });

  test('metadata carries both carrier factors and the scope statement', () {
    final metadata = root['metadata'] as Map<String, dynamic>;
    expect(metadata['grid_factor_g_per_kwh'], 458);
    expect(metadata['gas_factor_g_per_kwh'], 182);
    expect(metadata['verdict_min_percent'], 20);
    expect(metadata['scope'], isNotEmpty);
    // The cross-calculator warning is binding copy, not decoration.
    expect(metadata['scope'], contains('NEVER sum'));
    // No points, ever, in v1.
    expect(metadata['awards_note'], contains('awards no points'));
  });

  test('CROSS-DATASET: the grid factor matches transport_modes.json', () {
    // RESEARCH_ENERGY.md section 6 pin 12. One factor, one meaning:
    // the two datasets must never disagree about the same user's grid.
    final transport = rawDatasetRoot('data/app/transport_modes.json');
    final transportMetadata = transport['metadata'] as Map<String, dynamic>;
    final energyMetadata = root['metadata'] as Map<String, dynamic>;
    expect(
      energyMetadata['grid_factor_g_per_kwh'],
      transportMetadata['grid_factor_g_per_kwh'],
    );
  });
}
