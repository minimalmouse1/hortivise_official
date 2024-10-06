import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';

class AddCardBottomSheet extends StatefulWidget {
  const AddCardBottomSheet({super.key, required this.onSubmitCard});
  final Function(CardFieldInputDetails details) onSubmitCard;

  @override
  State<AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<AddCardBottomSheet> {
  CardFormEditController controller = CardFormEditController();

  bool _enabled = false;

  void update() => setState(() {});

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: AppColors.colorBeige,
      ),
      padding: 12.allPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          8.height,
          Text(
            'Add Your Card',
            style: AppTextStyles.titleStyle
                .changeSize(18)
                .changeColor(AppColors.colorBlack),
          ),
          15.height,
          CardFormField(
            autofocus: true,
            controller: controller,
            onCardChanged: (details) {
              setState(() {
                _enabled = details?.complete ?? false;
              });
            },
            style: CardFormStyle(
              backgroundColor: AppColors.colorGreen,
              borderRadius: 6,
              textColor: AppColors.colorWhite,
              textErrorColor: AppColors.colorRed,
              placeholderColor: AppColors.colorGrayLight,
            ),
          ),
          10.height,
          AppFilledButton(
            isEnabled: _enabled,
            onPress: () {
              widget.onSubmitCard(controller.details);
            },
            title: 'Add your Card',
          ),
          15.height,
        ],
      ),
    );
  }
}
