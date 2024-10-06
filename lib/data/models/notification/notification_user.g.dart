// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationUser _$NotificationUserFromJson(Map<String, dynamic> json) =>
    NotificationUser(
      id: json['id'] as String,
      name: json['name'] as String,
      profileUrl: json['profileUrl'] as String,
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
    );

Map<String, dynamic> _$NotificationUserToJson(NotificationUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileUrl': instance.profileUrl,
      'userType': _$UserTypeEnumMap[instance.userType]!,
    };

const _$UserTypeEnumMap = {
  UserType.CUSTOMER: 'CUSTOMER',
  UserType.SPECIALIST: 'SPECIALIST',
};
