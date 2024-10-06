// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/

import 'package:json_annotation/json_annotation.dart';

part 'inbox_user.g.dart';

@JsonSerializable()
class InboxUser {
  InboxUser({
    required this.userId,
    required this.profileUrl,
    required this.userName,
    required this.unreadCount,
  });

  factory InboxUser.fromJson(Map<String, dynamic> json) =>
      _$InboxUserFromJson(json);
  String userId;
  String profileUrl;

  String userName;

  int unreadCount;

  Map<String, dynamic> toJson() => _$InboxUserToJson(this);
}
