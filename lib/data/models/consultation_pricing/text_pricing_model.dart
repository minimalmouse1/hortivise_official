// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'text_pricing_model.g.dart';

@JsonSerializable()
class TextPricingModel {
  TextPricingModel({
    required this.noOfTexts,
    required this.price,
    required this.stripe_price_id,
    required this.stripe_product_id,

    this.isEnabled = true,
  });

  factory TextPricingModel.fromJson(Map<String, dynamic> json) =>
      _$TextPricingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TextPricingModelToJson(this);

  final int noOfTexts;
  final String stripe_price_id;
  final String stripe_product_id;
  final double price;
  final bool isEnabled;

  TextPricingModel copyWith({
    int? noOfTexts,
    String? stripe_price_id,
    String? stripe_product_id,
    double? price,
    bool? isEnabled,
  }) {
    return TextPricingModel(
      noOfTexts: noOfTexts ?? this.noOfTexts,
      price: price ?? this.price,
      stripe_price_id: this.stripe_price_id,
      stripe_product_id: this.stripe_product_id,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
