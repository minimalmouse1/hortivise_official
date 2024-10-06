import 'package:flutter/material.dart';
import 'package:horti_vige/data/enums/transaction_type.dart';
import 'package:horti_vige/data/models/transaction/transaction_model.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';

class ItemTransaction extends StatelessWidget {
  const ItemTransaction({super.key, required this.transactionModel});
  final TransactionModel transactionModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        transactionModel.type == TransactionType.TOPUP
            ? AppIcons.ic_arrow_up
            : AppIcons.ic_arrow_down,
        size: 18,
        color: transactionModel.type == TransactionType.TOPUP
            ? AppColors.colorGreen
            : AppColors.colorOrange,
      ),
      title: Row(
        children: [
          Text(
            transactionModel.title(),
            style: AppTextStyles.titleStyle.changeSize(14),
          ),
          4.width,
          Text(
            AppDateUtils.getTimeAgoFromMilliseconds(transactionModel.time),
            style: AppTextStyles.bodyStyle
                .changeColor(AppColors.colorGray)
                .changeSize(6),
          ),
        ],
      ),
      subtitle: Text(
        transactionModel.description,
        style: AppTextStyles.bodyStyle.changeColor(AppColors.colorGray),
      ),
      trailing: Text(
        '${transactionModel.amount.toStringAsFixed(2)} AED',
        style: AppTextStyles.titleStyle.changeSize(16),
      ),
    );
  }
}
