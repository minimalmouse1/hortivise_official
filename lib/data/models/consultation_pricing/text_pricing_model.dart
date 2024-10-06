// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'text_pricing_model.g.dart';

@JsonSerializable()
class TextPricingModel {
  TextPricingModel({
    required this.noOfTexts,
    required this.price,
    this.isEnabled = true,
  });

  factory TextPricingModel.fromJson(Map<String, dynamic> json) =>
      _$TextPricingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TextPricingModelToJson(this);

  final int noOfTexts;
  final double price;
  final bool isEnabled;

  TextPricingModel copyWith({
    int? noOfTexts,
    double? price,
    bool? isEnabled,
  }) {
    return TextPricingModel(
      noOfTexts: noOfTexts ?? this.noOfTexts,
      price: price ?? this.price,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
