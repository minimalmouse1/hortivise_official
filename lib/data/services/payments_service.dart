import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:horti_vige/core/typedefs.dart';
import 'package:horti_vige/core/utils/app_consts.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentsService {
  Future<JsonMap> createPaymentIntent(
    double amount,
  ) async {
    try {
      //Request body
      final body = <String, dynamic>{
        'amount': calculateAmount(amount),
        'currency': 'USD',
        //'payment_method_types[]': '[card]',
        'setup_future_usage': 'off_session',
      };

      //Make post request to Stripe
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${Constants.kSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      response.body.log();
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  String calculateAmount(double amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toInt().toString();
  }

  Future<void> initPaymentSheet(
    JsonMap paymentIntent,
    String email,
    String userName,
  ) async {
    try {
      //STEP 2: Initialize Payment Sheet
      'Payment Intent ${paymentIntent['amount']}'.log();

      // final amount = int.tryParse(paymentIntent['amount']) ?? 0 / 100;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          setupIntentClientSecret: paymentIntent['client_secret'],
          customerId: paymentIntent['customer'],
          //provider.getCurrentUserId(),

          style: ThemeMode.system,
          allowsDelayedPaymentMethods: true,
          billingDetails: BillingDetails(
            email: email,
            name: userName,
          ),
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
            name: CollectionMode.automatic,
            email: CollectionMode.automatic,
            attachDefaultsToPaymentMethod: true,
          ),
          // googlePay: const PaymentSheetGooglePay(
          //     merchantCountryCode: 'AE', currencyCode: 'AED', testEnv: true),
          merchantDisplayName: ' HortiVise ',
          primaryButtonLabel: 'Pay \$${paymentIntent['amount'] / 100}',
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: AppColors.colorBeige,
              primary: AppColors.colorGreen,
              primaryText: AppColors.colorBlack,
              componentBackground: AppColors.colorGreen,
              secondaryText: AppColors.colorBlack,
              placeholderText: AppColors.colorWhite,
              componentText: AppColors.colorWhite,
              componentDivider: AppColors.colorBeige,
              icon: AppColors.colorGreen,
              componentBorder: AppColors.colorGreen,
            ),
            shapes: PaymentSheetShape(borderRadius: 24),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: AppColors.colorGreen,
                  text: AppColors.colorWhite,
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      e.logError();
    }
  }

  Future<String?> createCustomerEphemeralKeyFromId(
    String stripeId,
  ) async {
    try {
      final body = <String, dynamic>{
        'customer': stripeId,
      };

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/ephemeral_keys'),
        headers: {
          'Authorization': 'Bearer ${Constants.kSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Stripe-Version': '2023-08-16',
        },
        body: body,
      );
      response.body.log();
      return json.decode(response.body)['secret']; //['id'];
    } catch (err) {
      err.logError();
      throw Exception(err.toString());
    }
  }

  Future<bool> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      Stripe.instance.confirmPaymentSheetPayment().then((value) {
        debugPrint('present payment sheet confirm success');
        return true;
      }).onError((error, stackTrace) {
        debugPrint('some error when displaying sheet -> $error');
        throw Exception(error);
      });

      return true;
    } catch (e) {
      e.logError();
      return false;
    }
  }

  Future addCustomerPaymentMethod(CardFieldInputDetails details) async {
    try {
      //Request body
      final body = <String, dynamic>{
        'type': 'card',
        'card[number]': details.number,
        'card[exp_month]': details.expiryMonth,
        'card[exp_year]': details.expiryYear,
        'card[cvc]': details.cvc,
        'customer': 'customerId',
        // this filed need to validate to add customer card.
      };

      //Make post request to Stripe
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_methods'),
        headers: {
          'Authorization': 'Bearer ${Constants.kSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> paymentMethods() async {
    final stripe = Stripe.instance;
    // stripe.createPlatformPayPaymentMethod(params: params)
    stripe.confirmPaymentSheetPayment();
  }
}
