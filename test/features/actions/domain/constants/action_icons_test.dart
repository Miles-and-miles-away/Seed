import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/domain/constants/action_icons.dart';

import '../../../../helpers/dataset_helpers.dart';

void main() {
  group('actionIconMap', () {
    test('contains expected icon entries', () {
      expect(actionIconMap, isNotEmpty);
      expect(actionIconMap.length, greaterThanOrEqualTo(40));
    });

    test('maps known icon names to correct icons', () {
      expect(actionIconMap['recycling'], Icons.recycling);
      expect(actionIconMap['bike'], Icons.pedal_bike);
      expect(actionIconMap['water_drop'], Icons.water_drop);
      expect(actionIconMap['bolt'], Icons.bolt);
      expect(actionIconMap['eco'], Icons.eco);
    });

    test('contains expanded Phase 4 icons', () {
      expect(actionIconMap['campaign'], Icons.campaign);
      expect(actionIconMap['menu_book'], Icons.menu_book);
      expect(actionIconMap['groups'], Icons.groups);
      expect(actionIconMap['volunteer_activism'], Icons.volunteer_activism);
      expect(actionIconMap['school'], Icons.school);
      expect(actionIconMap['handshake'], Icons.handshake);
    });

    test('covers every icon name in the seeded action library', () {
      final actions = rawDatasetList(
        'data/seed/co2_actions_database.json',
        'actions',
      );
      for (final action in actions) {
        expect(
          actionIconMap,
          contains(action['icon_name']),
          reason: '${action['action_id']} falls back to the default icon',
        );
      }
    });

    test('all values are valid IconData', () {
      for (final entry in actionIconMap.entries) {
        expect(
          entry.value,
          isA<IconData>(),
          reason: '${entry.key} is not IconData',
        );
      }
    });
  });

  group('getActionIcon', () {
    test('returns mapped icon for known name', () {
      expect(getActionIcon('recycling'), Icons.recycling);
    });

    test('returns Icons.eco for unknown name', () {
      expect(getActionIcon('nonexistent_icon'), Icons.eco);
    });

    test('returns Icons.eco for empty string', () {
      expect(getActionIcon(''), Icons.eco);
    });

    test('handles all map keys without error', () {
      for (final key in actionIconMap.keys) {
        expect(
          getActionIcon(key),
          isA<IconData>(),
          reason: 'getActionIcon("$key") failed',
        );
      }
    });
  });
}
