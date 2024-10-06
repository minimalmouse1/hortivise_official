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
    var lastDay = '';
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
          builder: (_, provider, __) => StreamBuilder(
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
                        'Something went wrong when connecting to server, please try again later!',
                      ),
                    );
                  } else {
                    final notifications = snapshots.data!;
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
                    return ListView.separated(
                      itemBuilder: (ctx, index) {
                        final currentDate = AppDateUtils.getDayViseDate(
                          millis: notifications[index].time,
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
                            ItemNotification(
                              notification: notifications[index],
                              description: provider
                                  .getDisplayableMessage(notifications[index]),
                            ),
                          ],
                        );
                      },
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) {
                        final currentDate = AppDateUtils.getDayViseDate(
                          millis: notifications[index].time,
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

  Widget separator(int index) {
    return Padding(
      padding: index == 0 || index == 1 ? 5.verticalPadding : 0.verticalPadding,
      child: index <= 1
          ? Padding(
              padding: 5.horizontalPadding,
              child: Text(
                index == 0
                    ? 'Today'
                    : index == 1
                        ? 'Yesterday'
                        : '',
                style: AppTextStyles.bodyStyleLarge
                    .changeSize(12)
                    .changeFontWeight(FontWeight.w600),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget withSeparator(
    int index,
    NotificationModel notificationModel,
    NotificationsProvider provider,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        separator(index),
        ItemNotification(
          notification: notificationModel,
          description: provider.getDisplayableMessage(notificationModel),
        ),
      ],
    );
  }
}
