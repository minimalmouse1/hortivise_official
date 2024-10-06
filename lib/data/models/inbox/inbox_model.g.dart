// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InboxModel _$InboxModelFromJson(Map<String, dynamic> json) => InboxModel(
      id: json['id'] as String,
      inboxUsers: (json['inboxUsers'] as List<dynamic>)
          .map((e) => InboxUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: (json['lastMessageTime'] as num).toInt(),
      isLastMessageRead: json['isLastMessageRead'] as bool,
      channelId: json['channelId'] as String,
      userIds:
          (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$InboxModelToJson(InboxModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inboxUsers': instance.inboxUsers.map((e) => e.toJson()).toList(),
      'userIds': instance.userIds,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime,
      'isLastMessageRead': instance.isLastMessageRead,
      'channelId': instance.channelId,
    };
