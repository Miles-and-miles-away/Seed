import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_sort_option.dart';

void main() {
  group('ActionSortOption', () {
    test('has 6 values', () {
      expect(ActionSortOption.values.length, 6);
    });

    test('contains all expected values', () {
      expect(
        ActionSortOption.values,
        containsAll([
          ActionSortOption.alphabeticalAsc,
          ActionSortOption.alphabeticalDesc,
          ActionSortOption.co2HighToLow,
          ActionSortOption.co2LowToHigh,
          ActionSortOption.pointsHighToLow,
          ActionSortOption.pointsLowToHigh,
        ]),
      );
    });

    group('displayName', () {
      late AppLocalizations l10n;

      setUpAll(() async {
        // Load English locale for testing
        l10n = await AppLocalizations.delegate.load(const Locale('en'));
      });

      test('alphabeticalAsc returns Name (A-Z)', () {
        expect(
          ActionSortOption.alphabeticalAsc.displayName(l10n),
          'Name (A-Z)',
        );
      });

      test('alphabeticalDesc returns Name (Z-A)', () {
        expect(
          ActionSortOption.alphabeticalDesc.displayName(l10n),
          'Name (Z-A)',
        );
      });

      test('co2HighToLow returns CO2 (High to Low)', () {
        expect(
          ActionSortOption.co2HighToLow.displayName(l10n),
          'CO\u2082 (High to Low)',
        );
      });

      test('co2LowToHigh returns CO2 (Low to High)', () {
        expect(
          ActionSortOption.co2LowToHigh.displayName(l10n),
          'CO\u2082 (Low to High)',
        );
      });

      test('pointsHighToLow returns Points (High to Low)', () {
        expect(
          ActionSortOption.pointsHighToLow.displayName(l10n),
          'Points (High to Low)',
        );
      });

      test('pointsLowToHigh returns Points (Low to High)', () {
        expect(
          ActionSortOption.pointsLowToHigh.displayName(l10n),
          'Points (Low to High)',
        );
      });
    });
  });
}
