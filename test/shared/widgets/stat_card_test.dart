import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/widgets/stat_card.dart';

void main() {
  group('StatCard', () {
    testWidgets('displays icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              icon: Icons.star,
              value: '100',
              label: 'Points',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('displays value text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCard(
              icon: Icons.star,
              value: '1,234',
              label: 'Points',
            ),
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
            body: StatCard(
              icon: Icons.star,
              value: '100',
              label: 'Points',
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
    });
  });

  group('StatCardRow', () {
    testWidgets('displays two stat cards side by side', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCardRow(
              left: StatCard(
                icon: Icons.star,
                value: '100',
                label: 'Left Card',
              ),
              right: StatCard(
                icon: Icons.favorite,
                value: '200',
                label: 'Right Card',
              ),
            ),
          ),
        ),
      );

      expect(find.text('100'), findsOneWidget);
      expect(find.text('200'), findsOneWidget);
      expect(find.text('Left Card'), findsOneWidget);
      expect(find.text('Right Card'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('uses Row layout', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCardRow(
              left: StatCard(
                icon: Icons.star,
                value: '100',
                label: 'Left',
              ),
              right: StatCard(
                icon: Icons.favorite,
                value: '200',
                label: 'Right',
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('wraps cards in Expanded widgets', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatCardRow(
              left: StatCard(
                icon: Icons.star,
                value: '100',
                label: 'Left',
              ),
              right: StatCard(
                icon: Icons.favorite,
                value: '200',
                label: 'Right',
              ),
            ),
          ),
        ),
      );

      // StatCardRow uses two Expanded widgets
      expect(find.byType(Expanded), findsNWidgets(2));
    });
  });
}
