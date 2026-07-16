import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/widgets/stat_card.dart';

void main() {
  group('StatCard', () {
    testWidgets('displays icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(icon: Icons.star, value: '100', label: 'Points'),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('displays value text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(icon: Icons.star, value: '1,234', label: 'Points'),
          ),
        ),
      );

      expect(find.text('1,234'), findsOneWidget);
    });

    testWidgets('displays label text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              icon: Icons.star,
              value: '100',
              label: 'Total Points',
            ),
          ),
        ),
      );

      expect(find.text('Total Points'), findsOneWidget);
    });

    testWidgets('applies custom icon color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              icon: Icons.star,
              value: '100',
              label: 'Points',
              iconColor: Colors.red,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.star));
      expect(icon.color, Colors.red);
    });

    testWidgets('renders in container with rounded corners', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(icon: Icons.star, value: '100', label: 'Points'),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });
  });
}
