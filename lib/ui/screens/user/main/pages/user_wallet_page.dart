import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:horti_vige/providers/wallet_provider.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/dialogs/waiting_dialog.dart';
import 'package:horti_vige/ui/items/item_transaction.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:provider/provider.dart';

class UserWalletPage extends StatefulWidget {
  const UserWalletPage({super.key});

  @override
  State<UserWalletPage> createState() => _UserWalletPageState();
}

class _UserWalletPageState extends State<UserWalletPage> {
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.colorWhite,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 24),
            child: AppBar(
              backgroundColor: AppColors.colorBeige,
              title: const Text('Wallet'),
            ),
          ),
          body: const Stack(),
        ),
        Positioned(
          top: kToolbarHeight,
          left: 0,
          right: 0,
          child: Padding(
            padding: 12.allPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  surfaceTintColor: AppColors.colorGreen,
                  color: AppColors.colorGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 18,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total money you Earned',
                              style: AppTextStyles.bodyStyle
                                  .changeFontWeight(FontWeight.w600)
                                  .changeSize(12)
                                  .changeColor(AppColors.colorWhite),
                            ),
                          ],
                        ),
                        Text(
                          '${walletProvider.currentUserBalance.toStringAsFixed(2)} USD',
                          style: AppTextStyles.bodyStyleLarge
                              .changeSize(20)
                              .changeColor(AppColors.colorWhite),
                        ),
                        // Column(
                        //   children: [
                        //     InkWell(
                        //       onTap: () async {
                        //         context.showBottomSheet(
                        //           dismissible: true,
                        //           bottomSheet: SelectAmountBottomDialog(
                        //             title: 'Select Amount',
                        //             onAmountEnter: (amount) async {
                        //               await makePayment(
                        //                 walletProvider,
                        //                 amount,
                        //               );
                        //             },
                        //           ),
                        //         );
                        //         //
                        //         // Navigator.pushNamed(context, CustomCardPaymentScreen.routeName);
                        //       },
                        //       child: RichText(
                        //         text: TextSpan(
                        //           children: [
                        //             const WidgetSpan(
                        //               alignment: PlaceholderAlignment.middle,
                        //               child: Icon(
                        //                 AppIcons.ic_wallet_plus_outlined,
                        //                 size: 18,
                        //                 color: AppColors.colorWhite,
                        //               ),
                        //             ),
                        //             TextSpan(
                        //               text: ' Top Up',
                        //               style: AppTextStyles.bodyStyle
                        //                   .changeColor(
                        //                     AppColors.colorWhite,
                        //                   )
                        //                   .changeFontWeight(
                        //                     FontWeight.w500,
                        //                   )
                        //                   .changeSize(11),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     12.height,
                        //     InkWell(
                        //       onTap: () {
                        //         context.showBottomSheet(
                        //           dismissible: true,
                        //           bottomSheet: SelectAmountBottomDialog(
                        //             title: 'Select Withdraw Amount',
                        //             buttonText: 'Withdraw',
                        //             onAmountEnter: (amount) async {
                        //               withdrawAmount(
                        //                 walletProvider,
                        //                 amount,
                        //               );
                        //             },
                        //           ),
                        //         );
                        //       },
                        //       child: RichText(
                        //         text: TextSpan(
                        //           children: [
                        //             const WidgetSpan(
                        //               alignment: PlaceholderAlignment.middle,
                        //               child: Icon(
                        //                 AppIcons.ic_arrow_up,
                        //                 size: 12,
                        //                 color: AppColors.colorWhite,
                        //               ),
                        //             ),
                        //             WidgetSpan(child: 2.width),
                        //             TextSpan(
                        //               text: ' Withdraw',
                        //               style: AppTextStyles.bodyStyle
                        //                   .changeColor(
                        //                     AppColors.colorWhite,
                        //                   )
                        //                   .changeFontWeight(
                        //                     FontWeight.w500,
                        //                   )
                        //                   .changeSize(14),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                10.height,
                // Row(
                //   mainAxisSize: MainAxisSize.max,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Payment Methods",
                //       style: AppTextStyles.titleStyle.changeSize(16),
                //     ),
                //     TextButton(
                //         onPressed: () {
                //           // context.showBottomSheet(
                //           //     bottomSheet: AddCardBottomSheet(
                //           //       onSubmitCard: (details) {
                //           //
                //           //         // `TODO`: save this card in current customer payment methods
                //           //
                //           //         //............................................
                //           //         print(details.last4);
                //           //         Navigator.pop(context);
                //           //       },
                //           //     ),
                //           //     dismissible: true);
                //         },
                //         child: Text(
                //           "Change",
                //           style: AppTextStyles.bodyStyle
                //               .changeColor(AppColors.colorGreen),
                //         ))
                //   ],
                // ),
                // ListTile(
                //   leading: Image.network(
                //     "https://www.mastercard.com/content/dam/public/brandcenter/en/ma-bc_mastercard-logo_eq.png",
                //     width: 22,
                //     height: 22,
                //   ),
                //   title: Text(
                //     "MasterCard",
                //     style: AppTextStyles.titleStyle.changeSize(14),
                //   ),
                //   subtitle: Text(
                //     "•••• •••• •••• 1234",
                //     style: AppTextStyles.bodyStyle.changeSize(11),
                //   ),
                // ),
                //  0.5.heightDivide,
                4.height,
                Align(
                  child: Text(
                    'Transactions',
                    style: AppTextStyles.bodyStyle
                        .changeColor(AppColors.colorGray)
                        .changeSize(10),
                  ),
                ),
                5.height,
                Padding(
                  padding: 4.horizontalPadding,
                  child: StreamBuilder(
                    stream: walletProvider.streamMyTransactions(),
                    builder: (ctx, snapshots) {
                      switch (snapshots.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppColors.colorGreen,
                              backgroundColor: AppColors.colorGrayLight,
                            ),
                          );
                        default:
                          if (snapshots.hasError) {
                            return const Center(
                              child: Text(
                                'Something went wrong when connecting to server, please try again later!',
                              ),
                            );
                          } else {
                            final transactions = snapshots.data!;
                            if (transactions.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      AppIcons.notificatins_filled,
                                      size: 48,
                                      color: AppColors.colorGreen,
                                    ),
                                    5.height,
                                    const Text(
                                      'No Transaction Found Yet!',
                                      style: AppTextStyles.bodyStyleMedium,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ListView.separated(
                              itemCount: transactions.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return ItemTransaction(
                                  transactionModel: transactions[index],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Padding(
                                  padding: 16.horizontalPadding,
                                  child: const Divider(
                                    height: 0.5,
                                    color: AppColors.colorGrayBg,
                                  ),
                                );
                              },
                            );
                          }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> makePayment(WalletProvider provider, int amount) async {
    try {
      paymentIntent = await provider.makePayment(amount.toDouble(), 'USD');

      if (paymentIntent == null) return;
      //STEP 3: Display Payment sheet
      final String id = paymentIntent!['id'];
      print('payment intent id -> $id');
      displayPaymentSheet(provider, paymentIntent!['id'], amount);
    } catch (err) {
      err.logError();
    }
  }

  void displayPaymentSheet(
    WalletProvider provider,
    String id,
    int amount,
  ) async {
    // try {
    print('present payment sheet called');
    Stripe.instance.presentPaymentSheet().then((value) {
      debugPrint('present payment sheet success -> ${value?.label}');
      provider.saveTransaction(id, amount).then((value) {
        debugPrint('transaction saved to db successfully');
      }).onError((error, stackTrace) {
        debugPrint('save transaction to database error');
        //  throw Exception(error);
      });
      Stripe.instance.confirmPaymentSheetPayment().then((value) {
        debugPrint('present payment sheet confirm success');
      });
    }).onError((error, stackTrace) {
      debugPrint('some error when displaying sheet -> $error');
      throw Exception(error);
    });
  }

  void withdrawAmount(WalletProvider provider, int amount) {
    context.showProgressDialog(
      dialog: const WaitingDialog(status: 'Submitting Request'),
    );
    provider.requestWithdrawAmount(amount).then((value) {
      Navigator.pop(context);
      context.showSnack(message: value);
    }).catchError((error) {
      Navigator.pop(context);
      context.showSnack(message: '$error');
    });
  }
}
