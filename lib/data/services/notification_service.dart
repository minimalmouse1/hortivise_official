import 'dart:convert';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:horti_vige/ui/utils/colors/colors.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:timezone/data/latest.dart' as latestTz;
import 'package:timezone/standalone.dart' as standaloneTz;
import 'package:timezone/timezone.dart' as latestTz;
import 'package:http/http.dart' as http;

class NotificationService {
  NotificationService._();

  static Future<void> initialize() async {
    await _configureLocalTimeZone();
    await _initLocalNotifications();
    await _checkAppLaunchNotification();
  }

  static Future<void> _configureLocalTimeZone() async {
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    standaloneTz.setLocalLocation(standaloneTz.getLocation(timeZoneName));
  }

  static Future<void> _initLocalNotifications() async {
    await FlutterLocalNotificationsPlugin().initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          requestCriticalPermission: true,
          onDidReceiveLocalNotification: (id, title, body, payload) async {
            // if (payload == 'progress') {
            // GroundsApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
            //   Routes.progress,
            //   (route) =>
            //       route.settings.name == Routes.progress || route.isFirst,
            // );
            // }
          },
        ),
      ),
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> _checkAppLaunchNotification() async {
    final details = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      final payload = details?.notificationResponse?.payload;
      if (payload != null) {
        payload.log();
      }
    }
  }

  static Future<void> askForNotificationPermission() async {
    try {
      FirebaseMessaging.instance.requestPermission(
        announcement: true,
        criticalAlert: true,
        provisional: true,
      );
    } catch (e) {
      print(e);
    }
  }

  static void setupNotifications() async {
    try {
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        message.data.log();
        _onNotification(message);
      });

      FirebaseMessaging.onMessage.listen((message) {
        message.data.log();

        _onNotification(message);
      });

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          _onNotification(message);
        }
      });

      try {
        latestTz.initializeTimeZones();
      } catch (e) {
        e.logError();
      }

      NotificationService.initialize();
    } catch (e) {
      e.logError();
    }
  }

  static void _onNotification(RemoteMessage message) {
    if (message.notification != null) {
      sendNotificationNow(
        title: message.notification!.title ?? 'HortiVise',
        body: message.notification!.body ?? '',
      );
    }

    if (message.data['consultationScheduleTime'] != null) {
      scheduleNotification(
        int.tryParse(message.data['consultationScheduleTime']) ?? 0,
      );
    }
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {}

  static NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'hortivise',
        'hortivise_local_channel',
        importance: Importance.max,
        priority: Priority.max,
        icon: 'ic_launcher',
        color: AppColors.colorWhite,
      ),
      iOS: DarwinNotificationDetails(
        interruptionLevel: InterruptionLevel.critical,
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  static void scheduleNotification(
    int scheduledNotificationDateTime,
  ) async {
    if (scheduledNotificationDateTime - DateTime.now().millisecondsSinceEpoch >=
        300000) {
      final alarmTime = scheduledNotificationDateTime - 300000;
      final scheduleTime = DateTime.fromMillisecondsSinceEpoch(alarmTime);
      'Notification Scheduled'.log();
      try {
        await FlutterLocalNotificationsPlugin().zonedSchedule(
          Random().nextInt(10000000),
          'Hortivise',
          'Your appointment is coming up!',
          latestTz.TZDateTime.from(
            scheduleTime,
            latestTz.local,
          ),
          notificationDetails(),
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        e.logError();
      }
    }
  }

  static Future<void> sendNotificationNow({
    required String title,
    required String body,
  }) async {
    await FlutterLocalNotificationsPlugin().show(
      Random().nextInt(10000000),
      title,
      body,
      notificationDetails(),
    );
  }

  static Future<void> sendAndRetrieveMessage({
    required String title,
    required String body,
    required String token,
    int? consultationScheduleTime,
  }) async {
    const serverKey =
        'AAAAJMJU5GM:APA91bHUIhQYxEdTEWNnjIVCp5-A4-XhWakohoPYAlmy2LGcASQ4JrPTlhcbZMVojoehguBK_3KmRilm29862rD8PBKcw0Flg_y0tI-Lxpg69A0kPM3bWVOP-dONjUp9PD2lW1vSITbT';
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'consultationScheduleTime': consultationScheduleTime,
          },
          // FCM Token lists.
          // 'registration_ids': ["Your_FCM_Token_One", "Your_FCM_Token_Two"],
          'to': token,
        },
      ),
    );
  }

  static Future<void> cancelScheduledNotifications() async {
    FlutterLocalNotificationsPlugin().cancelAll();
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
