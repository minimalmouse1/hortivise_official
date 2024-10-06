// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      descriptionUser: json['descriptionUser'] as String,
      iconImageUrl: json['iconImageUrl'] as String,
      time: (json['time'] as num).toInt(),
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      data: json['data'] as String,
      userIds:
          (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
      descriptionSpecialist: json['descriptionSpecialist'] as String,
      generatedBy: NotificationUser.fromJson(
          json['generatedBy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'descriptionUser': instance.descriptionUser,
      'descriptionSpecialist': instance.descriptionSpecialist,
      'generatedBy': instance.generatedBy.toJson(),
      'iconImageUrl': instance.iconImageUrl,
      'time': instance.time,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'userIds': instance.userIds,
      'data': instance.data,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.consultation_request: 'consultation_request',
  NotificationType.request_approved: 'request_approved',
  NotificationType.request_rejected: 'request_rejected',
  NotificationType.consultation_expired: 'consultation_expired',
  NotificationType.request_updated: 'request_updated',
  NotificationType.request_sent: 'request_sent',
  NotificationType.request_cancel: 'request_cancel',
  NotificationType.message_send: 'message_send',
};
