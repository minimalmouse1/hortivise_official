import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class AppSimpleOptionRadios extends StatefulWidget {
  const AppSimpleOptionRadios({
    super.key,
    required this.radioOptions,
    required this.onValueSelect,
    this.initialSelection,
  });
  final List<String> radioOptions;
  final Function(String key, int index) onValueSelect;
  final int? initialSelection;

  @override
  State<AppSimpleOptionRadios> createState() => _AppSimpleOptionRadiosState();
}

class _AppSimpleOptionRadiosState extends State<AppSimpleOptionRadios> {
  var _selection = 0;
  @override
  void initState() {
    _selection = widget.initialSelection ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.radioOptions.length,
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        return Row(
          children: [
            Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (selected) {
                setState(() {
                  _selection = selected ?? 0;
                  widget.onValueSelect(
                    widget.radioOptions.elementAt(index),
                    index,
                  );
                });
              },
              toggleable: true,
              value: index,
              groupValue: _selection,
            ),
            5.width,
            Text(
              widget.radioOptions.elementAt(index),
              style: AppTextStyles.bodyStyle.changeColor(
                _selection == index
                    ? AppColors.colorGreen
                    : AppColors.colorBlack,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}
