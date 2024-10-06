// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogModel _$BlogModelFromJson(Map<String, dynamic> json) => BlogModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderProfileUrl: json['senderProfileUrl'] as String,
      time: (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$BlogModelToJson(BlogModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderProfileUrl': instance.senderProfileUrl,
      'time': instance.time,
    };
