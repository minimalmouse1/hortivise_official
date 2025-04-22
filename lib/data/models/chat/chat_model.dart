

import 'package:horti_vige/data/enums/enums.dart';
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
