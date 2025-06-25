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
      stripe_price_id:json['stripe_price_id'] as String,
      stripe_product_id:json['stripe_product_id'] as String,
    );

Map<String, dynamic> _$VideoPricingModelToJson(VideoPricingModel instance) =>
    <String, dynamic>{
      'duration': _$VideoDurationEnumEnumMap[instance.duration]!,
      'noOf': instance.noOf,
      'price': instance.price,
      'isEnabled': instance.isEnabled,
      'stripe_price_id': instance.stripe_price_id,
      'stripe_product_id': instance.stripe_product_id,
    };

const _$VideoDurationEnumEnumMap = {
  VideoDurationEnum.hour: 'hour',
  VideoDurationEnum.minute: 'minute',
};
