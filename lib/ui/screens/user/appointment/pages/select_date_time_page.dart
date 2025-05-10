import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/data/models/availability/availability.dart';
import 'package:horti_vige/data/models/consultation/consultation_model.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class SelectDateTimePage extends StatefulWidget {
  const SelectDateTimePage({
    super.key,
    required this.bookNowClick,
    required this.availability,
    required this.packages,
    required this.consultantEmail,
    this.existingConsultations = const [],
  });
  final Availability availability;
  final List<PackageModel> packages;
  final List<ConsultationModel> existingConsultations;
  final Function(DateTime selectedTime, PackageModel selectedPackage)
      bookNowClick;

  final String consultantEmail;
  @override
  State<SelectDateTimePage> createState() => _SelectDateTimePageState();
}

class _SelectDateTimePageState extends State<SelectDateTimePage> {
  int selected = 0;
  int selectedDay = DateTime.now().day;
  int selectedMonth = DateTime.now().month;
  int selectedHour = DateTime.now().hour;
  int selectedMinute = DateTime.now().minute;
  String consultantTimeZone = '';
  String patientTimeZone = '';
  bool gettingTimes = true;
  PackageModel? selectedPkg;
  List<String> selectableDays = [];

  List<String> availableTimes = [];
  List<PackageModel> packages = [];
  List<Map<String, dynamic>> consultations = []; // Store fetched consultations

  @override
  void initState() {
    super.initState();
    try {
      if (AppDateUtils.getNext30DaysOfYearWithMonth().values.isEmpty) return;

      // Get the selectable days from consultant availability
      selectableDays = widget.availability.days
          .map((e) => e.day.name.substring(0, 3).capitalizeFirstLetter())
          .toList();

      if (selectableDays.isEmpty) return;

      // Find the first available day in the next 30 days
      final data =
          AppDateUtils.getNext30DaysOfYearWithMonth().values.firstWhereOrNull(
                (ele) => selectableDays.any((day) => day == ele.split(',')[0]),
              );

      if (data == null) return;

      final day = data.split(',')[0].toLowerCase();
      final dayEnum = DayEnum.values.firstWhere(
        (element) => element.name.substring(0, 3) == day,
      );

      // Get the index of the found day
      final index =
          AppDateUtils.getNext30DaysOfYearWithMonth().values.toList().indexOf(
                data,
              );
      final dayIndex = int.parse(
        AppDateUtils.getNext30DaysOfYearWithMonth().keys.toList()[index],
      );

      // Update selected day and month
      selected = index;
      selectedDay = dayIndex;
      selectedMonth = AppDateUtils.getIntMonthFromString(
        data.split(',')[1].trim(),
      );

      // Delay loading times to ensure timezone data is loaded
      Future.delayed(const Duration(seconds: 2), () async {
        _selectTimes(dayEnum);
      });

      // Load packages
      Future.delayed(Duration.zero, () async {
        packages = await context.read<PackagesProvider>().getAllPackages();
      });
    } catch (e) {
      e.logError();
    }

    // Fetch existing consultations
    getConsultations();
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
                    (day) =>
                        day.toLowerCase() == ele.split(',')[0].toLowerCase(),
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
          gettingTimes
              ? const SizedBox.shrink()
              : Padding(
                  padding: 12.horizontalPadding,
                  child: Text(
                    availableTimes.isEmpty
                        ? 'No slot available for this date'
                        : 'Select a Time',
                    style: AppTextStyles.titleStyle.changeSize(14),
                  ),
                ),
          7.height,
          gettingTimes
              ? Text(
                  'Fetching Available Hours',
                  style: AppTextStyles.titleStyle.changeSize(14),
                )
              : availableTimes.isEmpty
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

  Map<String, String> timeZoneMapping = {
    'Etc/GMT-12': 'International Date Line West (GMT -12:00)',
    'Etc/GMT-11': 'Coordinated Universal Time -11 (GMT -11:00)',
    'Pacific/Honolulu': 'Hawaii (GMT -10:00)',
    'America/Anchorage': 'Alaska (GMT -9:00)',
    'America/Los_Angeles': 'Pacific Time (US & Canada) (GMT -8:00)',
    'America/Phoenix': 'Arizona (GMT -7:00)',
    'America/Denver': 'Mountain Time (US & Canada) (GMT -7:00)',
    'America/Chicago': 'Central Time (US & Canada) (GMT -6:00)',
    'America/Mexico_City': 'Mexico City (GMT -6:00)',
    'Canada/Saskatchewan': 'Saskatchewan (GMT -6:00)',
    'America/New_York': 'Eastern Time (US & Canada) (GMT -5:00)',
    'America/Lima': 'Lima (GMT -5:00)',
    'America/Bogota': 'Bogota (GMT -5:00)',
    'America/Caracas': 'Caracas (GMT -4:30)',
    'Canada/Atlantic': 'Atlantic Time (Canada) (GMT -4:00)',
    'America/Santiago': 'Santiago (GMT -4:00)',
    'America/La_Paz': 'La Paz (GMT -4:00)',
    'Canada/Newfoundland': 'Newfoundland (GMT -3:30)',
    'America/Sao_Paulo': 'Brasilia (GMT -3:00)',
    'America/Argentina/Buenos_Aires': 'Buenos Aires (GMT -3:00)',
    'America/Godthab': 'Greenland (GMT -3:00)',
    'Atlantic/South_Georgia': 'Mid-Atlantic (GMT -2:00)',
    'Atlantic/Cape_Verde': 'Cape Verde Islands (GMT -1:00)',
    'Atlantic/Azores': 'Azores (GMT -1:00)',
    'Europe/London': 'Dublin, Edinburgh, Lisbon, London (GMT +0:00)',
    'Africa/Monrovia': 'Monrovia (GMT +0:00)',
    'Africa/Casablanca': 'Casablanca (GMT +0:00)',
    'UTC': 'UTC (GMT +0:00)',
    'Europe/Belgrade':
        'Belgrade, Bratislava, Budapest, Ljubljana, Prague (GMT +1:00)',
    'Europe/Warsaw': 'Sarajevo, Skopje, Warsaw, Zagreb (GMT +1:00)',
    'Europe/Paris': 'Brussels, Copenhagen, Madrid, Paris (GMT +1:00)',
    'Europe/Berlin':
        'Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna (GMT +1:00)',
    'Africa/Lagos': 'West Central Africa (GMT +1:00)',
    'Europe/Athens': 'Athens, Bucharest, Istanbul (GMT +2:00)',
    'Europe/Helsinki':
        'Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius (GMT +2:00)',
    'Africa/Cairo': 'Cairo (GMT +2:00)',
    'Asia/Damascus': 'Damascus (GMT +2:00)',
    'Asia/Jerusalem': 'Jerusalem (GMT +2:00)',
    'Africa/Harare': 'Harare, Pretoria (GMT +2:00)',
    'Asia/Baghdad': 'Baghdad (GMT +3:00)',
    'Europe/Moscow': 'Moscow, St. Petersburg, Volgograd (GMT +3:00)',
    'Asia/Kuwait': 'Kuwait, Riyadh (GMT +3:00)',
    'Africa/Nairobi': 'Nairobi (GMT +3:00)',
    'Asia/Tehran': 'Tehran (GMT +3:30)',
    'Asia/Baku': 'Baku (GMT +4:00)',
    'Asia/Tbilisi': 'Tbilisi (GMT +4:00)',
    'Asia/Yerevan': 'Yerevan (GMT +4:00)',
    'Asia/Dubai': 'Dubai (GMT +4:00)',
    'Asia/Kabul': 'Kabul (GMT +4:30)',
    'Asia/Karachi': 'Pakistan Standard Time (GMT +5:00)',
    'Asia/Calcutta': 'Chennai, Kolkata, Mumbai, New Delhi (GMT +5:30)',
    'Asia/Colombo': 'Sri Jayawardenepura (GMT +5:30)',
    'Asia/Kathmandu': 'Kathmandu (GMT +5:45)',
    'Asia/Dhaka': 'Astana, Dhaka (GMT +6:00)',
    'Asia/Almaty': 'Almaty (GMT +6:00)',
    'Asia/Rangoon': 'Rangoon (GMT +6:30)',
    'Asia/Bangkok': 'Bangkok, Hanoi, Jakarta (GMT +7:00)',
    'Asia/Irkutsk': 'Novosibirsk (GMT +7:00)',
    'Asia/Shanghai': 'Beijing, Chongqing, Hong Kong, Urumqi (GMT +8:00)',
    'Asia/Singapore': 'Singapore (GMT +8:00)',
    'Australia/Perth': 'Perth (GMT +8:00)',
    'Asia/Taipei': 'Taipei (GMT +8:00)',
    'Asia/Ulaanbaatar': 'Ulaanbaatar (GMT +8:00)',
    'Asia/Tokyo': 'Osaka, Sapporo, Tokyo (GMT +9:00)',
    'Asia/Seoul': 'Seoul (GMT +9:00)',
    'Asia/Yakutsk': 'Yakutsk (GMT +9:00)',
    'Australia/Adelaide': 'Adelaide (GMT +9:30)',
    'Australia/Darwin': 'Darwin (GMT +9:30)',
    'Australia/Brisbane': 'Brisbane (GMT +10:00)',
    'Australia/Sydney': 'Canberra, Melbourne, Sydney (GMT +10:00)',
    'Australia/Hobart': 'Hobart (GMT +10:00)',
    'Pacific/Guam': 'Guam, Port Moresby (GMT +10:00)',
    'Asia/Vladivostok': 'Vladivostok (GMT +10:00)',
    'Pacific/Guadalcanal': 'Solomon Islands (GMT +11:00)',
    'Pacific/Noumea': 'New Caledonia (GMT +11:00)',
    'Asia/Magadan': 'Magadan (GMT +12:00)',
    'Pacific/Auckland': 'Auckland, Wellington (GMT +12:00)',
    'Pacific/Fiji': 'Fiji (GMT +12:00)',
    'Pacific/Tongatapu': 'Nuku\'alofa (GMT +13:00)',
    'Pacific/Samoa': 'Samoa (GMT +13:00)',
  };

// Function to reverse-map the time zone
  String getTimeZoneIdFromName(String humanReadableName) {
    return timeZoneMapping.entries
        .firstWhere((entry) => entry.value == humanReadableName,
            orElse: () => const MapEntry('UTC', 'UTC'))
        .key;
  }

  void _selectTimes(DayEnum day) {
    tz.initializeTimeZones();

    final from = widget.availability.days[day.index].from;
    final to = widget.availability.days[day.index].to;
    availableTimes = [];

    final fromHour = from.hour;
    final toHour = to.hour;
    String consultantTimeZoneId = getTimeZoneIdFromName(consultantTimeZone);
    String patientTimeZoneId = getTimeZoneIdFromName(patientTimeZone);
    final consultantTimeZone1 = tz.getLocation(consultantTimeZoneId);
    final patientTimeZone1 = tz.getLocation(patientTimeZoneId);

    final currentDateTime = DateTime.now();

    final isToday = selectedDay == currentDateTime.day &&
        selectedMonth == currentDateTime.month;

    for (var i = fromHour; i <= toHour; i++) {
      final hour = i.toString().padLeft(2, '0');
      final fromMin = from.minute;
      final toMin = to.minute;

      final minutes = List.generate(
        toMin - fromMin + 1,
        (index) => '$hour:${(fromMin + index).toString().padLeft(2, '0')}',
      ).toList();

      for (var time in minutes) {
        final hour = int.parse(time.split(':')[0]);
        final minute = int.parse(time.split(':')[1]);

        // Create date time with selected day and month (not current day/month)
        final selectedDateTimeConsultant = tz.TZDateTime(
          consultantTimeZone1,
          currentDateTime.year,
          selectedMonth, // Use the selected month
          selectedDay, // Use the selected day
          hour,
          minute,
        );

        final isFutureTime =
            !isToday || selectedDateTimeConsultant.isAfter(currentDateTime);
        final isNonOverlappingTime =
            !isTimeWithinConsultations(selectedDateTimeConsultant);

        if (isFutureTime && isNonOverlappingTime) {
          final selectedDateTimePatient =
              tz.TZDateTime.from(selectedDateTimeConsultant, patientTimeZone1);

          availableTimes.add(
              '${selectedDateTimePatient.hour.toString().padLeft(2, '0')}:${selectedDateTimePatient.minute.toString().padLeft(2, '0')}');
          // availableTimes.add(time);
        }
      }
    }

    if (availableTimes.isNotEmpty) {
      final firstAvailableTime = availableTimes.first;
      selectedHour = int.parse(firstAvailableTime.split(':')[0]);
      selectedMinute = int.parse(firstAvailableTime.split(':')[1]);
    } else {
      selectedHour = from.hour;
      selectedMinute = from.minute;
    }

    setState(() {
      gettingTimes = false;
    });
  }

  bool isTimeWithinConsultations(DateTime time) {
    // First check widget.existingConsultations that were passed from the ConsultantDetailsScreen
    for (var consultation in widget.existingConsultations) {
      if (consultation.status == ConsultationStatus.accepted ||
          consultation.status == ConsultationStatus.pending) {
        // Use the DateTime objects directly instead of parsing strings
        DateTime startDateTime = consultation.startTime;
        DateTime endDateTime = consultation.endTime;

        // Only check if the dates are the same day
        bool isSameDay = time.year == startDateTime.year &&
            time.month == startDateTime.month &&
            time.day == startDateTime.day;

        if (isSameDay &&
            (time.isAfter(startDateTime) && time.isBefore(endDateTime) ||
                time.isAtSameMomentAs(startDateTime) ||
                time.isAtSameMomentAs(endDateTime))) {
          return true;
        }
      }
    }

    // Also check any consultations fetched from Firebase
    for (var consultation in consultations) {
      DateTime startDateTime = DateTime.parse(consultation['startDateTime']);
      DateTime endDateTime = DateTime.parse(consultation['endDateTime']);

      // Only check if the dates are the same day
      bool isSameDay = time.year == startDateTime.year &&
          time.month == startDateTime.month &&
          time.day == startDateTime.day;

      if (isSameDay &&
          (time.isAfter(startDateTime) && time.isBefore(endDateTime) ||
              time.isAtSameMomentAs(startDateTime) ||
              time.isAtSameMomentAs(endDateTime))) {
        return true;
      }
    }
    return false;
  }

  Future<void> getConsultations() async {
    List<Map<String, dynamic>> results =
        await fetchConsultationsBySpecialistEmail(
            email: widget.consultantEmail);
    consultations = results;
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> fetchConsultationsBySpecialistEmail(
      {required String email}) async {
    try {
      String localTimeZone = await FlutterTimezone.getLocalTimezone();

      DocumentSnapshot userDocument =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();
      Map<String, dynamic>? userData =
          userDocument.data() as Map<String, dynamic>?;
      debugPrint("User Data: $userData");

      consultantTimeZone = userData!['timeZone'];
      String? matchedTimeZone = timeZoneMapping[localTimeZone];
      patientTimeZone = matchedTimeZone!;

      setState(() {});
      print('Patient Time Zone: $matchedTimeZone');
      debugPrint("Consultant Time Zone: $consultantTimeZone");
      CollectionReference consultationsCollection =
          FirebaseFirestore.instance.collection('Consultations');

      // Fetch all active consultations (accepted and pending), not just accepted ones
      QuerySnapshot querySnapshot = await consultationsCollection
          .where('specialist.email', isEqualTo: email)
          .where('status', whereIn: ['accepted', 'pending']).get();

      List<Map<String, dynamic>> consultations = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return {
          'id': doc.id,
          'title': data['title'] ?? 'N/A',
          'totalAmount': data['totalAmount'] ?? 0.0,
          'tax': data['tax'] ?? 0.0,
          'startDateTime': data['startDateTime'],
          'endDateTime': data['endDateTime'],
          'status': data['status'] ?? 'N/A',
          'packageType': data['packageType'] ?? 'N/A',
          'specialist': data['specialist'] ?? {},
          'customer': data['customer'] ?? {}
        };
      }).toList();
      setState(() {});
      debugPrint('${consultations}');
      return consultations;
    } catch (e) {
      print("Error fetching consultations: $e");
      setState(() {});
      return [];
    }
  }
}
