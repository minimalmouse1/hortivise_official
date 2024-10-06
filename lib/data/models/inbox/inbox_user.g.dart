// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InboxUser _$InboxUserFromJson(Map<String, dynamic> json) => InboxUser(
      userId: json['userId'] as String,
      profileUrl: json['profileUrl'] as String,
      userName: json['userName'] as String,
      unreadCount: (json['unreadCount'] as num).toInt(),
    );

Map<String, dynamic> _$InboxUserToJson(InboxUser instance) => <String, dynamic>{
      'userId': instance.userId,
      'profileUrl': instance.profileUrl,
      'userName': instance.userName,
      'unreadCount': instance.unreadCount,
    };
