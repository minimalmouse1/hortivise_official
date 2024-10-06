// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/

import 'package:horti_vige/data/enums/message_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel {
  ChatModel({
    required this.messageId,
    required this.channelId,
    required this.messageType,
    required this.message,
    required this.time,
    required this.senderId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  String messageId;
  String channelId;
  MessageType messageType;
  String message;
  int time;
  String senderId;

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}
