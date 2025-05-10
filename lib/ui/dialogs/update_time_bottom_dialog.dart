import 'package:flutter/material.dart';

import 'package:horti_vige/core/utils/app_consts.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';
import 'package:horti_vige/providers/availability_provider.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_dropdown.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_on_days_radio_picker.dart';
import 'package:horti_vige/ui/widgets/app_simple_option_radios.dart';
import 'package:provider/provider.dart';

class UpdateTimeBottomDialog extends StatefulWidget {
  const UpdateTimeBottomDialog({
    super.key,
    required this.currentDay,
  });
  final SelectedDay currentDay;

  @override
  State<UpdateTimeBottomDialog> createState() => _UpdateTimeBottomDialogState();
}

class _UpdateTimeBottomDialogState extends State<UpdateTimeBottomDialog> {
  bool _isDefault = false;

  TimeOfDay _from = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _to = const TimeOfDay(hour: 18, minute: 0);

  @override
  void initState() {
    super.initState();
    _isDefault = widget.currentDay.isDefault;
    _setToFrom();
  }

  void _setToFrom() {
    _from = _isDefault
        ? context.read<AvailabilityProvider>().defaultFrom
        : widget.currentDay.from;
    _to = _isDefault
        ? context.read<AvailabilityProvider>().defaultTo
        : widget.currentDay.to;
  }

  @override
  Widget build(BuildContext context) {
    final initialSelection = _isDefault ? 0 : 1;

    return Container(
      padding: 12.allPadding,
      decoration: const BoxDecoration(
        color: AppColors.colorBeige,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Wrap(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      widget.currentDay.day.name,
                      style: AppTextStyles.titleStyle.changeSize(22),
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 0.20,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                      maxWidth: 24,
                      maxHeight: 24,
                    ),
                    fillColor: AppColors.colorGreen,
                    shape: const CircleBorder(),
                    child: const Icon(
                      AppIcons.ic_cross,
                      size: 10,
                      color: AppColors.colorWhite,
                    ),
                  ),
                ],
              ),
              5.height,
              AppSimpleOptionRadios(
                initialSelection: initialSelection,
                radioOptions: const [
                  'Use Default',
                  'Custom',
                ],
                onValueSelect: (selected, index) {
                  setState(() {
                    if (index == 0) {
                      _isDefault = true;
                    } else {
                      _isDefault = false;
                    }
                  });
                  _setToFrom();
                },
              ),
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
                            isDisabled: _isDefault,
                            options: Constants.getTimesString(),
                            value: Constants.timeOfDayFormat(_from),
                            endIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.colorBlack,
                            ),
                            getLabel: (value) => value,
                            floatHint: false,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _from = Constants.getTimes()
                                      .firstWhere(
                                        (element) =>
                                            element.timeString == value,
                                      )
                                      .time;
                                });
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
                            isDisabled: _isDefault,
                            options: Constants.getTimesString(),
                            value: Constants.timeOfDayFormat(_to),
                            endIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.colorBlack,
                            ),
                            getLabel: (value) => value,
                            floatHint: false,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _to = Constants.getTimes()
                                      .firstWhere(
                                        (element) =>
                                            element.timeString == value,
                                      )
                                      .time;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              15.height,
              // Show available hours
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.colorGreenLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Available: ${AppDateUtils.calculateHoursBetween(_from, _to)}',
                  style: AppTextStyles.bodyStyle
                      .changeFontWeight(FontWeight.w600)
                      .changeColor(AppColors.colorGreen),
                  textAlign: TextAlign.center,
                ),
              ),
              30.height,
              Consumer<AvailabilityProvider>(
                builder: (context, provider, child) => AppFilledButton(
                  onPress: () {
                    final selectedDay = SelectedDay(
                      from: _isDefault ? provider.defaultFrom : _from,
                      to: _isDefault ? provider.defaultTo : _to,
                      isDefault: _isDefault,
                      isSelected: true,
                      day: widget.currentDay.day,
                    );
                    Navigator.pop(context, selectedDay);
                  },
                  title: 'Done',
                ),
              ),
              20.height,
            ],
          ),
        ],
      ),
    );
  }
}
