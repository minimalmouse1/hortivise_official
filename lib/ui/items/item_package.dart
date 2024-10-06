import 'package:flutter/material.dart';
import 'package:horti_vige/data/models/package/package_model.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class ItemPackage extends StatelessWidget {
  const ItemPackage({super.key, required this.package});
  final PackageModel package;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          package.title,
          style: AppTextStyles.bodyStyle
              .changeColor(AppColors.colorBlack)
              .changeSize(14)
              .changeFontWeight(FontWeight.w500),
        ),
        Text(
          '\$${package.amount.toStringAsFixed(2)}',
          style: AppTextStyles.bodyStyle.changeColor(AppColors.colorBlack),
        ),
      ],
    );
  }
}
