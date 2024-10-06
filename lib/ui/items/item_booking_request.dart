import 'package:flutter/material.dart';
import 'package:horti_vige/data/enums/consultation_status.dart';
import 'package:horti_vige/data/models/consultation/consultation_model.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_outlined_button.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';

class ItemBookingRequest extends StatelessWidget {
  const ItemBookingRequest({
    super.key,
    required this.requestModel,
    this.onItemClick,
    required this.onItemAction,
  });
  final Function()? onItemClick;
  final Function(ConsultationStatus status, String id) onItemAction;
  final ConsultationModel requestModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 1.verticalPadding,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: AppColors.colorWhite,
        child: InkWell(
          onTap: onItemClick,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(requestModel.customer.profileUrl),
                  radius: 24,
                ),
                title: Text(
                  requestModel.customer.userName,
                  style: AppTextStyles.titleStyle.changeSize(14),
                ),
                subtitle: Text(
                  requestModel.customer.email,
                  style: AppTextStyles.bodyStyle.changeSize(11),
                ),
                trailing: Text(
                  '\$${requestModel.totalAmount}',
                  style: AppTextStyles.titleStyle.changeSize(14),
                ),
              ),
              Padding(
                padding: 12.horizontalPadding,
                child: Text(
                  requestModel.description,
                  style: AppTextStyles.bodyStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
              6.height,
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
                                requestModel.startTime.millisecondsSinceEpoch,
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
                                requestModel.startTime.millisecondsSinceEpoch,
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
                          text: requestModel.durationTime > 0
                              ? AppDateUtils.getDurationHourMinutes(
                                  d: requestModel.durationTime,
                                )
                              : requestModel.title,
                          style: AppTextStyles.bodyStyle
                              .changeColor(AppColors.colorBlack)
                              .changeSize(12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              16.height,
              Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      onPress: () {
                        onItemAction(
                          ConsultationStatus.rejected,
                          requestModel.id,
                        );
                      },
                      title: 'Decline',
                      btnColor: AppColors.appGreenMaterial,
                      height: 30,
                    ),
                  ),
                  Expanded(
                    child: AppFilledButton(
                      onPress: () {
                        onItemAction(
                          ConsultationStatus.accepted,
                          requestModel.id,
                        );
                      },
                      title: 'Accept',
                      height: 30,
                    ),
                  ),
                ],
              ),
              10.height,
            ],
          ),
        ),
      ),
    );
  }
}
