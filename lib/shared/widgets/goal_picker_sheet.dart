import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';

/// Preset personal goal IDs, ordered from concrete to aspirational.
///
/// Presets are stored in Firestore as stable IDs so their display text
/// follows the user's language; custom goals are stored as free text.
const personalGoalPresetIds = [
  'reduce_flights',
  'plant_based',
  'less_plastic',
  'walk_bike',
  'less_food_waste',
  'buy_less',
  'inspire_others',
  'save_world',
];

/// Resolves a stored goal value (preset ID or free text) for display.
String localizedPersonalGoal(String goal, AppLocalizations l10n) {
  switch (goal) {
    case 'reduce_flights':
      return l10n.personalGoalReduceFlights;
    case 'plant_based':
      return l10n.personalGoalPlantBased;
    case 'less_plastic':
      return l10n.personalGoalLessPlastic;
    case 'walk_bike':
      return l10n.personalGoalWalkBike;
    case 'less_food_waste':
      return l10n.personalGoalLessFoodWaste;
    case 'buy_less':
      return l10n.personalGoalBuyLess;
    case 'inspire_others':
      return l10n.personalGoalInspireOthers;
    case 'save_world':
      return l10n.personalGoalSaveWorld;
    default:
      return goal;
  }
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
      ),
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
    if (personalGoalPresetIds.contains(goal)) {
      _selected = goal;
    } else {
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
    final value =
        _selected == _customOption ? _customController.text.trim() : _selected;
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacingXxl,
                  ),
                  child: TextField(
                    controller: _customController,
                    autofocus: true,
                    maxLength: AppConstants.maxPersonalGoalLength,
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
