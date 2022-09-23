library zebra_calendar;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    _initCurrentMonth();
    textStyle ??= GoogleFonts.roboto(
      fontWeight: FontWeight.w400,
      fontSize: 16.0,
      color: const Color(0xFF202020),
    );
    this.initDate = initDate ?? DateTime.now();
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

  final List<DateTime> _mo = [];
  final List<DateTime> _tu = [];
  final List<DateTime> _we = [];
  final List<DateTime> _th = [];
  final List<DateTime> _fr = [];
  final List<DateTime> _sa = [];
  final List<DateTime> _su = [];

  late final List<List<DateTime>> shuffledList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            removeDayNames
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('Mo', style: textStyle),
                  ),
          ],
        ),
        Column(
          children: [
            removeDayNames
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('Tu', style: textStyle),
                  ),
          ],
        ),
        Column(
          children: [
            removeDayNames
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('We', style: textStyle),
                  ),
          ],
        ),
        Column(
          children: [
            removeDayNames
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('Th', style: textStyle),
                  ),
          ],
        ),
        Column(
          children: [
            removeDayNames
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('Fr', style: textStyle),
                  ),
          ],
        ),
        Column(
          children: [
            removeDayNames
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('Sa', style: textStyle),
                  ),
          ],
        ),
        Column(
          children: [
            removeDayNames
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text('Su', style: textStyle),
                  ),
          ],
        ),
      ],
    );
  }

  ///Columns by day of week implementation
  /*void _initCurrentMonth() {
    int numberDaysInMonth = daysInMonth(initDate.year, initDate.month);
    List<List<DateTime>> shuffledList = [];
    List<List<DateTime>> weekCollection = [_mo, _tu, _we, _th, _fr, _sa, _su];
    shuffledList.addAll(weekCollection.getRange(initDate.weekday - 1, 6));
    weekCollection.removeRange(initDate.weekday - 1, 6);
    if (weekCollection.isNotEmpty) {
      shuffledList.addAll(weekCollection);
    }
    int counter = 0;
    for (int i = 1; i <= numberDaysInMonth; i++) {
      shuffledList[counter].add(DateTime(initDate.year, initDate.month, i));
      counter++;
      if (counter == 7) {
        counter = 0;
      }
    }
    this.shuffledList = shuffledList;
  }*/
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
