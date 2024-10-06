// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_pricing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextPricingModel _$TextPricingModelFromJson(Map<String, dynamic> json) =>
    TextPricingModel(
      noOfTexts: (json['noOfTexts'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      isEnabled: json['isEnabled'] as bool? ?? true,
    );

Map<String, dynamic> _$TextPricingModelToJson(TextPricingModel instance) =>
    <String, dynamic>{
      'noOfTexts': instance.noOfTexts,
      'price': instance.price,
      'isEnabled': instance.isEnabled,
    };
