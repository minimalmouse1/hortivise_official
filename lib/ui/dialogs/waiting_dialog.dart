import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class WaitingDialog extends StatelessWidget {
  const WaitingDialog({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.colorWhite,
      surfaceTintColor: AppColors.colorWhite,
      titlePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                backgroundColor: AppColors.colorGrayLight,
                color: AppColors.colorGreen,
                strokeWidth: 2.5,
                strokeCap: StrokeCap.round,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
            6.width,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.bodyStyleMedium
                      .changeSize(12)
                      .changeColor(AppColors.appGreenMaterial),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                Text(
                  'Please wait...',
                  textAlign: TextAlign.start,
                  style: AppTextStyles.bodyStyle
                      .changeSize(11)
                      .changeColor(AppColors.colorBlack),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
