// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsultationModel _$ConsultationModelFromJson(Map<String, dynamic> json) =>
    ConsultationModel(
      timeZone: json['timeZone'] as String,
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      durationTime: (json['durationTime'] as num).toInt(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      isEnabled: json['isEnabled'] as bool,
      specialist:
          UserModel.fromJson(json['specialist'] as Map<String, dynamic>),
      customer: UserModel.fromJson(json['customer'] as Map<String, dynamic>),
      packageId: json['packageId'] as String,
      tax: (json['tax'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status:
          $enumDecodeNullable(_$ConsultationStatusEnumMap, json['status']) ??
              ConsultationStatus.pending,
      packageType: $enumDecode(_$PackageTypeEnumMap, json['packageType']),
    );

Map<String, dynamic> _$ConsultationModelToJson(ConsultationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'durationTime': instance.durationTime,
      'startTime': instance.startTime.toIso8601String(),
      'startDateTime': instance.startDateTime.toIso8601String(),
      'endDateTime': instance.endDateTime.toIso8601String(),
      'isEnabled': instance.isEnabled,
      'endTime': instance.endTime.toIso8601String(),
      'specialist': instance.specialist.toJson(),
      'customer': instance.customer.toJson(),
      'packageId': instance.packageId,
      'tax': instance.tax,
      'totalAmount': instance.totalAmount,
      'packageType': _$PackageTypeEnumMap[instance.packageType]!,
      'status': _$ConsultationStatusEnumMap[instance.status]!,
      'timeZone': instance.timeZone
    };

const _$ConsultationStatusEnumMap = {
  ConsultationStatus.pending: 'pending',
  ConsultationStatus.accepted: 'accepted',
  ConsultationStatus.rejected: 'rejected',
  ConsultationStatus.pendingUpdated: 'pendingUpdated',
  ConsultationStatus.acceptedUpdated: 'acceptedUpdated',
  ConsultationStatus.canceled: 'canceled',
  ConsultationStatus.incomplete: 'incomplete',
  ConsultationStatus.enabled: 'enabled',
  ConsultationStatus.restricted: 'restricted',
};

const _$PackageTypeEnumMap = {
  PackageType.text: 'text',
  PackageType.video: 'video',
};
