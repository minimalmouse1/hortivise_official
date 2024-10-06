import 'package:horti_vige/data/enums/notification_type.dart';
import 'package:horti_vige/data/models/notification/notification_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationModel {
  // other data in json format

  NotificationModel({
    required this.id,
    required this.title,
    required this.descriptionUser,
    required this.iconImageUrl,
    required this.time,
    required this.type,
    required this.data,
    required this.userIds,
    required this.descriptionSpecialist,
    required this.generatedBy,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  String id;
  String title;
  String descriptionUser;

  String descriptionSpecialist;

  NotificationUser generatedBy; // should be user json

  String iconImageUrl;
  int time;
  NotificationType type;

  List<String> userIds;

  String data;

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

/*
  * KIND of Notifications.
  * 1. Profession request accepted. (come from admin panel).
  * 2. Consultation request.. Received, accepted, rejected.
  * 4. Consultation Time started, end, expired etc.
  * 5. New blog posted
  * 6. Payment received, payment method added etc.
  * 7. Message received, call received etc.
  * */
}
