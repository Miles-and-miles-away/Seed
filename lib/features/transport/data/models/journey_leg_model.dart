import 'package:freezed_annotation/freezed_annotation.dart';

part 'journey_leg_model.freezed.dart';

/// One leg of a journey: a transport mode over a distance.
///
/// [occupants] only matters for per-vehicle modes and is clamped
/// to the mode's allowed range at calculation time. Legs are
/// ephemeral screen state and are never persisted.
@freezed
abstract class JourneyLeg with _$JourneyLeg {
  const factory JourneyLeg({
    required String modeId,
    required double distanceKm,
    @Default(1) int occupants,
  }) = _JourneyLeg;
}
