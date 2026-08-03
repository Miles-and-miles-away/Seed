import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/transport/data/models/journey_leg_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/domain/services/transport_calculator.dart';
import 'package:seed_app/features/transport/presentation/widgets/transport_display.dart';

const _smallCar = TransportMode(
  id: 'car_small',
  group: 'car',
  nameEn: 'Small petrol car',
  nameJa: '',
  nameEs: '',
  gCo2ePerKm: 143,
  perVehicle: true,
  maxOccupants: 5,
);
const _coach = TransportMode(
  id: 'coach',
  group: 'bus',
  nameEn: 'Coach',
  nameJa: '',
  nameEs: '',
  gCo2ePerKm: 27,
);
const _walk = TransportMode(
  id: 'walk',
  group: 'active',
  nameEn: 'Walking',
  nameJa: '',
  nameEs: '',
  gCo2ePerKm: 0,
);

final _modesById = TransportCalculator.byId(const [_smallCar, _coach, _walk]);

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('journeyOptionLabel', () {
    // The plan's headline comparison is drive alone vs carpool vs
    // coach. Labelling by group made the first two identical
    // ("Car & motorbike"), which broke the option pickers, the delta
    // copy, and the banked action name.
    test('tells drive-alone and carpool apart', () {
      const alone = [JourneyLeg(modeId: 'car_small', distanceKm: 100)];
      const carpool = [
        JourneyLeg(modeId: 'car_small', distanceKm: 100, occupants: 4),
      ];

      final aloneLabel = journeyOptionLabel(l10n, alone, _modesById, 'en');
      final carpoolLabel = journeyOptionLabel(l10n, carpool, _modesById, 'en');

      expect(aloneLabel, 'Small petrol car');
      expect(carpoolLabel, 'Small petrol car · 4 people');
      expect(aloneLabel, isNot(carpoolLabel));
    });

    test('omits occupancy for per-passenger modes', () {
      const legs = [JourneyLeg(modeId: 'coach', distanceKm: 100)];
      expect(journeyOptionLabel(l10n, legs, _modesById, 'en'), 'Coach');
    });

    test('names the longest leg of a multi-leg journey', () {
      const legs = [
        JourneyLeg(modeId: 'walk', distanceKm: 2),
        JourneyLeg(modeId: 'coach', distanceKm: 300),
      ];
      expect(journeyOptionLabel(l10n, legs, _modesById, 'en'), 'Coach');
    });

    test('yields an empty label for an empty journey', () {
      expect(journeyOptionLabel(l10n, const [], _modesById, 'en'), '');
    });

    test('yields an empty label when the mode is unknown', () {
      const legs = [JourneyLeg(modeId: 'nope', distanceKm: 10)];
      expect(journeyOptionLabel(l10n, legs, _modesById, 'en'), '');
    });
  });
  group('journeySummaryLabel', () {
    // The on-screen summary says "Option A"; this label is what the
    // banked action carries into the action history, where there are
    // no columns to give it meaning.
    test('joins every distinct mode in order', () {
      const legs = [
        JourneyLeg(modeId: 'walk', distanceKm: 2),
        JourneyLeg(modeId: 'coach', distanceKm: 300),
      ];
      expect(
        journeySummaryLabel(l10n, legs, _modesById, 'en'),
        'Walking + Coach',
      );
    });

    test('keeps occupancy so carpool differs from driving alone', () {
      const alone = [JourneyLeg(modeId: 'car_small', distanceKm: 100)];
      const carpool = [
        JourneyLeg(modeId: 'car_small', distanceKm: 100, occupants: 4),
      ];
      expect(
        journeySummaryLabel(l10n, alone, _modesById, 'en'),
        'Small petrol car',
      );
      expect(
        journeySummaryLabel(l10n, carpool, _modesById, 'en'),
        'Small petrol car \u00b7 4 people',
      );
    });

    test('collapses a repeated mode to one entry', () {
      const legs = [
        JourneyLeg(modeId: 'coach', distanceKm: 100),
        JourneyLeg(modeId: 'coach', distanceKm: 40),
      ];
      expect(journeySummaryLabel(l10n, legs, _modesById, 'en'), 'Coach');
    });

    test('yields an empty label for an empty journey', () {
      expect(journeySummaryLabel(l10n, const [], _modesById, 'en'), '');
    });
  });
}
