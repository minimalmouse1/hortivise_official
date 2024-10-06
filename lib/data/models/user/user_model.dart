import 'package:horti_vige/data/models/consultation_pricing/consultation_pricing.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:horti_vige/data/enums/user_type.dart';
import 'package:horti_vige/data/models/availability/availability.dart';
import 'package:horti_vige/data/models/user/specialist.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  const UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.type,
    this.profession = '',
    required this.profileUrl,
    required this.isAuthenticated,
    required this.uId,
    this.specialist,
    required this.stripeId,
    this.balance = 0,
    this.availability,
    this.fcmToken,
    this.consultationPricing,
  });

  // Create empty factory
  factory UserModel.empty() {
    return UserModel(
      id: '',
      userName: '',
      email: '',
      profileUrl: '',
      type: UserType.CUSTOMER,
      isAuthenticated: false,
      uId: '',
      stripeId: '',
      availability: Availability.empty(),
      specialist: Specialist.empty(),
      consultationPricing: ConsultationPricingModel.empty(),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  final String id;
  final String userName;
  final String email;
  final String profileUrl;
  final UserType type;
  final String profession;
  final Specialist? specialist;
  final bool isAuthenticated;
  final String uId;
  final String stripeId;
  final double balance;
  final Availability? availability;
  final String? fcmToken;
  final ConsultationPricingModel? consultationPricing;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? userName,
    String? email,
    String? profileUrl,
    UserType? type,
    String? profession,
    Specialist? specialist,
    bool? isAuthenticated,
    String? uId,
    String? stripeId,
    double? balance,
    Availability? availability,
    ConsultationPricingModel? consultationPricing,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      profileUrl: profileUrl ?? this.profileUrl,
      type: type ?? this.type,
      profession: profession ?? this.profession,
      specialist: specialist ?? this.specialist,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      uId: uId ?? this.uId,
      stripeId: stripeId ?? this.stripeId,
      balance: balance ?? this.balance,
      availability: availability ?? this.availability,
      consultationPricing: consultationPricing ?? this.consultationPricing,
    );
  }
}
