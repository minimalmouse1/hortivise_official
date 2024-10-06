// Developed By Muhammad Waleed.. Senior Android and Flutter developer..
// waleedkalyar48@gmail.com/

import 'package:horti_vige/data/enums/package_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package_model.g.dart';

@JsonSerializable()
class PackageModel {
  PackageModel({
    required this.id,
    required this.type,
    required this.title,
    required this.amount,
    required this.duration,
    required this.textLimit,
    this.extraInfo,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) =>
      _$PackageModelFromJson(json);
  String id;
  PackageType type;
  String title;
  double amount;
  int duration;
  String? extraInfo;
  int textLimit;

  Map<String, dynamic> toJson() => _$PackageModelToJson(this);
}
