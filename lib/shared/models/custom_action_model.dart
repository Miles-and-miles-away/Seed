import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/features/actions/data/models/action_model.dart';

part 'custom_action_model.freezed.dart';
part 'custom_action_model.g.dart';

/// A user-created action banked from a calculator comparison (Phase 8:
/// transport 8.6, food 8.12). Stored under `users/{uid}/customActions/{id}`.
///
/// Unlike library actions its CO2 (the avoided emissions) and points are
/// client-computed, so logging it needs the relaxed Firestore rule branch
/// that validates a log against this template rather than the read-only
/// action library. The rule is category-agnostic, so every calculator
/// reuses the same collection; [category] and [relatedSdgs] are supplied
/// by the calculator that banks the choice.
@freezed
abstract class CustomAction with _$CustomAction {
  const factory CustomAction({
    required String id,
    required String name,
    required int co2Grams,
    required int points,
    required String category,
    required List<String> relatedSdgs,
  }) = _CustomAction;

  const CustomAction._();

  factory CustomAction.fromJson(Map<String, dynamic> json) =>
      _$CustomActionFromJson(json);

  /// Adapts this template to an [ActionModel] so it flows through the
  /// existing action-logging transaction unchanged. The name is a single
  /// user-facing string, so every locale field carries it.
  ActionModel toActionModel() => ActionModel(
    id: id,
    nameEn: name,
    nameJa: name,
    nameEs: name,
    category: category,
    points: points,
    co2Grams: co2Grams,
    relatedSdgs: relatedSdgs,
  );
}
