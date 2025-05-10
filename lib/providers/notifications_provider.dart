import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/data/models/notification/notification_model.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';

class NotificationsProvider extends ChangeNotifier {
  final _notificationsCollectionRef =
      FirebaseFirestore.instance.collection('Notifications');

  final _readNotificationsCollectionRef =
      FirebaseFirestore.instance.collection('ReadNotifications');

  final PreferenceManager _prefs = PreferenceManager.getInstance();

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

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

  // Stream of unread notifications count
  Stream<int> streamUnreadNotificationsCount() {
    final userId = _prefs.getCurrentUser()!.uId;

    // First get all notifications for this user
    return _notificationsCollectionRef
        .where('userIds', arrayContains: userId)
        .snapshots()
        .asyncMap((notificationSnapshot) async {
      // Get all notification IDs
      final notificationIds =
          notificationSnapshot.docs.map((e) => e.id).toList();

      if (notificationIds.isEmpty) {
        return 0;
      }

      // Get all notifications that have been read by this user
      final readNotificationsSnapshot = await _readNotificationsCollectionRef
          .where('userId', isEqualTo: userId)
          .where('notificationId', whereIn: notificationIds)
          .get();

      // Notifications that have been read
      final readNotificationIds = readNotificationsSnapshot.docs
          .map((e) => e.data()['notificationId'] as String)
          .toSet();

      // Count unread notifications
      final unreadCount = notificationIds
          .where((id) => !readNotificationIds.contains(id))
          .length;

      // Update local state
      _unreadCount = unreadCount;
      notifyListeners();

      return unreadCount;
    });
  }

  // Mark a notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    final userId = _prefs.getCurrentUser()!.uId;

    // Check if already marked as read
    final existingDoc = await _readNotificationsCollectionRef
        .where('userId', isEqualTo: userId)
        .where('notificationId', isEqualTo: notificationId)
        .get();

    if (existingDoc.docs.isEmpty) {
      // Add to read notifications collection
      await _readNotificationsCollectionRef.add({
        'userId': userId,
        'notificationId': notificationId,
        'readAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Update local state
      _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
      notifyListeners();
    }
  }

  // Mark all notifications as read
  Future<void> markAllNotificationsAsRead() async {
    final userId = _prefs.getCurrentUser()!.uId;

    // Get all notifications for this user
    final notificationsSnapshot = await _notificationsCollectionRef
        .where('userIds', arrayContains: userId)
        .get();

    // Batch write to mark all as read
    final batch = FirebaseFirestore.instance.batch();
    final existingReadSnapshot = await _readNotificationsCollectionRef
        .where('userId', isEqualTo: userId)
        .get();

    // Create set of already read notification IDs
    final readNotificationIds = existingReadSnapshot.docs
        .map((e) => e.data()['notificationId'] as String)
        .toSet();

    // Only mark unread notifications as read
    for (final notificationDoc in notificationsSnapshot.docs) {
      final notificationId = notificationDoc.id;

      if (!readNotificationIds.contains(notificationId)) {
        final newReadRef = _readNotificationsCollectionRef.doc();
        batch.set(newReadRef, {
          'userId': userId,
          'notificationId': notificationId,
          'readAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
    }

    await batch.commit();

    // Update local state
    _unreadCount = 0;
    notifyListeners();
  }
}
