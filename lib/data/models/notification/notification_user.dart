// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/

import 'package:horti_vige/data/enums/user_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_user.g.dart';

@JsonSerializable()
class NotificationUser {
  NotificationUser({
    required this.id,
    required this.name,
    required this.profileUrl,
    required this.userType,
  });

  factory NotificationUser.fromJson(Map<String, dynamic> json) =>
      _$NotificationUserFromJson(json);
  String id;
  String name;
  String profileUrl;
  UserType userType;

  Map<String, dynamic> toJson() => _$NotificationUserToJson(this);
}
