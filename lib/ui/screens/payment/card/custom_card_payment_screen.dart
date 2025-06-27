// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:horti_vige/constants.dart';
// import 'package:flutter_stripe/flutter_stripe.dart'; // Removed Stripe import
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/ui/widgets/app_filled_button.dart';
import 'package:horti_vige/ui/widgets/app_outlined_button.dart';
import 'package:http/http.dart' as http;

class CustomCardPaymentScreen extends StatefulWidget {
  const CustomCardPaymentScreen({super.key});
  static const String routeName = 'CustomCardPayment';

  @override
  State<CustomCardPaymentScreen> createState() =>
      _CustomCardPaymentScreenState();
}

class _CustomCardPaymentScreenState extends State<CustomCardPaymentScreen> {
  // Removed Stripe card controller
  // CardFormEditController controller = CardFormEditController();
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    // Removed Stripe controller initialization
    // controller.addListener(update);
  }

  @override
  void dispose() {
    // Removed Stripe controller disposal
    // controller.removeListener(update);
    // controller.dispose();
    super.dispose();
  }

  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      appBar: AppBar(
        title: Text(
          'Payment',
          style: AppTextStyles.titleStyle.changeSize(20),
        ),
        backgroundColor: AppColors.colorBeige,
      ),
      body: Padding(
        padding: 12.allPadding,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.colorWhite,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Information',
                    style: AppTextStyles.titleStyle.changeSize(18),
                  ),
                  16.height,
                  // Removed Stripe card form
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment functionality is disabled',
                                style: AppTextStyles.bodyStyleMedium
                                    .copyWith(color: AppColors.colorGrayLight),
                              ),
                              4.height,
                              Text(
                                'Stripe payment processing has been removed',
                                style: AppTextStyles.bodyStyle
                                    .copyWith(color: AppColors.colorGrayLight),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.height,
                  Text(
                    'Security Note:',
                    style: AppTextStyles.bodyStyleMedium
                        .changeFontWeight(FontWeight.w600),
                  ),
                  8.height,
                  Text(
                    'Payment processing is currently disabled. In a production environment, ensure PCI compliance by following security guidelines.',
                    style: AppTextStyles.bodyStyle
                        .copyWith(color: AppColors.colorGrayLight),
                  ),
                ],
              ),
            ),
            const Spacer(),
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
                      // Removed Stripe payment processing
                      _showPaymentDisabledDialog();
                    },
                    title: 'Pay Now',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Disabled'),
        content: const Text(
          'Payment functionality has been removed from this version. Please contact support for payment options.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

// Removed all Stripe payment methods
/*
  Future<void> _processPayment() async {
    try {
      // Removed Stripe payment processing code
    } catch (e) {
      e.logError();
    }
  }
  */
}
