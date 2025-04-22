import 'package:horti_vige/data/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  TransactionModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.userId,
    required this.type,
    required this.status,
    required this.description,
    required this.time,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
  String id;
  double amount;

  String currency;
  String userId;

  TransactionType type;
  TransactionStatus status;

  String description;
  int time;

  String title() {
    var title = '';
    switch (type) {
      case TransactionType.TOPUP:
        title = 'TopUp Balance';
        break;
      case TransactionType.WITHDRAW:
        title = 'Withdraw Deduction';
        break;
      case TransactionType.CONSULTATION:
        title = 'Consultation Fee';
        break;
    }
    return title;
  }

  // dart run build_runner build --delete-conflicting-outputs
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
