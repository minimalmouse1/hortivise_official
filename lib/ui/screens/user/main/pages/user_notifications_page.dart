import 'package:flutter/material.dart';
import 'package:horti_vige/data/models/notification/notification_model.dart';
import 'package:horti_vige/providers/notifications_provider.dart';
import 'package:horti_vige/ui/resources/app_icons_icons.dart';
import 'package:horti_vige/ui/items/item_notification.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/ui/utils/styles/text_styles.dart';
import 'package:horti_vige/core/utils/app_date_utils.dart';
import 'package:provider/provider.dart';

class UserNotificationsPage extends StatelessWidget {
  const UserNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBeige,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: AppTextStyles.titleStyle.changeSize(20),
        ),
        backgroundColor: AppColors.colorBeige,
      ),
      body: Padding(
        padding: 12.allPadding,
        child: Consumer<NotificationsProvider>(
          builder: (_, provider, __) => StreamBuilder<List<NotificationModel>>(
            stream: provider.streamNotifications(),
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
                        'Something went wrong when connecting to the server, please try again later!',
                      ),
                    );
                  } else {
                    final notifications = snapshots.data ?? [];

                    if (notifications.isEmpty) {
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
                              'No Notifications Found Yet!',
                              style: AppTextStyles.bodyStyleMedium,
                            ),
                          ],
                        ),
                      );
                    }

                    // Ensure notifications are sorted from latest to oldest
                    notifications.sort((a, b) => b.time.compareTo(a.time));

                    String lastDay = '';

                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (ctx, index) {
                        final notification = notifications[index];
                        final currentDate = AppDateUtils.getDayViseDate(
                          millis: notification.time,
                        );

                        bool showDateHeader = lastDay != currentDate;
                        lastDay = currentDate;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showDateHeader)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Center(
                                  child: Text(
                                    currentDate,
                                    style: AppTextStyles.bodyStyleLarge
                                        .changeSize(12)
                                        .changeFontWeight(FontWeight.w600),
                                  ),
                                ),
                              ),
                            ItemNotification(
                              notification: notification,
                              description:
                                  provider.getDisplayableMessage(notification),
                            ),
                          ],
                        );
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
