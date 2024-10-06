import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/extensions/validation_helpers.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_text_input.dart';

class SelectAmountBottomDialog extends StatefulWidget {
  const SelectAmountBottomDialog({
    super.key,
    required this.title,
    required this.onAmountEnter,
    this.buttonText,
  });
  final String title;

  final Function(int amount) onAmountEnter;

  final String? buttonText;

  @override
  State<SelectAmountBottomDialog> createState() =>
      _SelectAmountBottomDialogState();
}

class _SelectAmountBottomDialogState extends State<SelectAmountBottomDialog> {
  String _amount = '';
  String? _amountError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.colorBeige,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Wrap(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  widget.title,
                  style: AppTextStyles.titleStyle.changeSize(16),
                ),
              ),
              15.height,
              AppTextInput(
                hint: 'Enter your Amount',
                floatHint: false,
                suffixText: 'AED',
                keyboardType: TextInputType.number,
                errorText: _amountError,
                onUpdateInput: (value) {
                  _amount = value;
                  setState(() {
                    _amountError = isValidAmount(_amount);
                  });
                },
              ),
              30.height,
              AppFilledButton(
                onPress: () {
                  if (_amountError == null && _amount.isNotEmpty) {
                    widget.onAmountEnter(int.parse(_amount));
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      _amountError = isValidAmount(_amount);
                    });
                  }
                },
                title: widget.buttonText ?? 'Continue',
              ),
              20.height,
            ],
          ),
        ],
      ),
    );
  }
}
