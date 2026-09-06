import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';

void main() {
  group('ActionCategory', () {
    group('values', () {
      test('has correct number of categories', () {
        expect(ActionCategory.values.length, 9);
      });

      test('contains all expected categories', () {
        expect(ActionCategory.values, contains(ActionCategory.recycling));
        expect(ActionCategory.values, contains(ActionCategory.transport));
        expect(ActionCategory.values, contains(ActionCategory.food));
        expect(ActionCategory.values, contains(ActionCategory.energy));
        expect(ActionCategory.values, contains(ActionCategory.consumption));
        expect(ActionCategory.values, contains(ActionCategory.water));
        expect(ActionCategory.values, contains(ActionCategory.community));
        expect(ActionCategory.values, contains(ActionCategory.advocacy));
        expect(ActionCategory.values, contains(ActionCategory.learning));
      });
    });

    group('color', () {
      test('every category has its own opaque color', () {
        final colors = ActionCategory.values.map((c) => c.color).toList();

        expect(colors.toSet(), hasLength(ActionCategory.values.length));
        expect(colors.every((c) => c.a == 1), isTrue);
      });
    });

    group('icon', () {
      test('recycling has recycling icon', () {
        expect(ActionCategory.recycling.icon, Icons.recycling);
      });

      test('transport has bike icon', () {
        expect(ActionCategory.transport.icon, Icons.directions_bike);
      });

      test('food has restaurant icon', () {
        expect(ActionCategory.food.icon, Icons.restaurant);
      });

      test('energy has bolt icon', () {
        expect(ActionCategory.energy.icon, Icons.bolt);
      });

      test('consumption has shopping bag icon', () {
        expect(ActionCategory.consumption.icon, Icons.shopping_bag);
      });

      test('water has water drop icon', () {
        expect(ActionCategory.water.icon, Icons.water_drop);
      });

      test('community has volunteer activism icon', () {
        expect(ActionCategory.community.icon, Icons.volunteer_activism);
      });

      test('advocacy has campaign icon', () {
        expect(ActionCategory.advocacy.icon, Icons.campaign);
      });

      test('learning has menu_book icon', () {
        expect(ActionCategory.learning.icon, Icons.menu_book);
      });
    });

    group('fromString', () {
      test('returns correct category for valid lowercase string', () {
        expect(
          ActionCategory.fromString('recycling'),
          ActionCategory.recycling,
        );
        expect(
          ActionCategory.fromString('transport'),
          ActionCategory.transport,
        );
        expect(ActionCategory.fromString('food'), ActionCategory.food);
        expect(ActionCategory.fromString('energy'), ActionCategory.energy);
        expect(
          ActionCategory.fromString('consumption'),
          ActionCategory.consumption,
        );
        expect(ActionCategory.fromString('water'), ActionCategory.water);
        expect(
          ActionCategory.fromString('community'),
          ActionCategory.community,
        );
        expect(ActionCategory.fromString('advocacy'), ActionCategory.advocacy);
        expect(ActionCategory.fromString('learning'), ActionCategory.learning);
      });

      test('returns correct category for mixed case string', () {
        expect(
          ActionCategory.fromString('RECYCLING'),
          ActionCategory.recycling,
        );
        expect(
          ActionCategory.fromString('Recycling'),
          ActionCategory.recycling,
        );
        expect(
          ActionCategory.fromString('TRANSPORT'),
          ActionCategory.transport,
        );
      });

      test('returns null for invalid string', () {
        expect(ActionCategory.fromString('invalid'), isNull);
        expect(ActionCategory.fromString('unknown'), isNull);
        expect(ActionCategory.fromString(''), isNull);
      });

      test('returns null for null input', () {
        expect(ActionCategory.fromString(null), isNull);
      });
    });
  });
}
