import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/decimal_input.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/presentation/widgets/energy_display.dart';

/// Quantity editor for one routine entry (Phase 8.14).
///
/// Presets fill an editable amount field, exactly like a food serving
/// fills grams. Every behavior ships at least one preset, so the field
/// always opens with a sensible value rather than empty.
class UsageEditorSheet extends StatefulWidget {
  const UsageEditorSheet({
    required this.behavior,
    this.initialUnits,
    super.key,
  });

  final EnergyBehavior behavior;

  /// Set when editing an existing entry rather than adding one.
  final double? initialUnits;

  /// Shows the sheet and returns the chosen quantity, or null if
  /// dismissed.
  static Future<double?> show(
    BuildContext context, {
    required EnergyBehavior behavior,
    double? initialUnits,
  }) => showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: UsageEditorSheet(behavior: behavior, initialUnits: initialUnits),
    ),
  );

  @override
  State<UsageEditorSheet> createState() => _UsageEditorSheetState();
}

class _UsageEditorSheetState extends State<UsageEditorSheet> {
  late final TextEditingController _controller;
  String? _selectedPresetId;
  bool _invalid = false;

  @override
  void initState() {
    super.initState();
    final initial =
        widget.initialUnits ?? widget.behavior.defaultPreset?.units ?? 1;
    _controller = TextEditingController(text: decimalSeedText(initial));
    _selectedPresetId = _presetIdFor(initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The preset matching [units] exactly, so reopening the editor shows
  /// the chip the user originally chose still selected.
  String? _presetIdFor(double units) {
    for (final preset in widget.behavior.presets) {
      if (preset.units == units) return preset.id;
    }
    return null;
  }

  void _applyPreset(String id, double units) {
    setState(() {
      _selectedPresetId = id;
      _invalid = false;
      _controller.text = decimalSeedText(units);
    });
  }

  void _submit() {
    final units = parseDecimalInput(_controller.text);
    if (units == null || units <= 0) {
      setState(() => _invalid = true);
      return;
    }
    Navigator.pop(context, units);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          spacingXxl,
          spacingSm,
          spacingXxl,
          spacingXxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.behavior.name(locale),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: spacingXs),
            Text(
              energyBehaviorFactorLabel(l10n, widget.behavior),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: spacingLg),
            if (widget.behavior.presets.isNotEmpty) ...[
              Text(l10n.energyPresetsLabel, style: theme.textTheme.titleSmall),
              const SizedBox(height: spacingSm),
              Wrap(
                spacing: spacingSm,
                runSpacing: spacingSm,
                children: [
                  for (final preset in widget.behavior.presets)
                    ChoiceChip(
                      label: Text(preset.name(locale)),
                      selected: _selectedPresetId == preset.id,
                      onSelected: (_) => _applyPreset(preset.id, preset.units),
                    ),
                ],
              ),
              const SizedBox(height: spacingLg),
            ],
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [decimalInputFormatter],
              decoration: InputDecoration(
                labelText: l10n.energyQuantityLabel,
                suffixText: energyUnitSuffix(l10n, widget.behavior.unit),
                border: const OutlineInputBorder(),
                errorText: _invalid ? l10n.energyQuantityInvalid : null,
              ),
              // Typing a raw amount means the user is no longer on a
              // preset, so the chip stops claiming to describe it.
              onChanged: (value) => setState(() {
                _invalid = false;
                _selectedPresetId = _presetIdFor(
                  parseDecimalInput(value) ?? -1,
                );
              }),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: spacingLg),
            FilledButton(onPressed: _submit, child: Text(l10n.energyAddUsage)),
          ],
        ),
      ),
    );
  }
}
