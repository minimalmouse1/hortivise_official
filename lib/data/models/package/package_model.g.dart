// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageModel _$PackageModelFromJson(Map<String, dynamic> json) => PackageModel(
      id: json['id'] as String,
      type: $enumDecode(_$PackageTypeEnumMap, json['type']),
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      duration: (json['duration'] as num).toInt(),
      textLimit: (json['textLimit'] as num).toInt(),
      extraInfo: json['extraInfo'] as String?,
    );

Map<String, dynamic> _$PackageModelToJson(PackageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PackageTypeEnumMap[instance.type]!,
      'title': instance.title,
      'amount': instance.amount,
      'duration': instance.duration,
      'extraInfo': instance.extraInfo,
      'textLimit': instance.textLimit,
    };

const _$PackageTypeEnumMap = {
  PackageType.text: 'text',
  PackageType.video: 'video',
};
