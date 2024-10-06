// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_pricing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsultationPricingModel _$ConsultationPricingModelFromJson(
        Map<String, dynamic> json) =>
    ConsultationPricingModel(
      textPackages: (json['textPackages'] as List<dynamic>)
          .map((e) => TextPricingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      videoPackages: (json['videoPackages'] as List<dynamic>)
          .map((e) => VideoPricingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConsultationPricingModelToJson(
        ConsultationPricingModel instance) =>
    <String, dynamic>{
      'textPackages': instance.textPackages.map((e) => e.toJson()).toList(),
      'videoPackages': instance.videoPackages.map((e) => e.toJson()).toList(),
    };
