// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Availability _$AvailabilityFromJson(Map<String, dynamic> json) => Availability(
      defaultFrom: const TimeOfDayConverter()
          .fromJson(json['defaultFrom'] as Map<String, dynamic>),
      defaultTo: const TimeOfDayConverter()
          .fromJson(json['defaultTo'] as Map<String, dynamic>),
      timeZone: json['timeZone'] as String,
      days: (json['days'] as List<dynamic>)
          .map((e) => DayAvailability.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AvailabilityToJson(Availability instance) =>
    <String, dynamic>{
      'defaultFrom': const TimeOfDayConverter().toJson(instance.defaultFrom),
      'defaultTo': const TimeOfDayConverter().toJson(instance.defaultTo),
      'timeZone': instance.timeZone,
      'days': instance.days.map((e) => e.toJson()).toList(),
    };
