import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/components/tiles/multi_day_event_tile.dart';
import 'package:kalender/src/extensions.dart';
import 'package:kalender/src/models/event_group_controllers/multi_day_event_group.dart';

/// A widget that displays a group of events as [MultiDayEventGestureDetector]s using the [CustomMultiChildLayout] widget.
class MultiDayEventGroupWidget<T> extends StatelessWidget {
  const MultiDayEventGroupWidget._({
    super.key,
    required this.isChanging,
    required this.visibleDateRange,
    required this.multiDayEventGroup,
    required this.multiDayTileHeight,
    required this.horizontalStep,
    required this.horizontalStepDuration,
    this.verticalStep,
    this.verticalStepDuration,
    this.rescheduleDateRange,
  });
  factory MultiDayEventGroupWidget({
    required bool isChanging,
    required DateTimeRange visibleDateRange,
    required MultiDayEventGroup<T> multiDayEventGroup,
    required double multiDayTileHeight,
    required double horizontalStep,
    required Duration horizontalStepDuration,
    DateTimeRange? rescheduleDateRange,
  }) =>
      MultiDayEventGroupWidget._(
        isChanging: isChanging,
        visibleDateRange: visibleDateRange,
        multiDayEventGroup: multiDayEventGroup,
        multiDayTileHeight: multiDayTileHeight,
        horizontalStep: horizontalStep,
        horizontalStepDuration: horizontalStepDuration,
        verticalStep: null,
        verticalStepDuration: null,
      );
  factory MultiDayEventGroupWidget.month({
    required bool isChanging,
    required DateTimeRange visibleDateRange,
    required MultiDayEventGroup<T> multiDayEventGroup,
    required double multiDayTileHeight,
    required double horizontalStep,
    required Duration horizontalStepDuration,
    DateTimeRange? rescheduleDateRange,
    required double verticalStep,
    required Duration verticalStepDuration,
  }) =>
      MultiDayEventGroupWidget._(
        isChanging: isChanging,
        visibleDateRange: visibleDateRange,
        multiDayEventGroup: multiDayEventGroup,
        multiDayTileHeight: multiDayTileHeight,
        horizontalStep: horizontalStep,
        horizontalStepDuration: horizontalStepDuration,
        verticalStep: verticalStep,
        verticalStepDuration: verticalStepDuration,
      );

  final bool isChanging;
  final DateTimeRange visibleDateRange;
  final DateTimeRange? rescheduleDateRange;
  final MultiDayEventGroup<T> multiDayEventGroup;
  final double multiDayTileHeight;
  final double horizontalStep;
  final Duration horizontalStepDuration;
  final double? verticalStep;
  final Duration? verticalStepDuration;

  @override
  Widget build(BuildContext context) {
    final scope = CalendarScope.of<T>(context);

    final children = <LayoutId>[];
    for (var i = 0; i < multiDayEventGroup.events.length; i++) {
      final event = multiDayEventGroup.events[i];

      // Check if the event is currently being moved.
      final isMoving = scope.eventsController.selectedEvent == event;

      final tileType = isChanging
          ? TileType.selected
          : isMoving
              ? TileType.ghost
              : TileType.normal;

      final continuesBefore = event.start.isBefore(visibleDateRange.start);
      final continuesAfter = event.end.isAfter(visibleDateRange.end.endOfDay);

      final tileConfiguration = MultiDayTileConfiguration(
        tileType: tileType,
        continuesBefore: continuesBefore,
        continuesAfter: continuesAfter,
      );

      final multiDayEventTile = scope.tileComponents.multiDayEventTileBuilder?.call(
            event,
            tileConfiguration,
            rescheduleDateRange ?? visibleDateRange,
            horizontalStep,
            horizontalStepDuration,
            verticalStepDuration,
            verticalStep,
          ) ??
          MultiDayEventGestureDetector(
            event: event,
            rescheduleDateRange: rescheduleDateRange ?? visibleDateRange,
            horizontalStep: horizontalStep,
            horizontalStepDuration: horizontalStepDuration,
            verticalStep: verticalStep,
            verticalStepDuration: verticalStepDuration,
            tileConfiguration: tileConfiguration,
          );

      children.add(
        LayoutId(
          id: i,
          child: multiDayEventTile,
        ),
      );
    }

    return CustomMultiChildLayout(
      delegate: scope.layoutDelegates.multiDayTileLayoutDelegate(
        events: multiDayEventGroup.events,
        visibleDateRange: visibleDateRange,
        multiDayTileHeight: multiDayTileHeight,
        verticalStep: verticalStep ?? 0,
      ),
      children: children,
    );
  }

  double calculateHeight(Duration duration, double heightPerMinute) {
    return duration.inMinutes * heightPerMinute;
  }
}
