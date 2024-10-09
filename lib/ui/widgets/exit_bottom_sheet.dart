import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class ExitBottomSheet extends StatelessWidget {
  const ExitBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensures it takes only needed space
        children: [
          const Text(
            'Are you sure you want to exit?',
            textAlign: TextAlign.center, // Ensures the text is centered
            style:
                TextStyle(color: Colors.black), // Make sure the color isn't red
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _button(
                label: 'Exit',
                onTap: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                buttonColor: AppColors.colorGreen.withOpacity(0.6),
              ),
              _button(
                label: 'Cancel',
                onTap: () {
                  Navigator.of(context).pop();
                },
                buttonColor: AppColors.colorGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _button({
    required String label,
    required Function() onTap,
    required Color buttonColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 100,
        height: 40,
        child: Text(
          label,
          textAlign: TextAlign.center, // Center text inside the button
          style: AppTextStyles.bodyStyle
              .changeColor(AppColors.colorWhite)
              .changeSize(15)
              .changeFontWeight(FontWeight.w700),
        ),
      ),
    );
  }
}
