import 'package:horti_vige/data/enums/consultation_status.dart';
import 'package:horti_vige/data/enums/package_type.dart';
import 'package:horti_vige/data/models/user/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consultation_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ConsultationModel {
  ConsultationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.durationTime,
    required this.startTime,
    required this.endTime,
    required this.startDateTime,
    required this.endDateTime,
    required this.isEnabled,
    required this.specialist,
    required this.customer,
    required this.packageId,
    required this.tax,
    required this.totalAmount,
    this.status = ConsultationStatus.pending,
    required this.packageType,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationModelFromJson(json);
  String id;
  String title;
  String description;
  int durationTime;
  DateTime startTime;
  DateTime startDateTime;
  DateTime endDateTime;
  bool isEnabled;
  DateTime endTime;
  UserModel specialist;
  UserModel customer;
  String packageId;
  double tax;
  double totalAmount;
  PackageType packageType;
  // payment related variables will be added later
  ConsultationStatus status;

  Map<String, dynamic> toJson() => _$ConsultationModelToJson(this);
}
