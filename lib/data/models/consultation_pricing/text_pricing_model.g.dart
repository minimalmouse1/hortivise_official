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
      stripe_price_id:json['stripe_price_id'] as String,
      stripe_product_id:json['stripe_product_id'] as String,
    );

Map<String, dynamic> _$TextPricingModelToJson(TextPricingModel instance) =>
    <String, dynamic>{
      'noOfTexts': instance.noOfTexts,
      'price': instance.price,
      'isEnabled': instance.isEnabled,
      'stripe_price_id': instance.stripe_price_id,
      'stripe_product_id': instance.stripe_product_id,
    };
