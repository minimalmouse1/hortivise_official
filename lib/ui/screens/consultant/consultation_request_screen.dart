import 'package:flutter/material.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_outlined_button.dart';

class ConsultationRequestScreen extends StatelessWidget {
  const ConsultationRequestScreen({super.key});
  static const String routeName = 'consultationRequest';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: context.width,
            height: context.safeHeight,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Image.network(
                    'https://sb.kaleidousercontent.com/67418/1920x1545/c5f15ac173/samuel-raita-ridxdghg7pw-unsplash.jpg',
                    height: 300,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 2,
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 1,
                    constraints: const BoxConstraints(
                      minWidth: 26,
                      minHeight: 26,
                      maxWidth: 26,
                      maxHeight: 26,
                    ),
                    fillColor: AppColors.colorWhite.withAlpha(100),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 270,
                  bottom: 0,
                  child: Container(
                    padding: 16.allPadding,
                    decoration: const BoxDecoration(
                      color: AppColors.colorWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jane Smith',
                                  style: AppTextStyles.bodyStyleMedium
                                      .changeSize(16),
                                ),
                                Text(
                                  'Professional Florist',
                                  style: AppTextStyles.bodyStyle.changeSize(12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RawMaterialButton(
                                  onPressed: () {},
                                  elevation: 0,
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                    maxWidth: 36,
                                    maxHeight: 36,
                                  ),
                                  fillColor: AppColors.colorGreen.withAlpha(90),
                                  padding: const EdgeInsets.all(4),
                                  shape: const CircleBorder(),
                                  child: const Icon(
                                    AppIcons.ic_chat_outlined,
                                    size: 18,
                                    color: AppColors.colorGreen,
                                  ),
                                ),
                                Text(
                                  r'$45',
                                  style: AppTextStyles.bodyStyleMedium
                                      .changeSize(18)
                                      .changeColor(AppColors.colorBlack),
                                ),
                              ],
                            ),
                          ],
                        ),
                        15.height,
                        Text(
                          'Description',
                          style: AppTextStyles.bodyStyleMedium.changeSize(14),
                        ),
                        Text(
                          'Lorem ipsem dolor sit amet, consetetus sadipscing eltir, sed diam nounrmy wola krat grta. Lorem ipsem dolor sit amet, consetetus sadipscing eltir, sed diam nounrmy wola krat grta',
                          style: AppTextStyles.bodyStyle
                              .changeSize(11)
                              .changeFontWeight(FontWeight.w300),
                        ),
                        25.height,
                        Padding(
                          padding: 34.horizontalPadding,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_rounded,
                                        color: AppColors.colorGreen,
                                        size: 24,
                                      ),
                                      6.width,
                                      Text(
                                        'Today',
                                        style: AppTextStyles.bodyStyleMedium
                                            .changeSize(16)
                                            .changeColor(AppColors.colorBlack),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.access_time_rounded,
                                        color: AppColors.colorGreen,
                                        size: 24,
                                      ),
                                      6.width,
                                      Text(
                                        '06:30 PM',
                                        style: AppTextStyles.bodyStyleMedium
                                            .changeSize(16)
                                            .changeColor(AppColors.colorBlack),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              12.height,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.video_call_outlined,
                                        color: AppColors.colorGreen,
                                        size: 26,
                                      ),
                                      6.width,
                                      Text(
                                        'Video Call',
                                        style: AppTextStyles.bodyStyleMedium
                                            .changeSize(16)
                                            .changeColor(AppColors.colorBlack),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        AppIcons.ic_hourglass_time,
                                        color: AppColors.colorGreen,
                                        size: 20,
                                      ),
                                      6.width,
                                      Text(
                                        '30 Minute',
                                        style: AppTextStyles.bodyStyleMedium
                                            .changeSize(16)
                                            .changeColor(AppColors.colorBlack),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        12.height,
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Column(
                                  children: [
                                    AppFilledButton(
                                      onPress: () {},
                                      title: 'Accept',
                                    ),
                                    10.height,
                                    AppOutlinedButton(
                                      onPress: () {},
                                      title: 'Decline',
                                      btnColor: AppColors.colorGreen,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Widget widget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) {
        return widget;
      },
    );
  }
}
