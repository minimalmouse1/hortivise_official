// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsultationModel _$ConsultationModelFromJson(Map<String, dynamic> json) =>
    ConsultationModel(
      timeZone:
          json['timeZone'] as String? ?? '', // Handle null with default value
      id: json['id'] as String? ?? '', // Ensure id is never null
      title: json['title'] as String? ?? 'No Title', // Default title if null
      description: json['description'] as String? ?? 'No Description',
      durationTime: (json['durationTime'] as num?)?.toInt() ?? 0,
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime']) ?? DateTime.now()
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.tryParse(json['endTime']) ?? DateTime.now()
          : DateTime.now(),
      startDateTime: json['startDateTime'] != null
          ? DateTime.tryParse(json['startDateTime']) ?? DateTime.now()
          : DateTime.now(),
      endDateTime: json['endDateTime'] != null
          ? DateTime.tryParse(json['endDateTime']) ?? DateTime.now()
          : DateTime.now(),
      isEnabled: json['isEnabled'] as bool? ?? false, // Default false if null
      specialist: json['specialist'] != null
          ? UserModel.fromJson(json['specialist'] as Map<String, dynamic>)
          : UserModel.empty(), // Handle missing user
      customer: json['customer'] != null
          ? UserModel.fromJson(json['customer'] as Map<String, dynamic>)
          : UserModel.empty(),
      packageId: json['packageId'] as String? ?? '',
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] != null
          ? $enumDecodeNullable(_$ConsultationStatusEnumMap, json['status']) ??
              ConsultationStatus.pending
          : ConsultationStatus.pending,
      packageType: json['packageType'] != null
          ? $enumDecode(_$PackageTypeEnumMap, json['packageType'])
          : PackageType.text,
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
