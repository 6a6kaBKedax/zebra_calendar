library zebra_calendar;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiver/time.dart';
import 'package:provider/provider.dart';
import 'package:zebra_calendar/calendar_controller.dart';

/// A ZebraCalendar.
class ZebraCalendar extends StatelessWidget {
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
    this.controller,
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
  final CalendarController? controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarController>(
      create: (BuildContext context) => controller != null
          ? (controller!
            ..initController(
              initDate: initDate,
              availableDates: availableDates,
              max: max,
              min: min,
            ))
          : CalendarController()
        ..initController(
          initDate: initDate,
          availableDates: availableDates,
          max: max,
          min: min,
        ),
      child: Builder(builder: (context) {
        final provider = Provider.of<CalendarController>(context);
        //provider.initController(initDate: initDate, availableDates: availableDates, max: max, min: min);
        return Column(
          children: <Widget>[
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              childAspectRatio: 2.5 / 3,
              children: provider.days
                  .map(
                    (e) => e == null
                        ? const SizedBox()
                        : _DayWidget(
                            available: e.available ?? true,
                            dayData: e.dayData,
                            onTap: onTap,
                          ),
                  )
                  .toList(),
            ),
          ],
        );
      }),
    );
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
