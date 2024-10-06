import 'package:flutter/material.dart';
import 'package:horti_vige/data/models/package/package_model.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class AppOptionRadios extends StatefulWidget {
  const AppOptionRadios({
    super.key,
    required this.radioOptions,
    required this.onValueSelect,
    this.selection,
  });
  final List<PackageModel> radioOptions;
  final Function(PackageModel key, int index) onValueSelect;
  final int? selection;

  @override
  State<AppOptionRadios> createState() => _AppOptionRadiosState();
}

class _AppOptionRadiosState extends State<AppOptionRadios> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.radioOptions[index].title,
              style: AppTextStyles.bodyStyleMedium
                  .changeFontWeight(FontWeight.w500)
                  .changeColor(
                    widget.selection == index
                        ? AppColors.colorGreen
                        : AppColors.colorBlack,
                  ),
            ),
            Row(
              children: [
                Text(
                  '\$${widget.radioOptions[index].amount}',
                  style: AppTextStyles.bodyStyle.changeColor(
                    widget.selection == index
                        ? AppColors.colorGreen
                        : AppColors.colorGray,
                  ),
                ),
                4.width,
                Radio(
                  activeColor: AppColors.colorGreen,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (selected) {
                    setState(() {
                      widget.onValueSelect(
                        widget.radioOptions[index],
                        index,
                      );
                    });
                  },
                  toggleable: true,
                  value: index,
                  groupValue: widget.selection,
                ),
              ],
            ),
          ],
        );
      },
      itemCount: widget.radioOptions.length,
    );
  }
}
