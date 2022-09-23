library zebra_calendar;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiver/time.dart';

/// A ZebraCalendar.
class ZebraCalendar extends StatelessWidget with CalendarController {
  ZebraCalendar({
    super.key,
    initDate,
    this.availableDates,
    this.onTap,
    this.controller,
    this.min,
    this.max,
    this.textStyle,
    this.removeDayNames = false,
    this.customBuilder,
  }) {
    textStyle ??= GoogleFonts.roboto(
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      color: const Color(0xFF202020),
    );
    this.initDate = initDate ?? DateTime.now();
    _currentMonthYear = initDate ?? DateTime.now();
    _initMonth(_currentMonthYear);
    _initController(controller);
  }

  late DateTime initDate;
  late TextStyle? textStyle;
  late bool removeDayNames;

  final Widget Function(DateTime? date, int index)? customBuilder;
  final List<DateTime>? availableDates;
  final Function(DateTime)? onTap;
  final CalendarController? controller;
  final DateTime? min;
  final DateTime? max;

  late final List<Widget> days;

  late DateTime _currentMonthYear;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          childAspectRatio: 2.5 / 3,
          children: days,
        ),
      ],
    );
  }

  void _nextMonth() {
    if (max != null && _currentMonthYear.year == max!.year && _currentMonthYear.month == max!.month) {
      return;
    }
    late DateTime nextDate;
    if (_currentMonthYear.month == 12) {
      nextDate = DateTime(_currentMonthYear.year + 1, 1, _currentMonthYear.day);
      _currentMonthYear = nextDate;
    } else {
      nextDate = DateTime(_currentMonthYear.year, _currentMonthYear.month + 1, _currentMonthYear.day);
      _currentMonthYear = nextDate;
    }
    _initMonth(_currentMonthYear);
  }

  void _previousMonth() {
    if (min != null && _currentMonthYear.year == min!.year && _currentMonthYear.month == min!.month) {
      return;
    }
    late DateTime nextDate;
    if (_currentMonthYear.month == 1) {
      nextDate = DateTime(_currentMonthYear.year - 1, 12, _currentMonthYear.day);
      _currentMonthYear = nextDate;
    } else {
      nextDate = DateTime(_currentMonthYear.year, _currentMonthYear.month - 1, _currentMonthYear.day);
      _currentMonthYear = nextDate;
    }
    _initMonth(_currentMonthYear);
  }

  void _initMonth(DateTime input) {
    int numberDaysInMonth = daysInMonth(input.year, input.month);
    int dayOfWeekInFirstDate = DateTime(input.year, input.month, 1).weekday;
    List<DateTime?> shuffledList = [];
    while (dayOfWeekInFirstDate != 1) {
      shuffledList.add(null);
      dayOfWeekInFirstDate--;
    }
    for (int i = 1; i <= numberDaysInMonth; i++) {
      shuffledList.add(DateTime(input.year, input.month, i));
    }
    if (customBuilder != null) {
      for (int i = 0; i < shuffledList.length; i++) {
        customBuilder!(shuffledList[i], i);
      }
    } else {
      days = shuffledList.map((e) {
        if (e == null) {
          return const SizedBox();
        } else {
          if (availableDates != null && availableDates!.contains(e)) {
            return _DayWidget(
              available: true,
              dayData: e,
              onTap: onTap,
            );
          } else if (availableDates != null) {
            return _DayWidget(
              available: false,
              dayData: e,
              onTap: onTap,
            );
          } else {
            return _DayWidget(
              available: true,
              dayData: e,
              onTap: onTap,
            );
          }
        }
      }).toList();
    }
  }

  void _initController(CalendarController? controller) {
    if (controller != null) {
      controller.nextMonth;
    }
  }

  @override
  void nextMonth() {
    _nextMonth();
  }

  @override
  void previousMonth() {
    _previousMonth();
  }

  @override
  DateTime currentCalendarData() {
    return _currentMonthYear;
  }
}

class CalendarController {
  void nextMonth() {}

  void previousMonth() {}

  DateTime currentCalendarData() {
    return DateTime.now();
  }
}

class _DayWidget extends StatelessWidget {
  const _DayWidget({
    Key? key,
    required this.available,
    required this.dayData,
    this.onTap,
  }) : super(key: key);
  final bool available;
  final DateTime dayData;
  final Function(DateTime)? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          thickness: 1.0,
          height: 1.0,
          color: Color(0xFFBBBBBB),
        ),
        InkWell(
          onTap: () {
            if (onTap != null) onTap!(dayData);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              dayData.day.toString(),
              style: available
                  ? GoogleFonts.roboto(
                      color: const Color(0xFF202020),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    )
                  : GoogleFonts.roboto(
                      color: const Color(0xFF8E8E8E),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
