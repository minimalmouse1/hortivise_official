// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Specialist _$SpecialistFromJson(Map<String, dynamic> json) => Specialist(
      professionalName: json['professionalName'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String,
      category: $enumDecode(_$SpecialistCategoryEnumMap, json['category']),
      stripeId: json['stripeId'] as String,
      isStripeActive: json['isStripeActive'] as bool,
      status: $enumDecodeNullable(_$StripeStatusEnumMap, json['status']) ??
          StripeStatus.pending,
      statusMessage: json['statusMessage'] as String? ?? 'N/A',
    );

Map<String, dynamic> _$SpecialistToJson(Specialist instance) =>
    <String, dynamic>{
      'professionalName': instance.professionalName,
      'email': instance.email,
      'stripeId': instance.stripeId,
      'bio': instance.bio,
      'isStripeActive': instance.isStripeActive,
      'status': _$StripeStatusEnumMap[instance.status]!,
      'category': _$SpecialistCategoryEnumMap[instance.category]!,
      'statusMessage': instance.statusMessage,
    };

const _$SpecialistCategoryEnumMap = {
  SpecialistCategory.All: 'All',
  SpecialistCategory.Floweriest: 'Floweriest',
  SpecialistCategory.Palmist: 'Palmist',
};

const _$StripeStatusEnumMap = {
  StripeStatus.enabled: 'enabled',
  StripeStatus.incomplete: 'incomplete',
  StripeStatus.pending: 'pending',
  StripeStatus.restricted: 'restricted',
};
