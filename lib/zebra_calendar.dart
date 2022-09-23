library zebra_calendar;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiver/time.dart';

/// A ZebraCalendar.
class ZebraCalendar extends StatefulWidget  {
  ZebraCalendar({
    super.key,
    initDate,
    this.availableDates,
    this.onTap,
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
  }

  late DateTime initDate;
  late TextStyle? textStyle;
  late bool removeDayNames;

  final Widget Function(DateTime? date, int index)? customBuilder;
  final List<DateTime>? availableDates;
  final Function(DateTime)? onTap;
  final DateTime? min;
  final DateTime? max;

  @override
  State<ZebraCalendar> createState() => _ZebraCalendarState();
}

class _ZebraCalendarState extends State<ZebraCalendar> with CalendarController {
  @override
  initState() {
    _currentMonthYear = widget.initDate;
    _initMonth(_currentMonthYear);
    super.initState();
  }

  late DateTime _currentMonthYear;
  late final List<Widget> days;

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
    if (widget.max != null &&
        _currentMonthYear.year == widget.max!.year &&
        _currentMonthYear.month == widget.max!.month) {
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
    setState(() {});
  }

  void _previousMonth() {
    if (widget.min != null &&
        _currentMonthYear.year == widget.min!.year &&
        _currentMonthYear.month == widget.min!.month) {
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
    setState(() {});
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
    if (widget.customBuilder != null) {
      for (int i = 0; i < shuffledList.length; i++) {
        widget.customBuilder!(shuffledList[i], i);
      }
    } else {
      days = shuffledList.map((e) {
        if (e == null) {
          return const SizedBox();
        } else {
          if (widget.availableDates != null && widget.availableDates!.contains(e)) {
            return _DayWidget(
              available: true,
              dayData: e,
              onTap: widget.onTap,
            );
          } else if (widget.availableDates != null) {
            return _DayWidget(
              available: false,
              dayData: e,
              onTap: widget.onTap,
            );
          } else {
            return _DayWidget(
              available: true,
              dayData: e,
              onTap: widget.onTap,
            );
          }
        }
      }).toList();
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
