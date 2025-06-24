import 'package:json_annotation/json_annotation.dart';

part 'video_pricing_model.g.dart';

enum VideoDurationEnum {
  hour('hr'),
  minute('min');

  const VideoDurationEnum(this.title);
  final String title;
}

@JsonSerializable()
class VideoPricingModel {
  VideoPricingModel({
    required this.noOf,
    required this.duration,
    required this.price,
    required this.stripe_price_id,
    required this.stripe_product_id,
    this.isEnabled = true,
  });

  factory VideoPricingModel.fromJson(Map<String, dynamic> json) =>
      _$VideoPricingModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoPricingModelToJson(this);

  final VideoDurationEnum duration;
  final int noOf;
  final double price;
  final bool isEnabled;
  final String stripe_price_id;
  final String stripe_product_id;
}
