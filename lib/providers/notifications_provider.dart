import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/data/models/notification/notification_model.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';

class NotificationsProvider extends ChangeNotifier {
  final _notificationsCollectionRef =
      FirebaseFirestore.instance.collection('Notifications');

  final PreferenceManager _prefs = PreferenceManager.getInstance();

  Stream<List<NotificationModel>> streamNotifications() {
    return _notificationsCollectionRef
        .where('userIds', arrayContains: _prefs.getCurrentUser()!.uId)
        .orderBy('time', descending: true)
        .snapshots()
        .map((querySnapshots) {
      final notifications = <NotificationModel>[];
      for (final DocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshots.docs) {
        notifications.add(NotificationModel.fromJson(doc.data()!));
      }
      return notifications;
    });
  }

  String getDisplayableMessage(NotificationModel notification) {
    if (_prefs.getCurrentUser()!.type == UserType.SPECIALIST) {
      return notification.descriptionSpecialist;
    } else {
      return notification.descriptionUser;
    }
  }
}
