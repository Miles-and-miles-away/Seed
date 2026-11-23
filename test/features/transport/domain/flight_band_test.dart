import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/transport/domain/services/flight_band.dart';

void main() {
  group('flightBandModeId', () {
    test('beyond 3,700 km is long-haul regardless of country', () {
      expect(
        flightBandModeId(straightLineKm: 4000, fromCc: 'JP', toCc: 'JP'),
        flightModeLongHaul,
      );
      expect(
        flightBandModeId(straightLineKm: 9000, fromCc: 'GB', toCc: 'US'),
        flightModeLongHaul,
      );
    });

    test('a UK leg under the boundary is domestic', () {
      expect(
        flightBandModeId(straightLineKm: 400, fromCc: 'GB', toCc: 'GB'),
        flightModeDomestic,
      );
      expect(
        flightBandModeId(straightLineKm: 300, fromCc: 'GB', toCc: 'JE'),
        flightModeDomestic,
      );
    });

    test('a same-country leg outside the UK is short-haul', () {
      expect(
        flightBandModeId(straightLineKm: 832, fromCc: 'JP', toCc: 'JP'),
        flightModeShortHaul,
      );
    });

    test('different country under the boundary is short-haul', () {
      expect(
        flightBandModeId(straightLineKm: 400, fromCc: 'GB', toCc: 'FR'),
        flightModeShortHaul,
      );
    });

    test('unknown country falls back to short-haul', () {
      expect(flightBandModeId(straightLineKm: 400), flightModeShortHaul);
      expect(
        flightBandModeId(straightLineKm: 400, fromCc: 'GB'),
        flightModeShortHaul,
      );
    });

    test('exactly at the boundary is not long-haul', () {
      expect(
        flightBandModeId(
          straightLineKm: flightLongHaulMinKm,
          fromCc: 'GB',
          toCc: 'FR',
        ),
        flightModeShortHaul,
      );
    });
  });
}
