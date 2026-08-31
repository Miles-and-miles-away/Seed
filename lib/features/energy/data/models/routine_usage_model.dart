import 'package:freezed_annotation/freezed_annotation.dart';

part 'routine_usage_model.freezed.dart';

/// One entry of a routine: an energy behavior in a quantity of its own
/// unit (minutes, hours, uses, days). Ephemeral screen state, never
/// persisted -- the calculator banks nothing.
@freezed
abstract class RoutineUsage with _$RoutineUsage {
  const factory RoutineUsage({
    required String behaviorId,
    required double units,
  }) = _RoutineUsage;
}
