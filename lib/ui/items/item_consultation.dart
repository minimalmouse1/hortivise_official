import 'package:flutter/material.dart';
import 'package:horti_vige/data/models/consultation/consultation_model.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';
import 'package:horti_vige/data/enums/package_type.dart';

class ItemConsultation extends StatelessWidget {
  const ItemConsultation({
    super.key,
    required this.isCustomer,
    required this.consultation,
    this.onItemClick,
  });
  final Function(ConsultationModel model)? onItemClick;
  final ConsultationModel consultation;
  final bool isCustomer;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Container(
      padding: 1.verticalPadding,
      child: InkWell(
        onTap: () => onItemClick!(consultation),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: AppColors.colorWhite,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    isCustomer
                        ? consultation.specialist.profileUrl
                        : consultation.customer.profileUrl,
                  ),
                  radius: 24,
                ),
                title: Text(
                  isCustomer
                      ? consultation.specialist.userName
                      : consultation.customer.userName,
                  style: AppTextStyles.titleStyle.changeSize(14),
                ),
                subtitle: Text(
                  isCustomer
                      ? consultation.specialist.specialist?.category.name ??
                          'N/A'
                      : 'Customer',
                  style: AppTextStyles.bodyStyle.changeSize(11),
                ),
                trailing: Text(
                  '\$${consultation.totalAmount.toStringAsFixed(2)}',
                  style: AppTextStyles.titleStyle.changeSize(14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.calendar_today_rounded,
                            size: 18,
                            color: AppColors.colorGreen,
                          ),
                        ),
                        const TextSpan(
                          text: ' ',
                          style: AppTextStyles.bodyStyle,
                        ),
                        TextSpan(
                          text: AppDateUtils.getDayViseDate(
                            millis:
                                consultation.startTime.millisecondsSinceEpoch,
                          ),
                          style: AppTextStyles.bodyStyle
                              .changeColor(AppColors.colorBlack)
                              .changeSize(12),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            AppIcons.ic_clock_time,
                            size: 18,
                            color: AppColors.colorGreen,
                          ),
                        ),
                        const TextSpan(
                          text: ' ',
                          style: AppTextStyles.bodyStyle,
                        ),
                        TextSpan(
                          text: AppDateUtils.getTime12HoursFromMillis(
                            millies:
                                consultation.startTime.millisecondsSinceEpoch,
                          ),
                          style: AppTextStyles.bodyStyle
                              .changeColor(AppColors.colorBlack)
                              .changeSize(12),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            AppIcons.ic_hourglass_time,
                            size: 18,
                            color: AppColors.colorGreen,
                          ),
                        ),
                        const TextSpan(
                          text: ' ',
                          style: AppTextStyles.bodyStyle,
                        ),
                        TextSpan(
                          text: consultation.durationTime > 0
                              ? AppDateUtils.getDurationHourMinutes(
                                  d: consultation.durationTime,
                                )
                              : consultation.title,
                          style: AppTextStyles.bodyStyle
                              .changeColor(AppColors.colorBlack)
                              .changeSize(12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              8.height,
              consultation.packageType == PackageType.text &&
                      (now.isAfter(consultation.startTime) &&
                          !now.isBefore(
                              consultation.startTime.add(Duration(hours: 1))))
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Expired',
                          style: AppTextStyles.bodyStyle
                              .changeSize(15)
                              .changeColor(AppColors.colorOrange),
                        ),
                      ),
                    )
                  : consultation.packageType == PackageType.video &&
                          (now.isAfter(consultation.startTime) &&
                              !now.isBefore(consultation.endTime))
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Expired',
                              style: AppTextStyles.bodyStyle
                                  .changeSize(15)
                                  .changeColor(AppColors.colorOrange),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
              8.height,
            ],
          ),
        ),
      ),
    );
  }
}
