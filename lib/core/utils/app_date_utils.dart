import 'package:flutter/material.dart';
import 'package:horti_vige/data/enums/days.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String getCurrentMonthName() {
    return DateFormat.MMM().format(DateTime.now());
  }

  static List<String> getAllRemainingDaysOfCurrentMonth() {
    final totalDays = daysInMonth(DateTime.now());
    final listOfDates =
        List<String>.generate(totalDays, (i) => (i + 1).toString());

    final dateNow = DateTime.now();
    final currentDay = dateNow.day;
    listOfDates.removeWhere((day) => int.parse(day) <= currentDay);
    return listOfDates;
  }

  static Map<String, String> getNext30DaysOfYearWithMonth() {
    final next30Days = <String, String>{};
    final current = DateTime.now();
    final currentDayOfYear = current.toDayOfYear();
    final daysInMonth = DateUtils.getDaysInMonth(current.year, current.month);

    for (var i = currentDayOfYear; i < currentDayOfYear + daysInMonth; i++) {
      final dateTime = DateTime.now().fromDayOfYear(i);
      next30Days[dateTime.day.toString()] =
          DateFormat('E, MMM').format(dateTime);
    }

    return next30Days;
  }

  static List<String> getAllHoursTime() {
    final timeHours = [
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
    ];

    return timeHours;
  }

  static List<String> getAllWeekDays() {
    final timeHours = [
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT',
      'SUN',
    ];

    return timeHours;
  }

  //create a list of bool up to 30 days having random bool values
  static List<bool> getBoolList() {
    final list = <bool>[];
    for (var i = 0; i < 30; i++) {
      list.add(i % 2 == 0);
    }
    return list;
  }

  static List<String> getAllMonthsISO3() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months;
  }

  static int getIntMonthFromString(String monthIso3) {
    return getAllMonthsISO3().indexOf(monthIso3) + 1;
  }

  static List<String> getAllWeekDaysFullNames() {
    return DayEnum.values.map((day) => day.day).toList();
  }

  static int daysInMonth(DateTime date) {
    final firstDayThisMonth = DateTime(date.year, date.month, date.day);
    final firstDayNextMonth = DateTime(
      firstDayThisMonth.year,
      firstDayThisMonth.month + 1,
      firstDayThisMonth.day,
    );
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  static DateTime firstDayTimeOfCurrentMonth(DateTime date) {
    final firstDayThisMonth = DateTime(date.year, date.month, date.day);
    return firstDayThisMonth;
  }

  static DateTime lastDayTimeOfCurrentMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0).day;

    final lastDayThisMonth = DateTime(date.year, date.month, lastDay);
    return lastDayThisMonth;
  }

  static String getDayViseDate({required int millis}) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    return date.isToday()
        ? 'Today'
        : date.isYesterday()
            ? 'Yesterday'
            : date.isTomorrow()
                ? 'Tomorrow'
                : DateFormat('dd MMM').format(date);
  }

  static String getDurationHourMinutes({required int d}) {
    final minutes = d;
    debugPrint('passed minutes:$minutes');
    if (minutes >= 60) {
      final hours = (minutes / 60).round();
      final remainMinutes = minutes % 60;
      if (remainMinutes > 0) {
        return '$hours Hours $remainMinutes minutes';
      } else {
        debugPrint('hours $hours');
        return '$hours Hours';
      }
    } else {
      debugPrint('minutes $minutes');
      return '$minutes Minutes';
    }
  }

  static String getDurationHourMinutesForLastMinutes({
    required int minutes,
    required String duration,
  }) {
    debugPrint('passed minutes: $minutes, duration: $duration');

    if (duration.toLowerCase() == 'hour') {
      final hours = minutes * 60;
      return '$hours Minutes';
    } else {
      return '$minutes Minutes';
    }
  }

  static String getTimeAgoFromMilliseconds(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return dateTime.timeAgo();
  }

  static String getTimeGapByMilliseconds({required int milliseconds}) {
    final currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    final remainMilliseconds = milliseconds - currentMilliseconds;

    if (remainMilliseconds < 0) {
      return 'Expired';
    } else {
      final duration = Duration(microseconds: remainMilliseconds);
      if (duration.inHours < 1) {
        return 'Starting Soon';
      } else {
        return 'Start on  ${duration.inHours}:${duration.inMinutes.remainder(60)}';
      }
    }
  }

  static bool isExpired({required int milliseconds}) {
    final currentMillies = DateTime.now().millisecondsSinceEpoch;
    final remainMillies = milliseconds - currentMillies;
    return remainMillies < 0;
  }

  static String getTime12HoursFromMillis({required int millies}) {
    final date = DateTime.fromMillisecondsSinceEpoch(millies);
    return DateFormat('hh:mm a').format(date);
  }
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool isTomorrow() {
    final yesterday = DateTime.now().add(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  int toDayOfYear() {
    final diff = difference(DateTime(year));
    final diffInDays = diff.inDays;
    return diffInDays;
  }

  DateTime fromDayOfYear(int dayOfYear) {
    final millisInADay = const Duration(days: 1).inMilliseconds; // 86400000
    final millisDayOfYear = dayOfYear * millisInADay;
    final millisecondsSinceEpoch =
        DateTime(DateTime.now().year).millisecondsSinceEpoch;
    return DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch + millisDayOfYear,
    );
  }

  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);
    if ((difference.inDays / 7).floor() >= 1) {
      return DateFormat(DateFormat.HOUR_MINUTE_TZ)
          .format(this); //(numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return numericDates ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return numericDates ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return numericDates ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
