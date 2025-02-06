// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:horti_vige/data/enums/message_type.dart';
import 'package:horti_vige/data/enums/notification_type.dart';
import 'package:horti_vige/data/models/chat/chat_model.dart';
import 'package:horti_vige/data/models/consultation/consultation_model.dart';
import 'package:horti_vige/data/models/inbox/inbox_user.dart';
import 'package:horti_vige/data/models/notification/notification_model.dart';
import 'package:horti_vige/data/models/notification/notification_user.dart';
import 'package:horti_vige/data/models/user/user_model.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';

class ChatProvider extends ChangeNotifier {
  final _chatsCollection = FirebaseFirestore.instance.collection('Chats');

  final _notificationsCollectionRef =
      FirebaseFirestore.instance.collection('Notifications');

  PreferenceManager prefs = PreferenceManager.getInstance();

  Future<void> sendNewMessage({
    required UserModel otherUser,
    required String message,
    required MessageType type,
    required ConsultationModel consultationModel,
  }) async {
    final channelId = consultationModel.id;

    InboxUser consultant, user;
    if (otherUser.specialist == null) {
      user = InboxUser(
        userId: otherUser.uId,
        profileUrl: otherUser.profileUrl,
        userName: otherUser.userName,
        unreadCount: 0,
      );
      consultant = InboxUser(
        userId: FirebaseAuth.instance.currentUser!.uid,
        profileUrl: prefs.getCurrentUser()!.profileUrl,
        userName: prefs.getCurrentUser()!.userName,
        unreadCount: 0,
      );
    } else {
      consultant = InboxUser(
        userId: otherUser.uId,
        profileUrl: otherUser.profileUrl,
        userName: otherUser.userName,
        unreadCount: 0,
      );
      user = InboxUser(
        userId: FirebaseAuth.instance.currentUser!.uid,
        profileUrl: prefs.getCurrentUser()!.profileUrl,
        userName: prefs.getCurrentUser()!.userName,
        unreadCount: 0,
      );
    }
    FirebaseFirestore.instance.collection('Chats').doc(channelId).set(
      {
        'consultant': consultant.toJson(),
        'user': user.toJson(),
        'lastMessage': message,
        'time': DateTime.now(),
        'consultion': consultationModel.toJson(),
        'consultantInChat': false,
        'patientInChat': true,
      },
    );
    // new send new message on specific channel
    final id = _chatsCollection.doc().id;
    final chatModel = ChatModel(
      messageId: id,
      channelId: channelId,
      messageType: type,
      message: message,
      time: DateTime.now().millisecondsSinceEpoch,
      senderId: prefs.getCurrentUser()!.uId,
    );

    await _chatsCollection
        .doc(channelId)
        .collection('Messages')
        .doc(chatModel.messageId)
        .set(chatModel.toJson());
    await _chatsCollection
        .doc(channelId)
        .collection('Messages')
        .doc(chatModel.messageId)
        .set({
      'senderEmail': FirebaseAuth.instance.currentUser!.email,
      'messageSeen': false
    }, SetOptions(merge: true));

    final notificationId = _notificationsCollectionRef.doc().id;
    final notificationModel = NotificationModel(
      id: notificationId,
      title: '${prefs.getCurrentUser()!.userName} send a new message',
      descriptionUser: chatModel.message,
      iconImageUrl: '',
      time: DateTime.now().millisecondsSinceEpoch,
      type: NotificationType.message_send,
      data: '',
      userIds: [otherUser.uId],
      descriptionSpecialist: chatModel.message,
      generatedBy: NotificationUser(
        id: prefs.getCurrentUser()!.uId,
        name: prefs.getCurrentUser()!.userName,
        profileUrl: prefs.getCurrentUser()!.profileUrl,
        userType: prefs.getCurrentUser()!.type,
      ),
    );

    await _notificationsCollectionRef.doc(id).set(notificationModel.toJson());
  }

  Stream<List<ChatModel>> streamAllConversations({
    required String consultionId,
  }) {
    return _chatsCollection
        .doc(consultionId)
        .collection('Messages')
        .orderBy('time', descending: true)
        .snapshots()
        .map((querySnapshots) {
      final chats = <ChatModel>[];
      for (final DocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshots.docs) {
        chats.add(ChatModel.fromJson(doc.data()!));
      }
      return chats;
    });
  }

  String getCurrentUserId() {
    return prefs.getCurrentUser()!.uId;
  }

  bool isMineMessage(ChatModel chat) {
    return chat.senderId == prefs.getCurrentUser()!.uId;
  }
}
