import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:horti_vige/data/database/collection_refs.dart';
import 'package:provider/provider.dart';

import 'package:horti_vige/core/utils/app_consts.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';
import 'package:horti_vige/data/models/availability/day_availability.dart';
import 'package:horti_vige/providers/availability_provider.dart';
import 'package:horti_vige/providers/user_provider.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_dropdown.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_on_days_radio_picker.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAvailabilityScreen extends StatefulWidget {
  const EditAvailabilityScreen({super.key});
  static const routeName = 'editAvailability';

  @override
  State<EditAvailabilityScreen> createState() => _EditAvailabilityScreenState();
}

class _EditAvailabilityScreenState extends State<EditAvailabilityScreen> {
  List<String> timeZones = Constants.timeZones;
  String? selectedTimeZone;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AvailabilityProvider>().init();
    });
    _setUserTimeZone();
  }

  Future<void> _setUserTimeZone() async {
    try {
      String localTimeZone =
          await FlutterTimezone.getLocalTimezone(); // e.g., Asia/Karachi
      print('Local time zone: $localTimeZone');

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

      // Find the matching value from your dropdown
      String? matchedTimeZone = timeZoneMapping[localTimeZone];
      SharedPreferences sf = await SharedPreferences.getInstance();
      if (sf.containsKey('timeZone')) {
        setState(() {
          selectedTimeZone = sf.getString('timeZone'); // Fallback to default
        });
      } else {
        setState(() {
          selectedTimeZone =
              matchedTimeZone ?? timeZones[0]; // Fallback to default
        });
      }

      print('Time Zone: $selectedTimeZone');
    } catch (e) {
      print('Error getting time zone: $e');
      setState(() {
        selectedTimeZone = timeZones[0]; // Fallback to default value
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      appBar: AppBar(
        backgroundColor: AppColors.colorWhite,
        shadowColor: AppColors.colorWhite,
        title: const Text('Edit Availability'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(AppIcons.ic_back_ios),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Consumer<AvailabilityProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                10.height,
                Padding(
                  padding: 12.horizontalPadding,
                  child: Text(
                    'I am available:',
                    style: AppTextStyles.bodyStyleMedium.changeSize(18),
                  ),
                ),
                12.height,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: 16.horizontalPadding,
                            child: const Text(
                              'From',
                              style: AppTextStyles.bodyStyle,
                            ),
                          ),
                          2.height,
                          Flexible(
                            child: AppDropdownInput(
                              hint: 'Time',
                              fieldHeight: 50,
                              options: Constants.getTimesString(),
                              value: Constants.timeOfDayFormat(
                                provider.defaultFrom,
                              ),
                              endIcon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.colorBlack,
                              ),
                              getLabel: (value) => value,
                              floatHint: false,
                              onChanged: (value) {
                                if (value != null) {
                                  provider.availability =
                                      provider.availability.copyWith(
                                    defaultFrom: Constants.getTimes()
                                        .firstWhere(
                                          (element) =>
                                              element.timeString == value,
                                        )
                                        .time,
                                  );
                                  provider.defaultFrom =
                                      provider.availability.defaultFrom;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: 16.horizontalPadding,
                            child: const Text(
                              'To',
                              style: AppTextStyles.bodyStyle,
                            ),
                          ),
                          2.height,
                          Flexible(
                            child: AppDropdownInput(
                              hint: 'Time',
                              fieldHeight: 50,
                              options: Constants.getTimesString(),
                              value: Constants.timeOfDayFormat(
                                provider.defaultTo,
                              ),
                              endIcon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.colorBlack,
                              ),
                              getLabel: (value) => value,
                              floatHint: false,
                              onChanged: (value) {
                                if (value != null) {
                                  provider.availability =
                                      provider.availability.copyWith(
                                    defaultTo: Constants.getTimes()
                                        .firstWhere(
                                          (element) =>
                                              element.timeString == value,
                                        )
                                        .time,
                                  );
                                  provider.defaultTo =
                                      provider.availability.defaultTo;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                12.height,
                AppDropdownInput(
                  hint: 'Time Zone',
                  fieldHeight: 50,
                  options: Constants.timeZones,
                  value: selectedTimeZone,
                  endIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.colorBlack,
                  ),
                  getLabel: (val) {
                    // print("time selected :$val");
                    return val;
                  },
                  floatHint: false,
                  selectedItemStyle: AppTextStyles.bodyStyleMedium.changeColor(
                    AppColors.colorBlack,
                  ),
                  onChanged: (val) async {
                    SharedPreferences sf =
                        await SharedPreferences.getInstance();
                    setState(() {
                      selectedTimeZone = val;
                    });
                    sf.setString('timeZone', selectedTimeZone!);
                  },
                ),
                15.height,
                Padding(
                  padding: 12.horizontalPadding,
                  child: Text(
                    'On Days:',
                    style: AppTextStyles.bodyStyleMedium.changeSize(18),
                  ),
                ),
                8.height,
                OnDayChecks(
                  from: provider.defaultFrom,
                  to: provider.defaultTo,
                  radioOptions: AppDateUtils.getAllWeekDaysFullNames(),
                  days: provider.availability.days,
                  onSelectionsUpdate: (selectedDays) {
                    final days = selectedDays
                        .map(
                          (e) => DayAvailability(
                            isDefault: e.isDefault,
                            from: e.isDefault ? provider.defaultFrom : e.from,
                            to: e.isDefault ? provider.defaultTo : e.to,
                            day: e.day,
                          ),
                        )
                        .toList();
                    provider.availability = provider.availability.copyWith(
                      days: days,
                    );
                  },
                ),
                10.height,
                Padding(
                  padding: 12.horizontalPadding,
                  child: AppFilledButton(
                    title: 'Update Availability',
                    onPress: () async {
                      if (provider.availability.days.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Please select at least 1 day',
                        );
                        return;
                      }
                      provider.availability.toJson().log();
                      await context.read<UserProvider>().updateUser(
                            model: provider.user!.copyWith(
                              availability: provider.availability,
                            ),
                          );
                      CollectionRefs.users.doc(provider.user!.email);
                      try {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(provider.user!.email)
                            .set(
                          {'timeZone': selectedTimeZone},
                          SetOptions(merge: true),
                        );
                        SharedPreferences sf =
                            await SharedPreferences.getInstance();

                        sf.setString('timeZone', selectedTimeZone!);
                      } catch (e) {
                        debugPrint('time zone error :${e.toString()}');
                      }
                      Fluttertoast.showToast(msg: 'Availability Updated');
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                20.height,
              ],
            ),
          );
        },
      ),
    );
  }
}
