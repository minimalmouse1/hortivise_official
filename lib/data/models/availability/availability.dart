// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:horti_vige/data/models/availability/day_availability.dart';

part 'availability.g.dart';

@JsonSerializable(explicitToJson: true)
class Availability {
  const Availability({
    required this.defaultFrom,
    required this.defaultTo,
    required this.timeZone,
    required this.days,
  });

  factory Availability.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityFromJson(json);

  @TimeOfDayConverter()
  final TimeOfDay defaultFrom;
  @TimeOfDayConverter()
  final TimeOfDay defaultTo;
  final String timeZone;
  final List<DayAvailability> days;

  Map<String, dynamic> toJson() => _$AvailabilityToJson(this);

  Availability copyWith({
    TimeOfDay? defaultFrom,
    TimeOfDay? defaultTo,
    String? timeZone,
    List<DayAvailability>? days,
  }) {
    return Availability(
      defaultFrom: defaultFrom ?? this.defaultFrom,
      defaultTo: defaultTo ?? this.defaultTo,
      timeZone: timeZone ?? this.timeZone,
      days: days ?? this.days,
    );
  }

  // Create empty factory
  factory Availability.empty() {
    return const Availability(
      defaultFrom: TimeOfDay(hour: 9, minute: 0),
      defaultTo: TimeOfDay(hour: 18, minute: 0),
      timeZone: '',
      days: [],
    );
  }
}

class TimeOfDayConverter
    implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> timeOfDayJson) {
    return TimeOfDay.fromDateTime(
      DateTime(0, 0, 0, timeOfDayJson['hour'], timeOfDayJson['minute']),
    );
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay timeOfDay) {
    return {
      'hour': timeOfDay.hour,
      'minute': timeOfDay.minute,
    };
  }
}
