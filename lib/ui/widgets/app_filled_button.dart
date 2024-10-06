import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    super.key,
    required this.onPress,
    required this.title,
    this.horizontalPadding,
    this.isEnabled = true,
    this.endIcon,
    this.height,
    this.color,
    this.leftIcon,
    this.showLoading = false,
  });
  final void Function() onPress;
  final String title;
  final double? horizontalPadding;
  final Icon? endIcon;
  final double? height;
  final Color? color;
  final Icon? leftIcon;
  final bool isEnabled;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 12.0),
      child: SizedBox(
        width: double.infinity,
        height: height ?? 45,
        child: MaterialButton(
          onPressed: showLoading
              ? null
              : isEnabled
                  ? onPress
                  : null,
          onLongPress: isEnabled ? onPress : null,
          disabledElevation: 0,
          textTheme: ButtonTextTheme.primary,
          color: color ?? AppColors.colorGreen,
          disabledColor: AppColors.colorGrayLight,
          disabledTextColor: AppColors.colorWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: showLoading
              ? const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    leftIcon != null ? leftIcon! : 0.width,
                    leftIcon != null ? 4.width : 0.width,
                    Text(
                      title,
                      style: AppTextStyles.buttonStyle
                          .changeSize(16)
                          .changeFontStyle(FontStyle.normal),
                    ),
                    endIcon != null ? 2.width : 0.width,
                    endIcon != null ? endIcon! : 0.width,
                  ],
                ),
        ),
      ),
    );
  }
}
