import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';

/// A single day cell in the progress calendar.
///
/// Displays a ball sized by goal completion ratio, with special
/// styling for today and empty days.
class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({required this.data, this.onTap, super.key});

  final CalendarDayData data;

  /// Called when the cell is tapped. Ignored for future dates.
  final VoidCallback? onTap;

  /// Minimum ball size in logical pixels
  static const double _minBallSize = 8;

  /// Maximum ball size in logical pixels
  static const double _maxBallSize = 28;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Don't show anything for future dates
    if (data.isFuture) {
      return _buildDayNumber(context, isDisabled: true);
    }

    // Calculate ball size based on completion
    final ballSize = data.hasActivity
        ? _minBallSize + (_maxBallSize - _minBallSize) * data.completionRatio
        : 0.0;

    // Color lerps from primaryContainer to primary based on completion
    final ballColor = Color.lerp(
      colorScheme.primaryContainer,
      colorScheme.primary,
      data.completionRatio,
    )!;

    final cell = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDayNumber(context),
        const SizedBox(height: spacingXxs),
        _buildBall(
          ballSize: ballSize,
          ballColor: ballColor,
          isToday: data.isToday,
          colorScheme: colorScheme,
        ),
      ],
    );

    if (onTap == null) return cell;
    return InkWell(onTap: onTap, borderRadius: borderRadiusSm, child: cell);
  }

  Widget _buildDayNumber(BuildContext context, {bool isDisabled = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      '${data.date.day}',
      style: theme.textTheme.bodySmall?.copyWith(
        fontWeight: data.isToday ? FontWeight.bold : null,
        color: isDisabled
            ? colorScheme.onSurface.withValues(alpha: opacityDisabled)
            : data.isToday
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(alpha: opacityStrong),
      ),
    );
  }

  Widget _buildBall({
    required double ballSize,
    required Color ballColor,
    required bool isToday,
    required ColorScheme colorScheme,
  }) {
    // Container to ensure consistent height
    return SizedBox(
      height: _maxBallSize + 4, // Extra space for today ring
      child: Center(
        child: ballSize > 0
            ? Container(
                width: ballSize,
                height: ballSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ballColor,
                  border: isToday
                      ? Border.all(color: colorScheme.primary, width: 2)
                      : null,
                  boxShadow: data.isGoalMet
                      ? [
                          BoxShadow(
                            color: ballColor.withValues(alpha: opacityMedium),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              )
            : isToday
            ? Container(
                width: _minBallSize,
                height: _minBallSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.primary, width: 1.5),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
