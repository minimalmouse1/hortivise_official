import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class ItemChoosePaymentMethod extends StatelessWidget {
  const ItemChoosePaymentMethod({
    super.key,
    required this.valueIndex,
    required this.selectedIndex,
    this.onValueSelect,
  });
  final int valueIndex;
  final int selectedIndex;
  final Function(int valueIndex)? onValueSelect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            value: valueIndex,
            groupValue: selectedIndex,
            onChanged: (selected) {
              onValueSelect!(selected!);
            },
          ),
          2.width,
          Image.network(
            'https://www.mastercard.com/content/dam/public/brandcenter/en/ma-bc_mastercard-logo_eq.png',
            width: 26,
            height: 26,
          ),
        ],
      ),
      title: Text(
        'MasterCard',
        style: AppTextStyles.titleStyle
            .changeSize(12)
            .changeFontWeight(FontWeight.w600),
      ),
      subtitle: Text(
        '•••• •••• •••• 1234',
        style: AppTextStyles.bodyStyle.changeSize(10),
      ),
    );
  }
}
