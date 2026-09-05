import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/progress/domain/entities/co2_chart_data.dart';
import 'package:seed_app/features/progress/presentation/widgets/co2_trend_chart.dart';

import '../../../../helpers/test_helpers.dart';

Co2TrendData _fixture({
  int days = 7,
  List<(int dayOffset, int grams)> points = const [],
}) {
  final start = DateTime(2026, 5);
  final end = start.add(Duration(days: days));
  final pts = points
      .map(
        (p) => Co2TrendPoint(
          date: start.add(Duration(days: p.$1)),
          grams: p.$2,
        ),
      )
      .toList();
  final avg = pts.isEmpty
      ? 0.0
      : pts.map((p) => p.grams).reduce((a, b) => a + b) / pts.length;
  return Co2TrendData(
    points: pts,
    averageGrams: avg,
    windowStart: start,
    windowEnd: end,
  );
}

void main() {
  group('Co2TrendChart', () {
    testWidgets('renders title and average legend label', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: Co2TrendChart(
            data: _fixture(points: const [(0, 500), (3, 1200), (6, 900)]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Daily trend'), findsOneWidget);
      expect(find.text('average'), findsOneWidget);
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('renders without throwing for sparse 90-day data', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: Co2TrendChart(
            data: _fixture(
              days: 90,
              points: const [(0, 200), (45, 1500), (89, 700)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
