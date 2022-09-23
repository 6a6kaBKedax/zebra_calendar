library zebra_calendar;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiver/time.dart';

/// A ZebraCalendar.
class ZebraCalendar extends StatelessWidget {
  ZebraCalendar({
    super.key,
    initDate,
    this.availableDates,
    this.notAvailableDates,
    this.onTap,
    this.controller,
    this.min,
    this.max,
    this.textStyle,
    this.removeDayNames = false,
  }) {
    textStyle ??= GoogleFonts.roboto(
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      color: const Color(0xFF202020),
    );
    this.initDate = initDate ?? DateTime.now();
    _initCurrentMonth();
  }

  late final DateTime initDate;
  late final TextStyle? textStyle;
  late final bool removeDayNames;

  final List<DateTime>? availableDates;
  final List<DateTime>? notAvailableDates;
  final Function(DateTime)? onTap;
  final CalendarController? controller;
  final DateTime? min;
  final DateTime? max;

  late final List<Widget> days;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          childAspectRatio: 2 / 3,
          children: days,
        ),
      ],
    );
  }

  void _initCurrentMonth() {
    int numberDaysInMonth = daysInMonth(initDate.year, initDate.month);
    int dayOfWeekInFirstDate = DateTime(initDate.year, initDate.month, 1).weekday;
    List<DateTime?> shuffledList = [];
    while (dayOfWeekInFirstDate != 0) {
      shuffledList.add(null);
      dayOfWeekInFirstDate--;
    }
    for (int i = 1; i <= numberDaysInMonth; i++) {
      shuffledList.add(DateTime(initDate.year, initDate.month, i));
    }
    days = shuffledList.map((e) {
      if (e == null) {
        return const SizedBox();
      } else {
        return _DayWidget(
          available: true,
          dayData: e,
          onTap: onTap,
        );
      }
    }).toList();
  }
}

class CalendarController {
  final Function(DateTime)? currentDate;
  final DateTime? setDate;
  final Function()? nextMonth;
  final Function()? nextYear;

  CalendarController(
    this.currentDate,
    this.setDate,
    this.nextMonth,
    this.nextYear,
  );
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
