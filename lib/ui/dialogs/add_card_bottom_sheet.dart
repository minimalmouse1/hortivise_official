// import 'package:flutter_stripe/flutter_stripe.dart'; // Removed Stripe import
import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_outlined_button.dart';

class AddCardBottomSheet extends StatefulWidget {
  const AddCardBottomSheet({
    super.key,
    required this.onSubmitCard,
  });

  final Function(Map<String, dynamic>) onSubmitCard;

  @override
  State<AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<AddCardBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 20.allPadding,
      decoration: const BoxDecoration(
        color: AppColors.colorWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.colorGrayLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          20.height,
          Text(
            'Add Payment Method',
            style: AppTextStyles.titleStyle.changeSize(20),
          ),
          20.height,
          // Removed Stripe card field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.colorGrayLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.colorGrayLight),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.credit_card_outlined,
                  color: AppColors.colorGrayLight,
                ),
                12.width,
                Text(
                  'Payment functionality is disabled',
                  style: AppTextStyles.bodyStyleMedium
                      .copyWith(color: AppColors.colorGrayLight),
                ),
              ],
            ),
          ),
          20.height,
          Row(
            children: [
              Expanded(
                child: AppOutlinedButton(
                  onPress: () {
                    Navigator.pop(context);
                  },
                  title: 'Cancel',
                  btnColor: AppColors.colorGrayLight,
                ),
              ),
              12.width,
              Expanded(
                child: AppFilledButton(
                  onPress: () {
                    // Removed Stripe card submission
                    // widget.onSubmitCard({
                    //   'last4': '1234',
                    //   'brand': 'visa',
                    // });
                    Navigator.pop(context);
                  },
                  title: 'Add Card',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
