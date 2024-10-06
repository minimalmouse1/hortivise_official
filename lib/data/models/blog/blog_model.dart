// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/

import 'package:json_annotation/json_annotation.dart';

part 'blog_model.g.dart';

@JsonSerializable()
class BlogModel {
  BlogModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.senderId,
    required this.senderName,
    required this.senderProfileUrl,
    required this.time,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) =>
      _$BlogModelFromJson(json);
  String id;
  String title;
  String imageUrl;
  String description;
  String senderId;
  String senderName;
  String senderProfileUrl;
  int time;

  Map<String, dynamic> toJson() => _$BlogModelToJson(this);
}
