// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StripeController {
  factory StripeController() {
    return instance;
  }

  StripeController._internal();
  static final StripeController instance = StripeController._internal();

  String? _stripeId;
  String? _accountUrl;
  StripeStatus? _status;

  bool doneDialoge = false;

  Future<void> initStripe(String stripeId) async {
    _stripeId = stripeId;

    try {
      log(stripeId);

      await findAccountStatus();
      await findAccountUrl();
      log(_status.toString());
      log(_accountUrl.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  String? getAccountUrl() {
    return _accountUrl;
  }

  String? getAccountId() {
    return _stripeId;
  }

  StripeStatus? getStripeStatus() {
    return _status;
  }

  Future<void> createStripeAccount(String email) async {
    final callable = FirebaseFunctions.instance.httpsCallable(
      'createUser',
    );
    final results = await callable.call(
      {
        'email': email,
      },
    );
    _stripeId = results.data;
  }

  Future<void> findAccountUrl() async {
    final callable = FirebaseFunctions.instance.httpsCallable(
      'getAccountUrl',
    );
    final results = await callable.call(
      {
        'id': _stripeId.toString(),
      },
    );
    print(results.data);
    _accountUrl = results.data;
  }

  Future<void> findAccountStatus() async {
    final callable = FirebaseFunctions.instance.httpsCallable(
      'getAccountStatus',
    );
    final results = await callable.call(
      {
        'id': _stripeId,
      },
    );
    // print(results.data);

    final res = results.data;
    log(res);
    if (res == 'Error : undefined') {
      _status = StripeStatus.incomplete;
    } else {
      _status = StripeStatus.values
          .byName(results.data.toString().replaceAll(' ', ''));
    }
  }

  // void findStripeSttatus(BuildContext context) {
  //   if (doneDialoge) return;
  //   Future.delayed(const Duration(), () {
  //     doneDialoge = true;
  //     if (_stripeId == null) {
  //       _showAlertDialog(
  //         context,
  //         title: 'Stipe Account not found!',
  //         subTitle: 'Please contact admin for further detaisl',
  //         onCLick: () {
  //           Navigator.of(context).pop();
  //         },
  //       );
  //     }
  //     if (_status != StripeStatus.enabled) {
  //       _showAlertDialog(
  //         context,
  //         title: 'Stipe Account is Incomplete',
  //         subTitle: 'Please visit profile  to complete your stripe detials',
  //         onCLick: () {
  //           Navigator.of(context).pop();
  //         },
  //       );
  //     }
  //   });
  // }

  // void _showAlertDialog(
  //   BuildContext context, {
  //   required String title,
  //   required String subTitle,
  //   required Function onCLick,
  // }) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: Text(subTitle),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               onCLick();
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> uplaodTopUpDetails(
    String paymentId,
    String consultantStripeId,
    String consultationId,
  ) async {
    final callable = FirebaseFunctions.instance.httpsCallable(
      'uplaodConsultionData',
    );
    await callable.call(
      <String, dynamic>{
        'id': paymentId,
        'consultantStripeId': consultantStripeId,
        'consultationId': consultationId,
        'fromUserId': FirebaseAuth.instance.currentUser!.uid,
        'data': '',
      },
    );
    // log(results.data.toString());
    // final model = PaymentModel(
    //   consultationId: consultationId,
    //   data: DateTime.now(),
    //   amount:
    //       results.data['amount'] != null ? results.data['amount'] / 100 : 0.0,
    //   netAmount: results.data['net'] != null ? results.data['net'] / 100 : 0.0,
    //   stripeFee: results.data['fee'] != null ? results.data['fee'] / 100 : 0.0,
    //   exchangeRate: results.data['exchange_rate'] != null
    //       ? results.data['exchange_rate'] / 100
    //       : 0.0,
    //   fromUserId: FirebaseAuth.instance.currentUser!.uid,
    //   paymentIntentId: paymentId,
    //   transactionStripeId: results.data['id'],
    //   toStripeId: consultantStripeId,
    // );
    // await FirebaseFirestore.instance
    //     .collection('Paymnets')
    //     .add(
    //       model.toJson(),
    //     )
    //     .then(
    //       (value) => value.update(
    //         {
    //           'paymentId': value.id,
    //         },
    //       ),
    //     );
  }
}

enum StripeStatus {
  enabled,
  incomplete,
  pending,
  restricted,
}
