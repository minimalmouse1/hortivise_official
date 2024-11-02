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
import 'dart:developer' as d;
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as sv;
import 'dart:async';
import 'package:horti_vige/data/enums/package_type.dart';

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

class ConsultationDetailsTile extends StatefulWidget {
  String lastDay;
  String currentDate;
  int index;
  ConsultationProvider provider;
  List<dynamic> list;
  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshots;
  ConsultationModel consultation;
  ConsultationDetailsTile({
    super.key,
    required this.lastDay,
    required this.currentDate,
    required this.index,
    required this.snapshots,
    required this.provider,
    required this.list,
    required this.consultation,
  });

  @override
  State<ConsultationDetailsTile> createState() =>
      _ConsultationDetailsTileState();
}

class _ConsultationDetailsTileState extends State<ConsultationDetailsTile> {
  Timer? timer;

  Timer? statusTimer;
  String status = '';
  void startMonitoring(ConsultationModel consultation) {
    statusTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();

      if (now.isBefore(consultation.startTime)) {
        // Status before the appointment starts
        setState(() {
          status = 'soon';
        });
      } else if (now.isAfter(consultation.startTime) &&
          now.isBefore(consultation.endTime)) {
        // Status when the appointment is ongoing
        setState(() {
          status = 'started';
        });
      } else {
        setState(() {
          status = 'expired';
        });
        timer.cancel();
      }

      d.log('status: $status');
    });
  }

  void startMonitoringTextTier(ConsultationModel consultation) {
    statusTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();

      if (now.isBefore(consultation.startTime)) {
        setState(() {
          status = 'soon';
        });
      } else if (now.isAfter(consultation.startTime) &&
          now.isBefore(consultation.startTime.add(Duration(hours: 1)))) {
        setState(() {
          status = 'started';
        });
      } else {
        setState(() {
          status = 'expired';
        });
        timer.cancel();
      }

      d.log('status: $status');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.consultation.packageType == PackageType.text
        ? startMonitoringTextTier(widget.consultation)
        : startMonitoring(widget.consultation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.lastDay != widget.currentDate
            ? Padding(
                padding: widget.index == 0 || widget.index == 1
                    ? 5.verticalPadding
                    : 0.verticalPadding,
                child: widget.index <= 1
                    ? Center(
                        child: Text(
                          widget.currentDate,
                          style: AppTextStyles.bodyStyleLarge
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
          consultation: widget.list[widget.index],
          isCustomer: widget.provider.isCustomer(),
          onItemClick: (model) {
            Navigator.pushNamed(
              context,
              ConsultationDetailsScreen.routeName,
              arguments: {
                Constants.consultModel:
                    model, // this model contains the information related to consultation like timings etc
                Constants.fromUserConsultationPage: true,
                'docID': widget.snapshots.data!.docs[widget.index].id,
              },
            );
          },
        ),
      ],
    );
  }
}
