import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:horti_vige/data/models/consultation/consultation_model.dart';
import 'package:horti_vige/providers/consultations_provider.dart';
import 'package:horti_vige/testing_screens/video_call_testing.dart';
import 'package:horti_vige/ui/items/item_consultation.dart';
import 'package:horti_vige/ui/screens/consultant/consultation_details_screen.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/core/utils/app_consts.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';
import 'package:provider/provider.dart';

import 'package:horti_vige/core/utils/helpers/preference_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as sv;

class UserConsultantsPage extends StatelessWidget {
  const UserConsultantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lastDay = '';
    final currentUserId =
        PreferenceManager.getInstance().getCurrentUser()?.id ?? '';
    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      appBar: AppBar(
        title: Text(
          'Consultations',
          style: AppTextStyles.titleStyle.changeSize(20),
        ),
        backgroundColor: AppColors.colorBeige,
        //TODO: Add search
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.search,
        //       color: AppColors.colorGreen,
        //     ),
        //   ),
        // ],
      ),
      body: Padding(
        padding: 12.horizontalPadding,
        child: Consumer<ConsultationProvider>(
          builder: (_, provider, __) => StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Consultations')
                .where(
                  Filter.or(
                    Filter(
                      FieldPath(const ['customer', 'id']),
                      isEqualTo: currentUserId,
                    ),
                    Filter(
                      FieldPath(const ['specialist', 'id']),
                      isEqualTo: currentUserId,
                    ),
                  ),
                )
                .snapshots(),
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
                    return Center(
                      child: Text(
                        'Something went wrong when connecting to server, please try again later! ${snapshots.error}',
                      ),
                    );
                  } else {
                    final list = [];
                    for (final element in snapshots.data!.docs) {
                      list.add(
                        ConsultationModel.fromJson(element.data()),
                      );
                    }
                    print('consultations size - > ${list.length}');

                    if (list.isEmpty) {
                      return const Center(
                        child: Text('No Consultations Found'),
                      );
                    }

                    return ListView.separated(
                      itemCount: list.length,
                      itemBuilder: (ctx, index) {
                        final currentDate = AppDateUtils.getDayViseDate(
                          millis: list[index].startTime.millisecondsSinceEpoch,
                        );
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            lastDay != currentDate
                                ? Padding(
                                    padding: index == 0 || index == 1
                                        ? 5.verticalPadding
                                        : 0.verticalPadding,
                                    child: index <= 1
                                        ? Center(
                                            child: Text(
                                              currentDate,
                                              style: AppTextStyles
                                                  .bodyStyleLarge
                                                  .changeSize(12)
                                                  .changeFontWeight(
                                                    FontWeight.w600,
                                                  ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  )
                                : 0.height,
                            ItemConsultation(
                              consultation: list[index],
                              isCustomer: provider.isCustomer(),
                              onItemClick: (model) {
                                Navigator.pushNamed(
                                  context,
                                  ConsultationDetailsScreen.routeName,
                                  arguments: {
                                    Constants.consultModel:
                                        model, // this model contains the information related to consultation like timings etc
                                    Constants.fromUserConsultationPage: true,
                                    'docID': snapshots.data!.docs[index].id,
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        final currentDate = AppDateUtils.getDayViseDate(
                          millis: list[index].startTime.millisecondsSinceEpoch,
                        );
                        lastDay = currentDate;
                        return 0.height;
                      },
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
