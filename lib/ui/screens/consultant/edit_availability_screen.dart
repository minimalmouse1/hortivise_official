import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
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

class EditAvailabilityScreen extends StatefulWidget {
  const EditAvailabilityScreen({super.key});
  static const routeName = 'editAvailability';

  @override
  State<EditAvailabilityScreen> createState() => _EditAvailabilityScreenState();
}

class _EditAvailabilityScreenState extends State<EditAvailabilityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AvailabilityProvider>().init();
    });
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
                  value: Constants.timeZones[0],
                  endIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.colorBlack,
                  ),
                  getLabel: (value) => value,
                  floatHint: false,
                  selectedItemStyle: AppTextStyles.bodyStyleMedium.changeColor(
                    AppColors.colorBlack,
                  ),
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
