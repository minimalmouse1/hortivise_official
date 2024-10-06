// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      messageId: json['messageId'] as String,
      channelId: json['channelId'] as String,
      messageType: $enumDecode(_$MessageTypeEnumMap, json['messageType']),
      message: json['message'] as String,
      time: (json['time'] as num).toInt(),
      senderId: json['senderId'] as String,
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'messageId': instance.messageId,
      'channelId': instance.channelId,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'message': instance.message,
      'time': instance.time,
      'senderId': instance.senderId,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.video: 'video',
  MessageType.audio: 'audio',
};
