class TransactionModel {
  TransactionModel({
    this.transactionID,
    this.transferID,
    this.balanceTransaction,
    this.reversalsUrl,
    this.transferFromStripeID,
    this.transferToStripeID,
    this.transferFromUID,
    this.transferToUID,
    this.transferAmount,
    this.transferFee,
    this.netAmount,
    this.paymentType,
    this.persistentID,
    this.date,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    transactionID = json['transactionID'];
    transferID = json['transferID'];
    balanceTransaction = json['balance_transaction'];
    reversalsUrl = json['reversalsUrl'];
    transferFromStripeID = json['transferFromStripeID'];
    transferToStripeID = json['transferToStripeID'];
    transferFromUID = json['transferFromUID'];
    transferToUID = json['transferToUID'];
    transferAmount = json['transferAmount'];
    transferFee = json['transferFee'];
    netAmount = json['netAmount'];
    paymentType = json['paymentType'];
    persistentID = json['persistentID'];
    date = json['date'];
  }
  String? transactionID;
  String? transferID;
  String? balanceTransaction;
  String? reversalsUrl;
  String? transferFromStripeID;
  String? transferToStripeID;
  String? transferFromUID;
  String? transferToUID;
  double? transferAmount;
  double? transferFee;
  double? netAmount;
  String? paymentType;
  String? persistentID;
  String? date;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['transactionID'] = transactionID;
    data['transferID'] = transferID;
    data['balance_transaction'] = balanceTransaction;
    data['reversalsUrl'] = reversalsUrl;
    data['transferFromStripeID'] = transferFromStripeID;
    data['transferToStripeID'] = transferToStripeID;
    data['transferFromUID'] = transferFromUID;
    data['transferToUID'] = transferToUID;
    data['transferAmount'] = transferAmount;
    data['transferFee'] = transferFee;
    data['netAmount'] = netAmount;
    data['paymentType'] = paymentType;
    data['persistentID'] = persistentID;
    data['date'] = date;
    return data;
  }
}
