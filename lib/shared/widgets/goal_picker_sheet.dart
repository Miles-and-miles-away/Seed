import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/utf16_length_limiting_text_input_formatter.dart';

/// Preset personal goals keyed by stored ID, ordered from concrete to
/// aspirational.
///
/// Presets are stored in Firestore as stable IDs so their display text
/// follows the user's language; custom goals are stored as free text.
final _personalGoalPresets = <String, String Function(AppLocalizations)>{
  'reduce_flights': (l10n) => l10n.personalGoalReduceFlights,
  'plant_based': (l10n) => l10n.personalGoalPlantBased,
  'less_plastic': (l10n) => l10n.personalGoalLessPlastic,
  'walk_bike': (l10n) => l10n.personalGoalWalkBike,
  'less_food_waste': (l10n) => l10n.personalGoalLessFoodWaste,
  'buy_less': (l10n) => l10n.personalGoalBuyLess,
  'inspire_others': (l10n) => l10n.personalGoalInspireOthers,
  'save_world': (l10n) => l10n.personalGoalSaveWorld,
};

/// Preset personal goal IDs in display order.
final personalGoalPresetIds = _personalGoalPresets.keys;

/// Stored prefix marking a goal as free-text custom input. Namespacing custom
/// goals keeps one that happens to equal a preset ID (e.g. "save_world") from
/// resolving to the preset's localized label -- it round-trips as the literal
/// text the user typed instead.
const personalGoalCustomPrefix = 'custom:';

/// Max length of the free-text portion of a custom goal. The stored value is
/// [personalGoalCustomPrefix] + this text, so the cap reserves room for the
/// prefix within [AppConstants.maxPersonalGoalLength] (the size limit the
/// Firestore rule enforces on the stored string).
final maxCustomGoalTextLength =
    AppConstants.maxPersonalGoalLength - personalGoalCustomPrefix.length;

/// Resolves a stored goal value (preset ID or custom text) for display.
String localizedPersonalGoal(String goal, AppLocalizations l10n) {
  if (goal.startsWith(personalGoalCustomPrefix)) {
    return goal.substring(personalGoalCustomPrefix.length);
  }
  // A bare non-preset value is a legacy custom goal saved before the prefix.
  return _personalGoalPresets[goal]?.call(l10n) ?? goal;
}

/// Bottom sheet for choosing a personal sustainability goal.
///
/// Offers the preset goals plus a free-text option. Pops with the
/// chosen preset ID or trimmed custom text, or null when dismissed.
class GoalPickerSheet extends StatefulWidget {
  const GoalPickerSheet({this.initialGoal, super.key});

  /// The currently stored goal, used to preselect an option.
  final String? initialGoal;

  /// Shows the sheet modally. Mirrors the [showModalBottomSheet]
  /// conventions used elsewhere in the app (drag handle, rounded
  /// top corners).
  static Future<String?> show(BuildContext context, {String? initialGoal}) {
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: sheetShape,
      builder: (_) => GoalPickerSheet(initialGoal: initialGoal),
    );
  }

  @override
  State<GoalPickerSheet> createState() => _GoalPickerSheetState();
}

class _GoalPickerSheetState extends State<GoalPickerSheet> {
  /// Sentinel selection value for the free-text option.
  static const _customOption = '_custom';

  final _customController = TextEditingController();
  String? _selected;

  @override
  void initState() {
    super.initState();
    final goal = widget.initialGoal;
    if (goal == null) return;
    if (goal.startsWith(personalGoalCustomPrefix)) {
      _selected = _customOption;
      _customController.text = goal.substring(personalGoalCustomPrefix.length);
    } else if (personalGoalPresetIds.contains(goal)) {
      _selected = goal;
    } else {
      // Legacy custom goal stored before the prefix scheme.
      _selected = _customOption;
      _customController.text = goal;
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _selected != null &&
      (_selected != _customOption || _customController.text.trim().isNotEmpty);

  void _save() {
    final value = _selected == _customOption
        ? '$personalGoalCustomPrefix${_customController.text.trim()}'
        : _selected;
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.goalPickerTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: spacingSm),
              for (final id in personalGoalPresetIds)
                _buildOption(id, localizedPersonalGoal(id, l10n)),
              _buildOption(_customOption, l10n.goalPickerCustomOption),
              if (_selected == _customOption)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: spacingXxl),
                  child: TextField(
                    controller: _customController,
                    autofocus: true,
                    maxLength: maxCustomGoalTextLength,
                    // Cap on UTF-16 units to match the Firestore rule's
                    // .size(); the stored value prepends
                    // personalGoalCustomPrefix, so the text cap reserves room
                    // for it under the limit.
                    inputFormatters: [
                      Utf16LengthLimitingTextInputFormatter(
                        maxCustomGoalTextLength,
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: l10n.goalPickerCustomHint,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  spacingXxl,
                  spacingLg,
                  spacingXxl,
                  spacingLg,
                ),
                child: FilledButton(
                  onPressed: _canSave ? _save : null,
                  child: Text(l10n.buttonSave),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String value, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = _selected == value;

    return ListTile(
      title: Text(label),
      selected: selected,
      trailing: Icon(
        selected ? Icons.check_circle : Icons.circle_outlined,
        color: selected ? colorScheme.primary : colorScheme.outline,
      ),
      onTap: () => setState(() => _selected = value),
    );
  }
}
