import 'package:flutter/material.dart';
import 'package:quiver/time.dart';
import 'package:zebra_calendar/models/day_model.dart';

class CalendarController extends ChangeNotifier {
  DateTime _currentMonthYear = DateTime.now();

  DateTime get currentMountYear => _currentMonthYear;

  late List<DayModel?> _days;

  List<DayModel?> get days => _days;

  late DateTime? _max;

  DateTime? get max => _max;

  late DateTime? _min;

  DateTime? get min => _min;

  late List<DateTime>? _availableDates;

  void initController({required DateTime initDate, DateTime? max, DateTime? min, List<DateTime>? availableDates}) {
    _max = max;
    _min = min;
    _availableDates = availableDates;
    _currentMonthYear = initDate;
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
    // if (widget.customBuilder != null) {
    //   for (int i = 0; i < shuffledList.length; i++) {
    //     widget.customBuilder!(shuffledList[i], i);
    //   }
    // } else {
    _days = shuffledList.map((e) {
      if (e == null) {
        return null;
      } else {
        if (_availableDates != null && _availableDates!.contains(e)) {
          return DayModel(
            available: true,
            dayData: e,
          );
        } else if (_availableDates != null) {
          return DayModel(
            available: false,
            dayData: e,
          );
        } else {
          return DayModel(
            available: true,
            dayData: e,
          );
        }
      }
    }).toList();
    notifyListeners();
  }

  void nextMonth() {
    if (_max != null && _currentMonthYear.year == _max!.year && _currentMonthYear.month == _max!.month) {
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

  void previousMonth() {
    if (_min != null &&
        _min != null &&
        _currentMonthYear.year == _min!.year &&
        _currentMonthYear.month == _min!.month) {
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
}
