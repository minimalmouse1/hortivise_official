import 'package:flutter/material.dart';
import 'package:horti_vige/data/enums/days.dart';
import 'package:horti_vige/data/models/availability/availability.dart';
import 'package:json_annotation/json_annotation.dart';

part 'day_availability.g.dart';

@JsonSerializable()
class DayAvailability {
  const DayAvailability({
    required this.isDefault,
    required this.from,
    required this.to,
    required this.day,
  });

  factory DayAvailability.fromJson(Map<String, dynamic> json) =>
      _$DayAvailabilityFromJson(json);

  final bool isDefault;
  @TimeOfDayConverter()
  final TimeOfDay from;
  @TimeOfDayConverter()
  final TimeOfDay to;
  final DayEnum day;
  Map<String, dynamic> toJson() => _$DayAvailabilityToJson(this);
}
