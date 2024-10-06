// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/

import 'package:horti_vige/data/models/inbox/inbox_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inbox_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InboxModel {
  InboxModel({
    required this.id,
    required this.inboxUsers,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isLastMessageRead,
    required this.channelId,
    required this.userIds,
  });

  factory InboxModel.fromJson(Map<String, dynamic> json) =>
      _$InboxModelFromJson(json);
  String id;
  List<InboxUser> inboxUsers;
  List<String> userIds;
  String lastMessage;
  int lastMessageTime;
  bool isLastMessageRead;

  String channelId;

  Map<String, dynamic> toJson() => _$InboxModelToJson(this);
}
