import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.onPress,
    required this.title,
    required this.btnColor,
    this.height,
    this.allPadding,
  });
  final void Function() onPress;
  final String title;
  final Color btnColor;
  final double? height;
  final double? allPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: allPadding ?? 12.0),
      child: SizedBox(
        width: double.infinity,
        height: height ?? 45,
        child: OutlinedButton(
          onPressed: onPress,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: btnColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            title,
            style: AppTextStyles.buttonStyle
                .changeSize(16)
                .changeFontStyle(FontStyle.normal)
                .changeColor(btnColor),
          ),
        ),
      ),
    );
  }
}
