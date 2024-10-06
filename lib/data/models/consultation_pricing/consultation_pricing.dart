// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:horti_vige/data/models/consultation_pricing/text_pricing_model.dart';
import 'package:horti_vige/data/models/consultation_pricing/video_pricing_model.dart';

part 'consultation_pricing.g.dart';

@JsonSerializable()
class ConsultationPricingModel {
  ConsultationPricingModel({
    required this.textPackages,
    required this.videoPackages,
  });

  // create empty factory
  factory ConsultationPricingModel.empty() {
    return ConsultationPricingModel(
      textPackages: [],
      videoPackages: [],
    );
  }

  factory ConsultationPricingModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationPricingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultationPricingModelToJson(this);

  final List<TextPricingModel> textPackages;
  final List<VideoPricingModel> videoPackages;

  ConsultationPricingModel copyWith({
    List<TextPricingModel>? textPackages,
    List<VideoPricingModel>? videoPackages,
  }) {
    return ConsultationPricingModel(
      textPackages: textPackages ?? this.textPackages,
      videoPackages: videoPackages ?? this.videoPackages,
    );
  }

  List<VideoPricingModel> getVideoPackages() {
    return videoPackages.where((e) => e.isEnabled).toList();
  }

  List<TextPricingModel> getTextPackages() {
    return textPackages.where((e) => e.isEnabled).toList();
  }
}
