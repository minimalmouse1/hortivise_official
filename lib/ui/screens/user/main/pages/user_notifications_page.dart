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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';

class UserNotificationsPage extends StatefulWidget {
  const UserNotificationsPage({super.key});

  @override
  State<UserNotificationsPage> createState() => _UserNotificationsPageState();
}

class _UserNotificationsPageState extends State<UserNotificationsPage> {
  // Keep track of read notification IDs
  Set<String> _readNotificationIds = {};

  @override
  void initState() {
    super.initState();
    _fetchReadNotifications();

    // Use a small delay to allow the page to be built before marking notifications as read
    Future.delayed(Duration.zero, () {
      if (mounted) {
        Provider.of<NotificationsProvider>(context, listen: false)
            .markAllNotificationsAsRead();
      }
    });
  }

  Future<void> _fetchReadNotifications() async {
    final userId = PreferenceManager.getInstance().getCurrentUser()?.uId ?? '';

    final readDocsSnapshot = await FirebaseFirestore.instance
        .collection('ReadNotifications')
        .where('userId', isEqualTo: userId)
        .get();

    setState(() {
      _readNotificationIds = readDocsSnapshot.docs
          .map((doc) => doc.data()['notificationId'] as String)
          .toSet();
    });
  }

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

                        // Check if notification is read
                        final isRead =
                            _readNotificationIds.contains(notification.id);

                        bool showDateHeader = lastDay != currentDate;
                        lastDay = currentDate;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showDateHeader)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Center(
                                  child: Text(
                                    currentDate,
                                    style: AppTextStyles.bodyStyleLarge
                                        .changeSize(12)
                                        .changeFontWeight(FontWeight.w600),
                                  ),
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                // Mark individual notification as read when tapped
                                provider
                                    .markNotificationAsRead(notification.id);
                                // Update local state too
                                setState(() {
                                  _readNotificationIds.add(notification.id);
                                });
                              },
                              child: ItemNotification(
                                notification: notification,
                                description: provider
                                    .getDisplayableMessage(notification),
                                isRead: isRead,
                              ),
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
