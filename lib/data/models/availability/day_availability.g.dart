// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayAvailability _$DayAvailabilityFromJson(Map<String, dynamic> json) =>
    DayAvailability(
      isDefault: json['isDefault'] as bool,
      from: const TimeOfDayConverter()
          .fromJson(json['from'] as Map<String, dynamic>),
      to: const TimeOfDayConverter()
          .fromJson(json['to'] as Map<String, dynamic>),
      day: $enumDecode(_$DayEnumEnumMap, json['day']),
    );

Map<String, dynamic> _$DayAvailabilityToJson(DayAvailability instance) =>
    <String, dynamic>{
      'isDefault': instance.isDefault,
      'from': const TimeOfDayConverter().toJson(instance.from),
      'to': const TimeOfDayConverter().toJson(instance.to),
      'day': _$DayEnumEnumMap[instance.day]!,
    };

const _$DayEnumEnumMap = {
  DayEnum.monday: 'monday',
  DayEnum.tuesday: 'tuesday',
  DayEnum.wednesday: 'wednesday',
  DayEnum.thursday: 'thursday',
  DayEnum.friday: 'friday',
  DayEnum.saturday: 'saturday',
  DayEnum.sunday: 'sunday',
};
