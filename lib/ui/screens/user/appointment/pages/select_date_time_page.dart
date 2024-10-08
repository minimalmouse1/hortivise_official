import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:horti_vige/data/enums/days.dart';
import 'package:horti_vige/data/models/availability/availability.dart';

import 'package:horti_vige/data/models/package/package_model.dart';
import 'package:horti_vige/providers/packages_provider.dart';
import 'package:horti_vige/ui/screens/user/appointment/sub/service_selector.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_horizontal_choise_chips.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';
import 'package:provider/provider.dart';

class SelectDateTimePage extends StatefulWidget {
  const SelectDateTimePage({
    super.key,
    required this.bookNowClick,
    required this.availability,
    required this.packages,
  });
  final Availability availability;
  final List<PackageModel> packages;
  final Function(DateTime selectedTime, PackageModel selectedPackage)
      bookNowClick;

  @override
  State<SelectDateTimePage> createState() => _SelectDateTimePageState();
}

class _SelectDateTimePageState extends State<SelectDateTimePage> {
  int selected = 0;

  int selectedDay = DateTime.now().day;
  int selectedMonth = DateTime.now().month;
  int selectedHour = DateTime.now().hour;
  int selectedMinute = DateTime.now().minute;
  PackageModel? selectedPkg;
  late final selectableDays = widget.availability.days
      .map((e) => e.day.name.substring(0, 3).capitalizeFirstLetter())
      .toList();

  List<String> availableTimes = [];
  List<PackageModel> packages = [];

  @override
  void initState() {
    super.initState();
    try {
      if (AppDateUtils.getNext30DaysOfYearWithMonth().values.isEmpty) return;
      final data =
          AppDateUtils.getNext30DaysOfYearWithMonth().values.firstWhereOrNull(
                (ele) => selectableDays.any((day) => day == ele.split(',')[0]),
              );

      if (data == null) return;

      final day = data.split(',')[0].toLowerCase();
      final dayEum = DayEnum.values.firstWhere(
        (element) => element.name.substring(0, 3) == day,
      );
      _selectTimes(dayEum);
      Future.delayed(Duration.zero, () async {
        packages = await context.read<PackagesProvider>().getAllPackages();
      });

      final index =
          AppDateUtils.getNext30DaysOfYearWithMonth().values.toList().indexOf(
                data,
              );
      final dayIndex = int.parse(
        AppDateUtils.getNext30DaysOfYearWithMonth().keys.toList()[index],
      );
      selected = index;
      selectedDay = dayIndex;
    } catch (e) {
      e.logError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.height,
          Padding(
            padding: 12.horizontalPadding,
            child: Text(
              'Pick a Date',
              style: AppTextStyles.titleStyle.changeSize(14),
            ),
          ),
          7.height,
          AppHorizontalChoiceChips(
            chips: AppDateUtils.getNext30DaysOfYearWithMonth().keys.toList(),
            onSelected: (index) {
              final dayIndex = int.parse(
                AppDateUtils.getNext30DaysOfYearWithMonth()
                    .keys
                    .toList()[index],
              );
              final values =
                  AppDateUtils.getNext30DaysOfYearWithMonth().values.toList();
              final month = AppDateUtils.getIntMonthFromString(
                values[index].split(',')[1].trim(),
              );

              selectedDay = dayIndex;
              selectedMonth = month;
              final day = values[index].split(',')[0].toLowerCase();
              final dayEum = DayEnum.values.firstWhere(
                (element) => element.name.substring(0, 3) == day,
              );
              _selectTimes(dayEum);
            },
            selected: selected,
            cornerRadius: 2,
            selectAbleList: AppDateUtils.getNext30DaysOfYearWithMonth()
                .values
                .map(
                  (ele) => selectableDays.any(
                    (day) => day == ele.split(',')[0],
                  ),
                )
                .toList(),
            selectedChipColor: AppColors.appGreenMaterial,
            selectedLabelColor: AppColors.colorWhite,
            unSelectedLabelColor: AppColors.colorGray,
            subLabel: AppDateUtils.getNext30DaysOfYearWithMonth()
                .values
                .map((e) => e.split(',')[1])
                .toList(),
            horizontalPadding: 12,
          ),
          25.height,
          Padding(
            padding: 12.horizontalPadding,
            child: Text(
              availableTimes.isEmpty
                  ? 'No slot available for this date'
                  : 'Select a Time',
              style: AppTextStyles.titleStyle.changeSize(14),
            ),
          ),
          7.height,
          availableTimes.isEmpty
              ? const SizedBox.shrink()
              : AppHorizontalChoiceChips(
                  chips: availableTimes,
                  defaultSelection: const [],
                  onSelected: (index) {
                    final selectedTime = availableTimes[index];
                    final hour = int.parse(selectedTime.split(':')[0]);
                    final minutes = int.parse(selectedTime.split(':')[1]);
                    selectedHour = hour;
                    selectedMinute = minutes;
                    debugPrint(
                        'selected hour:$selectedHour and selectedMinute:$selectedMinute');
                    debugPrint('availableTimes:$availableTimes');
                  },
                  cornerRadius: 2,
                  selectedChipColor: AppColors.appGreenMaterial,
                  selectedLabelColor: AppColors.colorWhite,
                  unSelectedLabelColor: AppColors.colorGray,
                  horizontalPadding: 8,
                ),
          10.height,
          Padding(
            padding: 12.horizontalPadding,
            child: Text(
              'Service Details',
              style: AppTextStyles.titleStyle.changeSize(14),
            ),
          ),
          ServiceSelector(
            packages: widget.packages,
            onPackageSelect: (selected) {
              selectedPkg = selected;
            },
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: AppFilledButton(
                    endIcon: const Icon(Icons.arrow_forward_rounded),
                    isEnabled: widget.availability.days.isNotEmpty,
                    onPress: () {
                      if (selectedPkg == null) {
                        context.showSnack(
                          message: 'Please select package first to continue',
                        );
                      } else {
                        final date = DateTime(
                          DateTime.now().year,
                          selectedMonth,
                          selectedDay,
                          selectedHour,
                          selectedMinute,
                        );

                        if (date.isBefore(DateTime.now()) ||
                            date.isAtSameMomentAs(DateTime.now())) {
                          context.showSnack(
                            message: 'Please select valid date and time',
                          );
                          return;
                        }
                        print('while sending ${date.month} , ${date.day}');
                        print('Millies -> ${date.millisecondsSinceEpoch}');

                        widget.bookNowClick(date, selectedPkg!);
                      }
                    },
                    title: 'Proceed',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectTimes(DayEnum day) {
    final from = widget.availability.days[day.index].from;
    final to = widget.availability.days[day.index].to;
    availableTimes = [];

    final fromHour = from.hour;
    final toHour = to.hour;

    // Get the current date and time
    final currentDateTime = DateTime.now();

    // Check if the selected date is today
    final isToday = selectedDay == currentDateTime.day &&
        selectedMonth == currentDateTime.month;

    for (var i = fromHour; i <= toHour; i++) {
      final hour = i.toString().padLeft(2, '0');

      final fromMin = from.minute;
      final toMin = to.minute;

      // Generate minutes for this hour
      final minutes = List.generate(
        toMin - fromMin + 1,
        (index) => '$hour:${(fromMin + index).toString().padLeft(2, '0')}',
      ).toList();

      // Add times to availableTimes if they are in the future
      for (var time in minutes) {
        final hour = int.parse(time.split(':')[0]);
        final minute = int.parse(time.split(':')[1]);

        final selectedDateTime = DateTime(
          currentDateTime.year,
          selectedMonth,
          selectedDay,
          hour,
          minute,
        );

        // Add time if it is either not today, or it is today and in the future
        if (!isToday || selectedDateTime.isAfter(currentDateTime)) {
          availableTimes.add(time);
        }
      }
    }

    // Set default selected hour and minute to the first available time
    if (availableTimes.isNotEmpty) {
      final firstAvailableTime = availableTimes.first;
      selectedHour = int.parse(firstAvailableTime.split(':')[0]);
      selectedMinute = int.parse(firstAvailableTime.split(':')[1]);
    } else {
      selectedHour = from.hour;
      selectedMinute = from.minute;
    }

    setState(() {});
    debugPrint('time:$availableTimes');
  }
}
