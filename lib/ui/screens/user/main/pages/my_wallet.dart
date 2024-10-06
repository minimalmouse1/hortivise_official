import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horti_vige/data/services/stripe.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({super.key});

  @override
  State<MyWallet> createState() => _UserWalletPageState();
}

class _UserWalletPageState extends State<MyWallet> {
  Map<String, dynamic>? paymentIntent;
  List<MyWalletModel> modelList = [];
  String filter = 'All';
  List<MyWalletModel> copyModelList = [];
  double ammount = 0;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
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
        ),
        loading
            ? SizedBox(
                height: context.height,
                width: context.width,
                child: const Center(child: CircularProgressIndicator()),
              )
            : Positioned(
                top: kToolbarHeight,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
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
                                        .changeSize(14)
                                        .changeColor(AppColors.colorWhite),
                                  ),
                                ],
                              ),
                              Text(
                                '\$${ammount.toStringAsFixed(2)}',
                                style: AppTextStyles.bodyStyleLarge
                                    .changeSize(20)
                                    .changeColor(AppColors.colorWhite),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.filter_alt_outlined,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: context.width * 0.4,
                            child: DropdownButton(
                              value: filter,
                              items: [
                                DropdownMenuItem(
                                  value: 'All',
                                  child: SizedBox(
                                    width: context.width * 0.3,
                                    child: const Text(
                                      'All',
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Last 30 Days',
                                  child: SizedBox(
                                    width: context.width * 0.3,
                                    child: const Text(
                                      'Last 30 Days',
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Last 60 Days',
                                  child: SizedBox(
                                    width: context.width * 0.3,
                                    child: const Text(
                                      'Last 60 Days',
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Last 90 Days',
                                  child: SizedBox(
                                    width: context.width * 0.3,
                                    child: const Text(
                                      'Last 90 Days',
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (val) async {
                                filter = val.toString();
                                await filterData();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                        itemCount: copyModelList.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Padding(
                            padding: 16.horizontalPadding,
                            child: const Divider(
                              height: 0.5,
                              color: AppColors.colorGrayBg,
                            ),
                          );
                        },
                        itemBuilder: (context, index) {
                          final model = copyModelList[index];

                          model.toJson().log();
                          return ListTile(
                            leading: const Icon(
                              Icons.attach_money,
                              color: AppColors.colorGreen,
                              size: 24,
                            ),
                            title: Text(
                              '${model.title} with ${model.customer}',
                              style: AppTextStyles.titleStyle
                                  .changeSize(16)
                                  .changeFontWeight(FontWeight.w600),
                            ),
                            subtitle: Text(
                              model.date
                                  .toString()
                                  .split(' ')
                                  .first
                                  .toLowerCase(),
                              style: AppTextStyles.bodyStyle
                                  .changeColor(AppColors.colorGray)
                                  .changeSize(14),
                            ),
                            trailing: Text(
                              '\$${model.ammount?.toStringAsFixed(2)}',
                              style: AppTextStyles.bodyStyleLarge
                                  .changeSize(20)
                                  .changeColor(AppColors.colorGreen),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  void getData() {
    FirebaseFirestore.instance
        .collection('Transfers')
        .where(
          FieldPath(const ['business', 'stripeId']),
          isEqualTo: StripeController.instance.getAccountId(),
        )
        .snapshots()
        .listen((event) {
      modelList = [];
      for (final x in event.docs) {
        final model = MyWalletModel.fromJson(
          x.data()['business'],
        );
        modelList.add(model);
      }
      filterData();
    });
  }

  Future<void> filterData() async {
    setState(() {
      loading = true;
    });
    copyModelList = [];
    ammount = 0;
    if (filter == 'All') {
      copyModelList = modelList;
    } else if (filter == 'Last 30 Days') {
      copyModelList = modelList.where((element) {
        final dif = DateTime.now().difference(element.date!).inDays;
        dif.log();
        if (dif <= 30) {
          return true;
        } else {
          return false;
        }
      }).toList();
    } else if (filter == 'Last 60 Days') {
      copyModelList = modelList.where((element) {
        final dif = DateTime.now().difference(element.date!).inDays;
        if (dif <= 60) {
          return true;
        } else {
          return false;
        }
      }).toList();
    } else if (filter == 'Last 90 Days') {
      copyModelList = modelList.where((element) {
        final dif = DateTime.now().difference(element.date!).inDays;
        if (dif <= 90) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }
    for (final element in copyModelList) {
      ammount += element.ammount ?? 0;
    }
    setState(() {
      loading = false;
    });
  }
}

class MyWalletModel {
  MyWalletModel({this.title, this.ammount, this.transferId, this.customer});

  MyWalletModel.fromJson(json) {
    title = json['title'];
    ammount = double.parse(json['ammount'].toString());
    transferId = json['transferId'];
    customer = json['customer'];
    date = (json['date'] as Timestamp).toDate();
  }
  String? title;
  double? ammount;
  String? transferId;
  String? customer;
  DateTime? date;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['ammount'] = ammount;
    data['transferId'] = transferId;
    data['customer'] = customer;
    data['date'] = date;
    return data;
  }
}
