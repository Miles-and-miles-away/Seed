import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/energy/data/energy_behaviors_data.dart';

import '../../../helpers/dataset_helpers.dart';

/// Exact-value pins for every shipped figure (Phase 8.13).
///
/// The ordering pins in energy_dataset_invariants_test.dart have slack
/// by design -- they encode the relationships the research doc states,
/// and most of them survive a large error in any single factor. A
/// mutation pass over the dataset found 25 of the 33 factors could be
/// changed by any amount with the suite still green, including
/// `shower_electric` (the largest driver in the dataset) surviving the
/// +27% regression that reinstating the retired 10 C delta-T would
/// cause, and `microwave` surviving a 10x error.
///
/// So every value is pinned exactly here. This file is deliberately
/// dumb: it is a copy of the dataset, and its whole job is to make any
/// change to a researched number a deliberate two-file edit rather than
/// a silent one. When a value legitimately moves, re-derive it from
/// RESEARCH_ENERGY.md and change it in both places.
void main() {
  late Map<String, Map<String, dynamic>> byId;

  setUpAll(() {
    byId = rawDatasetById('data/app/energy_behaviors.json', 'behaviors');
  });

  test('every kwh_per_unit ships exactly', () {
    const expected = <String, double>{
      'shower_electric': 0.248111,
      'shower_heatpump': 0.0577,
      'shower_gas': 0.328036,
      'bath_electric': 5.69296,
      'bath_gas': 7.526854,
      'dishwasher_eco': 0.85,
      'dishwasher_normal': 1.12,
      'wash_cold': 0.35,
      'wash_warm': 1.3,
      'wash_hot': 1.7,
      'dryer_vented': 4.5, // not the model-specific 4.63
      'dryer_heatpump': 2.05,
      'line_dry': 0,
      'aircon_heating': 0.241006, // METI measured, not the JIS rated 0.455
      'portable_electric_heater': 1.2, // not 1.5
      'kotatsu': 0.15, // not the 0.3-0.6 nameplate
      'electric_blanket': 0.025,
      'aircon_cooling': 0.167679, // METI measured, not the JIS rated 0.435
      'fan': 0.022, // Panasonic F-CV339 highest notch, the action's basis
      'kettle': 0.116278,
      'ih_hob': 0.116598,
      'gas_hob': 0.282389, // efficiency 0.35, not 0.32 or 0.42
      'oven': 0.82, // EU 60-70 L midpoint, not 1.0/hour or 2.0
      'microwave': 0.019,
      'rice_cooker': 0.16,
      'rice_cook_keepwarm': 0.226,
      'led_bulb': 0.0085,
      'incandescent_bulb': 0.06,
      'tv': 0.079096,
      'phone_charge': 0.015271,
      'laptop_charge': 0.063294,
      'standby': 0.8, // not 1.78
    };
    expect(expected, hasLength(ENERGY_BEHAVIOR_COUNT));
    expect(byId.keys.toSet(), expected.keys.toSet());
    for (final entry in expected.entries) {
      expect(
        (byId[entry.key]!['kwh_per_unit'] as num).toDouble(),
        entry.value,
        reason: entry.key,
      );
    }
  });

  test('every comparable_group ships exactly', () {
    // The distribution count alone let any swap between two same-size
    // groups pass -- moving `gas_hob` to cook and `microwave` to boil
    // went undetected.
    const expected = <String, String>{
      'shower_electric': 'hot_water',
      'shower_heatpump': 'hot_water',
      'shower_gas': 'hot_water',
      'bath_electric': 'hot_water',
      'bath_gas': 'hot_water',
      'dishwasher_eco': 'dishes',
      'dishwasher_normal': 'dishes',
      'wash_cold': 'laundry_wash',
      'wash_warm': 'laundry_wash',
      'wash_hot': 'laundry_wash',
      'dryer_vented': 'laundry_dry',
      'dryer_heatpump': 'laundry_dry',
      'line_dry': 'laundry_dry',
      'aircon_heating': 'space_heat',
      'portable_electric_heater': 'space_heat',
      'kotatsu': 'space_heat',
      'electric_blanket': 'space_heat',
      'aircon_cooling': 'space_cool',
      'fan': 'space_cool',
      'kettle': 'boil',
      'ih_hob': 'boil',
      'gas_hob': 'boil',
      'oven': 'cook',
      'microwave': 'cook',
      'rice_cooker': 'cook',
      'rice_cook_keepwarm': 'cook',
      'led_bulb': 'lighting',
      'incandescent_bulb': 'lighting',
      'tv': 'device',
      'phone_charge': 'device',
      'laptop_charge': 'device',
      'standby': 'device',
    };
    expect(expected, hasLength(ENERGY_BEHAVIOR_COUNT));
    for (final entry in expected.entries) {
      expect(
        byId[entry.key]!['comparable_group'],
        entry.value,
        reason: entry.key,
      );
    }
  });

  test('every carrier ships exactly', () {
    const expected = <String, String>{
      'shower_electric': 'electricity',
      'shower_heatpump': 'electricity',
      'shower_gas': 'gas',
      'bath_electric': 'electricity',
      'bath_gas': 'gas',
      'dishwasher_eco': 'electricity',
      'dishwasher_normal': 'electricity',
      'wash_cold': 'electricity',
      'wash_warm': 'electricity',
      'wash_hot': 'electricity',
      'dryer_vented': 'electricity',
      'dryer_heatpump': 'electricity',
      'line_dry': 'none',
      'aircon_heating': 'electricity',
      'portable_electric_heater': 'electricity',
      'kotatsu': 'electricity',
      'electric_blanket': 'electricity',
      'aircon_cooling': 'electricity',
      'fan': 'electricity',
      'kettle': 'electricity',
      'ih_hob': 'electricity',
      'gas_hob': 'gas',
      'oven': 'electricity',
      'microwave': 'electricity',
      'rice_cooker': 'electricity',
      'rice_cook_keepwarm': 'electricity',
      'led_bulb': 'electricity',
      'incandescent_bulb': 'electricity',
      'tv': 'electricity',
      'phone_charge': 'electricity',
      'laptop_charge': 'electricity',
      'standby': 'electricity',
    };
    expect(expected, hasLength(ENERGY_BEHAVIOR_COUNT));
    for (final entry in expected.entries) {
      expect(byId[entry.key]!['carrier'], entry.value, reason: entry.key);
    }
  });

  test('every preset quantity ships exactly', () {
    // The aircon setpoint presets are the transposition risk the
    // research flags: 1.17891 and 1.35783 swapped went undetected, as
    // did the evening preset drifting off 4 x the hourly figure.
    const expected = <String, double>{
      'shower_electric/quick_5min': 5,
      'shower_electric/typical_10min': 10,
      'shower_electric/long_20min': 20,
      'shower_heatpump/quick_5min': 5,
      'shower_heatpump/typical_10min': 10,
      'shower_heatpump/long_20min': 20,
      'shower_gas/quick_5min': 5,
      'shower_gas/typical_10min': 10,
      'shower_gas/long_20min': 20,
      'bath_electric/full_180l': 1.0,
      'bath_electric/shallow_150l': 0.83,
      'bath_gas/full_180l': 1.0,
      'bath_gas/shallow_150l': 0.83,
      'dishwasher_eco/one_cycle': 1,
      'dishwasher_normal/one_cycle': 1,
      'wash_cold/one_load': 1,
      'wash_warm/one_load': 1,
      'wash_hot/one_load': 1,
      'dryer_vented/one_load': 1,
      'dryer_heatpump/one_load': 1,
      'line_dry/one_load': 1,
      'aircon_heating/hour_20c': 1.0,
      'aircon_heating/hour_21c': 1.1448,
      'aircon_heating/hour_22c': 1.2896,
      'portable_electric_heater/evening_4h': 4,
      'kotatsu/evening_4h': 4,
      'electric_blanket/evening_4h': 4,
      'aircon_cooling/hour_28c': 1.0,
      'aircon_cooling/hour_27c': 1.17891,
      'aircon_cooling/hour_26c': 1.35783,
      'aircon_cooling/evening_26c': 5.43132,
      'fan/one_hour': 1.0,
      'fan/evening_4h': 4.0,
      'kettle/one_litre': 1,
      'kettle/one_mug': 0.3,
      'ih_hob/one_litre': 1,
      'ih_hob/one_mug': 0.3,
      'gas_hob/one_litre': 1,
      'gas_hob/one_mug': 0.3,
      'oven/one_bake': 1,
      'oven/two_bakes': 2,
      'microwave/two_min': 2,
      'microwave/ten_min': 10,
      'rice_cooker/one_cycle': 1,
      'rice_cook_keepwarm/cycle_plus_four': 1,
      'led_bulb/one_hour': 1,
      'led_bulb/evening_5h': 5,
      'incandescent_bulb/one_hour': 1,
      'incandescent_bulb/evening_5h': 5,
      'tv/one_hour': 1,
      'tv/evening_3h': 3,
      'phone_charge/one_charge': 1,
      'laptop_charge/one_charge': 1,
      'standby/one_day': 1,
    };
    final actual = <String, double>{};
    for (final b in byId.values) {
      for (final p in datasetEntries(b, 'presets')) {
        actual['${b['id']}/${p['id']}'] = (p['units'] as num).toDouble();
      }
    }
    expect(actual, expected);
  });

  test('the aircon evening preset stays four times its hourly figure', () {
    // Not a copy of the data: a relationship the copy cannot express,
    // and the one the research derives it from.
    final presets = {
      for (final p in datasetEntries(byId['aircon_cooling']!, 'presets'))
        p['id'] as String: (p['units'] as num).toDouble(),
    };
    expect(presets['evening_26c'], closeTo(4 * presets['hour_26c']!, 1e-9));
  });

  test('every confidence string ships exactly', () {
    // Read raw, not through the model: `confidence` defaults to
    // 'medium', so a typo'd key silently became medium and passed the
    // four-level membership check.
    const expected = <String, String>{
      'shower_electric': 'medium_high',
      'shower_heatpump': 'medium',
      'shower_gas': 'medium_high',
      'bath_electric': 'high',
      'bath_gas': 'medium_high',
      'dishwasher_eco': 'high',
      'dishwasher_normal': 'high',
      'wash_cold': 'high',
      'wash_warm': 'high',
      'wash_hot': 'medium',
      'dryer_vented': 'high',
      'dryer_heatpump': 'high',
      'line_dry': 'high',
      'aircon_heating': 'high',
      'portable_electric_heater': 'medium',
      'kotatsu': 'medium_high',
      'electric_blanket': 'medium',
      'aircon_cooling': 'high',
      'fan': 'medium',
      'kettle': 'medium_high',
      'ih_hob': 'medium_high',
      'gas_hob': 'medium',
      'oven': 'medium',
      'microwave': 'medium',
      'rice_cooker': 'high',
      'rice_cook_keepwarm': 'high',
      'led_bulb': 'high',
      'incandescent_bulb': 'high',
      'tv': 'high',
      'phone_charge': 'medium',
      'laptop_charge': 'medium',
      'standby': 'low',
    };
    expect(expected, hasLength(ENERGY_BEHAVIOR_COUNT));
    for (final entry in expected.entries) {
      expect(byId[entry.key]!['confidence'], entry.value, reason: entry.key);
    }
  });
}
