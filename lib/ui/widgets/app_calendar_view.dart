import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore
class AppCalendarView extends StatefulWidget {
  const AppCalendarView({super.key, this.showHeader = false});
  final bool showHeader;

  @override
  State<AppCalendarView> createState() => _AppCalendarViewState();
}

class _AppCalendarViewState extends State<AppCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      headerVisible: widget.showHeader,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        leftChevronIcon: const Icon(
          Icons.chevron_left,
          color: AppColors.colorWhite,
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right,
          color: AppColors.colorWhite,
        ),
        titleTextStyle: AppTextStyles.titleStyle
            .changeSize(16)
            .changeFontWeight(FontWeight.normal)
            .changeColor(AppColors.colorWhite),
        titleCentered: true,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: AppTextStyles.bodyStyle.changeColor(AppColors.colorWhite),
        weekendStyle: AppTextStyles.bodyStyle.changeColor(AppColors.colorWhite),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        canMarkersOverflow: false,
        isTodayHighlighted: false,
        markerDecoration: const BoxDecoration(
          color: AppColors.colorOrange,
          shape: BoxShape.circle,
        ),
        todayTextStyle:
            AppTextStyles.bodyStyle.changeColor(AppColors.colorWhite),
        todayDecoration: BoxDecoration(
          color: AppColors.colorWhite.withAlpha(0),
          borderRadius: BorderRadius.circular(6),
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.circular(6),
        ),
        defaultDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        holidayDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        disabledDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        outsideDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        weekendDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        withinRangeDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        selectedTextStyle:
            AppTextStyles.bodyStyle.changeColor(AppColors.colorGreen),
        defaultTextStyle:
            AppTextStyles.bodyStyle.changeColor(AppColors.colorWhite),
        disabledTextStyle: AppTextStyles.bodyStyle
            .changeColor(AppColors.colorWhite.withAlpha(150)),
        weekendTextStyle:
            AppTextStyles.bodyStyle.changeColor(AppColors.colorWhite),
      ),
      firstDay: AppDateUtils.firstDayTimeOfCurrentMonth(DateTime.now()),
      lastDay: AppDateUtils.lastDayTimeOfCurrentMonth(DateTime.now()),
      focusedDay: _focusedDay,
      eventLoader: (day) {
        final events = <DateTime>[];
        events.add(DateTime(2023, 8, 22));
        events.add(DateTime(2023, 8, 27));
        events.add(DateTime(2023, 8, 29));
        events.add(DateTime(2023, 8, 29));
        return events.where((event) => isSameDay(event, day)).toList();
      },
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
    );
  }
}
