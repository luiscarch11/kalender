import 'package:flutter/material.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the month grid.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.month,
  });

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final style = CalendarStyleProvider.of(context).style.monthGridStyle;
    final thickness = style.thickness ?? 0;
    final color = style.color;

    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 8; i++)
              VerticalDivider(
                width: thickness,
                thickness: thickness,
                color: color,
              ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < _calculateWeeksNeeded(month) + 1; i++)
              Divider(
                height: thickness,
                thickness: thickness,
                color: color,
              ),
          ],
        ),
      ],
    );
  }

  int _calculateWeeksNeeded(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    // Convert to 0-based (Sunday = 0) for firstDayOfWeek: 7 (Sunday)
    // Sunday = 7 in DateTime.weekday, so 7 % 7 = 0
    final firstDayOffset = firstDayOfMonth.weekday % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final totalCellsNeeded = firstDayOffset + daysInMonth;

    // Calculate weeks needed: ceil(totalCellsNeeded / 7)
    final weeksNeeded = (totalCellsNeeded / 7).ceil();

    // Ensure we return 4, 5, or 6 weeks
    if (weeksNeeded <= 4) {
      return 4;
    } else if (weeksNeeded <= 5) {
      return 5;
    } else {
      return 6;
    }
  }
}
