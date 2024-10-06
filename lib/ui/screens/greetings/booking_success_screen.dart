import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horti_vige/generated/assets.dart';
import 'package:horti_vige/ui/screens/greetings/congrats_screen.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});
  static const String routeName = 'BookingSuccess';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 25,
              child: Container(
                padding: 20.verticalPadding,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: AppColors.colorWhite,
                ),
                child: Column(
                  children: [
                    /*Sized box of illestration image*/
                    50.height,
                    SizedBox(
                      width: 130,
                      height: 200,
                      child: SvgPicture.asset(Assets.imagesIlsSuccess),
                    ),
                    15.height,
                    Text(
                      'Success',
                      style: AppTextStyles.titleStyle
                          .changeColor(AppColors.colorGreen)
                          .changeFontWeight(FontWeight.w500),
                    ),
                    25.height,
                    Padding(
                      padding: 16.horizontalPadding,
                      child: const Text(
                        "Your consultation request has been sent to Dr James Smith.\nWe'll notify you once it confirmed!",
                        style: AppTextStyles.bodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    120.height,
                    AppFilledButton(
                      onPress: () {
                        Navigator.pushNamed(
                          context,
                          CongratsScreen.routeName,
                        );
                      },
                      title: 'Awesome',
                    ),
                    15.height,
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'View Booking',
                        style: AppTextStyles.bodyStyleMedium
                            .changeColor(AppColors.colorBlack),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
