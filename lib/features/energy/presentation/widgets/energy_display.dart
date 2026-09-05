import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';

/// Icon for a comparable group (dataset `comparable_group` values).
IconData energyGroupIcon(String group) => switch (group) {
  'hot_water' => Icons.shower,
  'dishes' => Icons.local_dining,
  'laundry_wash' => Icons.local_laundry_service,
  'laundry_dry' => Icons.dry_cleaning,
  'space_heat' => Icons.local_fire_department,
  'space_cool' => Icons.ac_unit,
  'boil' => Icons.water_drop,
  'cook' => Icons.microwave,
  'lighting' => Icons.lightbulb_outline,
  'device' => Icons.devices,
  _ => Icons.bolt,
};

/// Localized label for a comparable group. Unknown groups fall back to
/// the raw id so a dataset addition degrades readably.
String energyGroupLabel(AppLocalizations l10n, String group) => switch (group) {
  'hot_water' => l10n.energyGroupHotWater,
  'dishes' => l10n.energyGroupDishes,
  'laundry_wash' => l10n.energyGroupLaundryWash,
  'laundry_dry' => l10n.energyGroupLaundryDry,
  'space_heat' => l10n.energyGroupSpaceHeat,
  'space_cool' => l10n.energyGroupSpaceCool,
  'boil' => l10n.energyGroupBoil,
  'cook' => l10n.energyGroupCook,
  'lighting' => l10n.energyGroupLighting,
  'device' => l10n.energyGroupDevice,
  _ => group,
};

/// Chip label for an explore baseline, e.g. "LED hour". Unknown ids
/// fall back to the raw id, like [energyGroupLabel].
String energyAnchorChipLabel(AppLocalizations l10n, String id) => switch (id) {
  'led_bulb' => l10n.energyAnchorChipLedBulb,
  'phone_charge' => l10n.energyAnchorChipPhoneCharge,
  'kettle' => l10n.energyAnchorChipKettle,
  'fan' => l10n.energyAnchorChipFan,
  _ => id,
};

/// The same baseline as a phrase that reads inside a sentence, e.g.
/// "an hour of LED light".
String energyAnchorUnitPhrase(AppLocalizations l10n, String id) => switch (id) {
  'led_bulb' => l10n.energyAnchorUnitLedBulb,
  'phone_charge' => l10n.energyAnchorUnitPhoneCharge,
  'kettle' => l10n.energyAnchorUnitKettle,
  'fan' => l10n.energyAnchorUnitFan,
  _ => id,
};

/// Bare unit noun for a text-field suffix, e.g. "min".
String energyUnitSuffix(AppLocalizations l10n, EnergyUnit unit) =>
    switch (unit) {
      EnergyUnit.minute => l10n.energyUnitSuffixMinute,
      EnergyUnit.hour => l10n.energyUnitSuffixHour,
      EnergyUnit.use => l10n.energyUnitSuffixUse,
      EnergyUnit.day => l10n.energyUnitSuffixDay,
    };

/// The quantity line on an entry card, e.g. "10 minutes".
///
/// One key per unit rather than a shared "{units} {unit}" pattern: an
/// English plural does not survive being pasted after a number in
/// Japanese, and "0.248 kWh per minutes" is what the generic version
/// produces.
String energyUsageDetailLabel(
  AppLocalizations l10n,
  EnergyBehavior behavior,
  double units,
) {
  final text = _unitsText(units);
  // The units text is pre-formatted, so ICU plurals cannot see the
  // number; exactly-one gets its own key ("1 hour", not "1 hours").
  final one = units == 1;
  return switch (behavior.unit) {
    EnergyUnit.minute =>
      one ? l10n.energyQuantityOneMinute : l10n.energyQuantityMinutes(text),
    EnergyUnit.hour =>
      one ? l10n.energyQuantityOneHour : l10n.energyQuantityHours(text),
    EnergyUnit.use => l10n.energyQuantityUses(text),
    EnergyUnit.day =>
      one ? l10n.energyQuantityOneDay : l10n.energyQuantityDays(text),
  };
}

/// Consumption line for a picker row: kWh per the behavior's own unit.
///
/// The carrier is named in the behavior's own name ("Shower (gas
/// water)"), always, because the electric-versus-gas answer flips with
/// the user's grid and a row that hid its carrier would be quietly
/// wrong for half the world (PDR section 5, rule 3).
String energyBehaviorFactorLabel(
  AppLocalizations l10n,
  EnergyBehavior behavior,
) {
  final text = _kwhText(behavior.kwhPerUnit);
  return switch (behavior.unit) {
    EnergyUnit.minute => l10n.energyFactorPerMinute(text),
    EnergyUnit.hour => l10n.energyFactorPerHour(text),
    EnergyUnit.use => l10n.energyFactorPerUse(text),
    EnergyUnit.day => l10n.energyFactorPerDay(text),
  };
}

/// Four decimals below 0.01, three below 1, two above, then trailing
/// zeros stripped -- enough for a subtitle without false exactness.
///
/// The stripping matters: 0.8 kWh formatted to three decimals reads
/// "0.800", which claims a precision the standby figure emphatically
/// does not have. The dataset stores the unrounded value; only display
/// rounds.
String _kwhText(double kwh) {
  if (kwh == 0) return '0';
  final digits = kwh < 0.01
      ? 4
      : kwh < 1
      ? 3
      : 2;
  final text = kwh.toStringAsFixed(digits);
  if (!text.contains('.')) return text;
  return text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
}

/// Drops a trailing ".0" so "10 minutes" does not read "10.0 minutes",
/// but keeps a real fraction (the setpoint presets are 1.35783).
String _unitsText(double units) => units == units.roundToDouble()
    ? units.round().toString()
    : units.toStringAsFixed(2);

/// The E7 multiple, locale-aware: one decimal below 10x ("2.3"),
/// whole numbers above ("373") where a decimal would be false
/// precision.
String formatEnergyMultiple(String locale, double ratio) =>
    NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: ratio >= 10 ? 0 : 1,
    ).format(ratio);

/// Title block the behavior sheets share: the name over its factor.
Widget energyBehaviorSheetHeader(
  BuildContext context,
  AppLocalizations l10n,
  EnergyBehavior behavior,
) {
  final theme = Theme.of(context);
  final locale = Localizations.localeOf(context).languageCode;
  return Column(
    children: [
      Text(
        behavior.name(locale),
        textAlign: TextAlign.center,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: spacingXs),
      Text(
        energyBehaviorFactorLabel(l10n, behavior),
        textAlign: TextAlign.center,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ],
  );
}
