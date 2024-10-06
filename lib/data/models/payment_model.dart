class PaymentModel {
  PaymentModel({
    this.paymentId,
    this.transactionStripeId,
    this.paymentIntentId,
    this.amount,
    this.stripeFee,
    this.netAmount,
    this.exchangeRate,
    this.toStripeId,
    this.fromUserId,
    required this.data,
    required this.consultationId,
  });

  PaymentModel.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    transactionStripeId = json['transactionStripeId'];
    paymentIntentId = json['paymentIntentId'];
    amount = json['amount'];
    stripeFee = json['stripeFee'];
    netAmount = json['netAmount'];
    exchangeRate = json['exchangeRate'];
    toStripeId = json['toStripeId'];
    fromUserId = json['fromUserId'];
    data = json['data'];
    consultationId = json['consultationId'];
  }
  String? paymentId;
  String? transactionStripeId;
  String? paymentIntentId;
  double? amount;
  double? stripeFee;
  double? netAmount;
  double? exchangeRate;
  String? toStripeId;
  String? fromUserId;
  String? consultationId;
  DateTime? data;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['paymentId'] = paymentId;
    data['transactionStripeId'] = transactionStripeId;
    data['paymentIntentId'] = paymentIntentId;
    data['amount'] = amount;
    data['stripeFee'] = stripeFee;
    data['netAmount'] = netAmount;
    data['exchangeRate'] = exchangeRate;
    data['toStripeId'] = toStripeId;
    data['fromUserId'] = fromUserId;
    data['data'] = data;
    data['consultationId'] = consultationId;
    return data;
  }
}
