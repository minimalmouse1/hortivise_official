import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horti_vige/generated/assets.dart';
import 'package:horti_vige/ui/screens/greetings/congrats_screen.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});
  static const String routeName = 'ThankYou';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.colorBeige,
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
                      child: SvgPicture.asset(Assets.imagesIlsThankyou),
                    ),
                    25.height,
                    Text(
                      'Thank You',
                      style: AppTextStyles.titleStyle
                          .changeColor(AppColors.colorGreen)
                          .changeFontWeight(FontWeight.w500),
                    ),
                    25.height,
                    Padding(
                      padding: 12.horizontalPadding,
                      child: const Text(
                        'We have received your application. One of our team member will reach out to you soon on provided email.',
                        style: AppTextStyles.bodyStyle,
                      ),
                    ),
                    15.height,
                    const Text(
                      'Happy Planting:)',
                      style: AppTextStyles.bodyStyle,
                    ),
                    70.height,
                    AppFilledButton(
                      onPress: () {
                        Navigator.pushNamed(
                          context,
                          CongratsScreen.routeName,
                        );
                      },
                      title: 'Done!',
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
