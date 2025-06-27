import 'package:flutter/material.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class UserWalletPage extends StatefulWidget {
  const UserWalletPage({super.key});

  @override
  State<UserWalletPage> createState() => _UserWalletPageState();
}

class _UserWalletPageState extends State<UserWalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: AppTextStyles.titleStyle.changeSize(20),
        ),
        backgroundColor: AppColors.colorBeige,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: AppColors.colorGrayLight,
            ),
            16.height,
            Text(
              'Payment functionality is currently disabled',
              style: AppTextStyles.bodyStyleMedium
                  .copyWith(color: AppColors.colorGrayLight),
              textAlign: TextAlign.center,
            ),
            8.height,
            Text(
              'Stripe payment processing has been removed from this version',
              style: AppTextStyles.bodyStyle
                  .copyWith(color: AppColors.colorGrayLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
