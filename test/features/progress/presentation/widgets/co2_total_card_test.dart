import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/progress/domain/entities/co2_stats.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/presentation/widgets/co2_total_card.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('Co2TotalCard', () {
    testWidgets('renders zero state as "0.0 kg"', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: const Co2TotalCard(
            stats: Co2Stats(
              totalGrams: 0,
              previousTotalGrams: 0,
              percentChange: 0,
              period: TimePeriod.today,
            ),
          ),
        ),
      );

      expect(find.text('0.0 kg'), findsOneWidget);
      expect(find.text('CO2 saved today'), findsOneWidget);
    });

    testWidgets('renders sub-kg total in kg with one decimal', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: const Co2TotalCard(
            stats: Co2Stats(
              totalGrams: 412,
              previousTotalGrams: 0,
              percentChange: 0,
              period: TimePeriod.today,
            ),
          ),
        ),
      );

      expect(find.text('0.4 kg'), findsOneWidget);
    });

    testWidgets('renders large total formatted with one decimal', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: const Co2TotalCard(
            stats: Co2Stats(
              totalGrams: 42008,
              previousTotalGrams: 0,
              percentChange: 0,
              period: TimePeriod.allTime,
            ),
          ),
        ),
      );

      expect(find.text('42.0 kg'), findsOneWidget);
      expect(find.text('CO2 saved all time'), findsOneWidget);
    });

    testWidgets('shows period-specific header for each period', (tester) async {
      const periods = [
        (TimePeriod.today, 'CO2 saved today'),
        (TimePeriod.thisWeek, 'CO2 saved this week'),
        (TimePeriod.thisMonth, 'CO2 saved this month'),
        (TimePeriod.allTime, 'CO2 saved all time'),
      ];

      for (final (period, expectedHeader) in periods) {
        await tester.pumpWidget(
          createTestWidget(
            scaffold: true,
            child: Co2TotalCard(
              stats: Co2Stats(
                totalGrams: 1000,
                previousTotalGrams: 0,
                percentChange: 0,
                period: period,
              ),
            ),
          ),
        );

        expect(
          find.text(expectedHeader),
          findsOneWidget,
          reason: 'header for $period',
        );
      }
    });
  });
}
