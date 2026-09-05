import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/data/models/usage_preset_model.dart';
import 'package:seed_app/shared/models/emission_source_model.dart';

/// The single preset every fixture behavior ships with.
const oneUse = UsagePreset(
  id: 'one',
  nameEn: '1 use',
  nameJa: '',
  nameEs: '',
  units: 1,
);

/// A minimal behavior named after its id, with [oneUse] as its default.
EnergyBehavior behavior(
  String id,
  String group,
  EnergyCarrier carrier,
  double kwh, {
  EnergyUnit unit = EnergyUnit.use,
  List<EmissionSource> sources = const [],
}) => EnergyBehavior(
  id: id,
  comparableGroup: group,
  carrier: carrier,
  unit: unit,
  kwhPerUnit: kwh,
  nameEn: id,
  nameJa: '',
  nameEs: '',
  presets: const [oneUse],
  defaultPresetId: 'one',
  sources: sources,
);
