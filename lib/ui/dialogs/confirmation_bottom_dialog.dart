import 'package:flutter/cupertino.dart';
import 'package:horti_vige/ui/resources/strings.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_outlined_button.dart';

class ConfirmationBottomDialog extends StatelessWidget {
  const ConfirmationBottomDialog({super.key, required this.onCancelClick});
  final Function() onCancelClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: 12.allPadding,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: AppColors.colorWhite,
      ),
      child: Wrap(
        children: [
          Column(
            children: [
              40.height,
              const Text(
                'Are you sure?',
                style: AppTextStyles.titleStyle,
              ),
              10.height,
              const Text(
                Strings.cancelationMessage,
                style: AppTextStyles.bodyStyle,
                textAlign: TextAlign.center,
              ),
              25.height,
              AppFilledButton(
                onPress: () {
                  Navigator.pop(context);
                  onCancelClick();
                },
                title: 'Yes, I want to Cancel',
                color: AppColors.colorRed,
              ),
              15.height,
              AppOutlinedButton(
                onPress: () {
                  Navigator.pop(context);
                },
                title: 'No',
                btnColor: AppColors.appGrayMaterial,
              ),
              20.height,
            ],
          ),
        ],
      ),
    );
  }
}
