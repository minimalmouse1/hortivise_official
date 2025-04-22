import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/data/models/consultation/consultation_model.dart';
import 'package:horti_vige/data/models/package/package_model.dart';
import 'package:horti_vige/providers/consultations_provider.dart';
import 'package:horti_vige/ui/dialogs/waiting_dialog.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_horizontal_choise_chips.dart';
import 'package:horti_vige/ui/widgets/app_outlined_button.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';
import 'package:provider/provider.dart';

class UpdateConsultationBottomDialog extends StatefulWidget {
  const UpdateConsultationBottomDialog({
    super.key,
    required this.consultation,
    required this.onConsultationUpdate,
  });
  final ConsultationModel consultation;
  final Function(ConsultationModel consultationModel) onConsultationUpdate;

  @override
  State<UpdateConsultationBottomDialog> createState() =>
      _UpdateConsultationBottomDialogState();
}

class _UpdateConsultationBottomDialogState
    extends State<UpdateConsultationBottomDialog> {
  int selectedDay = DateTime.now().day;
  int selectedMonth = DateTime.now().month;
  int selectedHour = DateTime.now().hour;
  int selectedMinute = DateTime.now().minute;
  late final selectableDays = widget.consultation.specialist.availability!.days
      .map((e) => e.day.name.substring(0, 3).capitalizeFirstLetter())
      .toList();
  List<String> availableTimes = [];
  int selected = 0;
  PackageModel? selectedPkg;

  @override
  void initState() {
    super.initState();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      widget.consultation.startTime.millisecondsSinceEpoch,
    );
    selectedDay = dateTime.day;
    selectedMonth = dateTime.month;
    selectedHour = dateTime.hour;
    selectedMinute = dateTime.minute;
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
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: 12.allPadding,
        decoration: const BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.height,
                Text(
                  'Pick a Date',
                  style: AppTextStyles.titleStyle.changeSize(14),
                ),
                7.height,
                AppHorizontalChoiceChips(
                  chips:
                      AppDateUtils.getNext30DaysOfYearWithMonth().keys.toList(),
                  onSelected: (index) {
                    final dayIndex = int.parse(
                      AppDateUtils.getNext30DaysOfYearWithMonth()
                          .keys
                          .toList()[index],
                    );
                    final values = AppDateUtils.getNext30DaysOfYearWithMonth()
                        .values
                        .toList();
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
                Text(
                  'Select a Time',
                  style: AppTextStyles.titleStyle.changeSize(14),
                ),
                7.height,
                AppHorizontalChoiceChips(
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
                25.height,
                AppFilledButton(
                  onPress: () {
                    final date = DateTime(
                      DateTime.now().year,
                      selectedMonth,
                      selectedDay,
                      selectedHour,
                      selectedMinute,
                    );
                    if (date.millisecondsSinceEpoch <=
                            DateTime.now().millisecondsSinceEpoch ||
                        widget.consultation.startTime.millisecondsSinceEpoch <=
                            DateTime.now().millisecondsSinceEpoch) {
                      context.showSnack(
                        message:
                            'Selected time is expire, please correct your time',
                      );
                    } else {
                      updateConsultation(date, selectedPkg, context);
                    }
                  },
                  title: 'Update',
                ),
                15.height,
                AppOutlinedButton(
                  onPress: () {
                    Navigator.pop(context);
                  },
                  title: 'Go Back',
                  btnColor: AppColors.appGreenMaterial,
                ),
                20.height,
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateConsultation(
    DateTime date,
    PackageModel? selectedPkg,
    BuildContext context,
  ) {
    final provider = Provider.of<ConsultationProvider>(context, listen: false);
    if (selectedPkg != null) {
      widget.consultation.packageId = selectedPkg.id;
      widget.consultation.title = selectedPkg.title;
      widget.consultation.totalAmount = selectedPkg.amount + provider.taxAmount;
      widget.consultation.tax = provider.taxAmount;
      if (selectedPkg.type == PackageType.video) {
        widget.consultation.durationTime = selectedPkg.duration;
      } else {
        widget.consultation.durationTime = 0;
      }
    }

    widget.consultation.startTime = date;
    widget.consultation.status = ConsultationStatus.pending;
    context.showProgressDialog(
      dialog: const WaitingDialog(status: 'Updating Consultation'),
    );
    provider
        .updateConsultationModel(
      consultationId: widget.consultation.id,
      model: widget.consultation,
    )
        .then((value) {
      Navigator.pop(context);
      widget.onConsultationUpdate(widget.consultation);
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
      context.showSnack(message: 'Something went wrong, $e');
    });
  }

  void _selectTimes(DayEnum day) {
    final days = widget.consultation.specialist.availability!.days;
    final from = days[day.index].from;
    final to = days[day.index].to;
    availableTimes = [];

    final fromHour = from.hour;
    final toHour = to.hour;

    for (var i = fromHour; i <= toHour; i++) {
      final hour = i.toString().padLeft(2, '0');

      final fromMin = from.minute;
      final toMin = to.minute;

      final minutes = List.generate(
        toMin - fromMin + 1,
        (index) => '$hour:${(fromMin + index).toString().padLeft(2, '0')}',
      ).toList();

      availableTimes.addAll(minutes);
    }

    selectedMinute = from.minute;
    selectedHour = from.hour;
    setState(() {});
  }
}
