import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/constants.dart';
import 'package:kalender/src/providers/calendar_style.dart';

/// A widget that displays the timeline.
class Timeline extends StatelessWidget {
  const Timeline({
    super.key,
    required this.hourHeight,
    required this.startHour,
    required this.endHour,
  });

  final double hourHeight;
  final int startHour;
  final int endHour;

  @override
  Widget build(BuildContext context) {
    final timelineStyle = CalendarStyleProvider.of(context).style.timelineStyle;
    final timelineTextBuilder =
        CalendarScope.of(context).components.timelineTextBuilder;

    final timeline = Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
      children: [
        for (int i = 0; i <= hoursADay; i++)
          Positioned(
            left: 0,
            right: 0,
            height: hourHeight,
            top: (i * hourHeight),
            child: i == startHour - 1 || i == endHour - 1
                ? const SizedBox()
                : timelineTextBuilder != null
                    ? timelineTextBuilder(
                        TimeOfDay(hour: i + 1, minute: 0),
                      )
                    : Center(
                        child: TimeText(
                          timeOfDay: TimeOfDay(hour: i + 1, minute: 0),
                          textStyle: timelineStyle?.textStyle,
                          use24HourFormat: timelineStyle?.use24HourFormat ??
                              MediaQuery.of(context).alwaysUse24HourFormat,
                        ),
                      ),
          ),
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: hourHeight / 2),
        child: timeline,
      ),
    );
  }
}

class TimeText extends StatelessWidget {
  const TimeText({
    super.key,
    required this.timeOfDay,
    required this.textStyle,
    required this.use24HourFormat,
  });
  final TimeOfDay timeOfDay;
  final TextStyle? textStyle;
  final bool use24HourFormat;

  @override
  Widget build(BuildContext context) {
    final string = use24HourFormat
        ? '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}'
        : '${((timeOfDay.hour - 1) % 12) + 1} ${timeOfDay.hour ~/ 12 == 0 ? "am" : "pm"}';
    return Text(
      string,
      style: textStyle,
    );
  }
}
