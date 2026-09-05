import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';

/// The rules file repeats these caps as literals; a client-side change
/// that forgets the rules would otherwise pass every Dart test.
void main() {
  test('firestore.rules mirrors the client-side length caps', () {
    final rules = File('firestore.rules').readAsStringSync();

    Matcher caps(String field, int max) =>
        matches(RegExp('d\\.$field\\.size\\(\\)\\s*<=\\s*$max\\b'));

    expect(rules, caps('displayName', AppConstants.maxDisplayNameLength));
    expect(rules, caps('personalGoal', AppConstants.maxPersonalGoalLength));
    expect(rules, caps('mascots', AppConstants.maxMascotsPerUser));
  });
}
