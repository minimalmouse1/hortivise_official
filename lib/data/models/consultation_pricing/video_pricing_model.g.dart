// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_pricing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPricingModel _$VideoPricingModelFromJson(Map<String, dynamic> json) =>
    VideoPricingModel(
      noOf: (json['noOf'] as num).toInt(),
      duration: $enumDecode(_$VideoDurationEnumEnumMap, json['duration']),
      price: (json['price'] as num).toDouble(),
      isEnabled: json['isEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$VideoPricingModelToJson(VideoPricingModel instance) =>
    <String, dynamic>{
      'duration': _$VideoDurationEnumEnumMap[instance.duration]!,
      'noOf': instance.noOf,
      'price': instance.price,
      'isEnabled': instance.isEnabled,
    };

const _$VideoDurationEnumEnumMap = {
  VideoDurationEnum.hour: 'hour',
  VideoDurationEnum.minute: 'minute',
};
