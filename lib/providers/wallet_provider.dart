
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:horti_vige/core/typedefs.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/data/models/transaction/transaction_model.dart';
import 'package:horti_vige/data/models/user/user_model.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';
import 'package:horti_vige/data/services/payments_service.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';

class WalletProvider extends ChangeNotifier {
  final _transCollectionRef =
      FirebaseFirestore.instance.collection('Transactions');

  final PaymentsService _paymentsService = PaymentsService();

  final _userCollectionRef = FirebaseFirestore.instance.collection('Users');

  double currentUserBalance =
      PreferenceManager.getInstance().getCurrentUser()?.balance ?? 0;

  String stripeId =
      PreferenceManager.getInstance().getCurrentUser()?.stripeId ?? '';

  UserModel? get currentUser =>
      PreferenceManager.getInstance().getCurrentUser();

  Future<JsonMap?> makePayment(double amount, String currency) async {
    try {
      final paymentIntent = await _paymentsService.createPaymentIntent(
        amount,
      );
      await _paymentsService.initPaymentSheet(
        paymentIntent,
        currentUser?.email ?? '',
        currentUser?.userName ?? '',
      );
      return paymentIntent;
    } catch (e) {
      e.logError();
    }
    return null;
  }

  //secret key of customer to recognize customer for future use...
  Future createCustomerEphemeralKeyFromId() async {
    try {
      _paymentsService.createCustomerEphemeralKeyFromId(stripeId);
    } catch (err) {
      print(err);
      throw Exception(err.toString());
    }
  }

  UserModel getCurrentUser() {
    return PreferenceManager.getInstance().getCurrentUser()!;
  }

  Future<void> saveTransaction(String id, int amount) async {
    final model = TransactionModel(
      id: id,
      amount: amount.toDouble(),
      currency: 'AED',
      description: 'Amount Top Up',
      userId: PreferenceManager.getInstance().getCurrentUser()!.id,
      type: TransactionType.TOPUP,
      status: TransactionStatus.COMPLETED,
      time: DateTime.now().millisecondsSinceEpoch,
    );

    await _transCollectionRef.doc(id).set(model.toJson());

    //update user balance...
    currentUserBalance += amount;
    final userModel = PreferenceManager.getInstance().getCurrentUser()!;
    PreferenceManager.getInstance().saveUserModelInPref(
      userModel.copyWith(
        balance: currentUserBalance,
      ),
    );
    await _userCollectionRef
        .doc(userModel.id)
        .update({'balance': currentUserBalance});
    notifyListeners();
  }

  Future<String> requestWithdrawAmount(int amount) async {
    if (amount > currentUserBalance) {
      return "You don't have enough balance to withdraw";
    }
    final id = _transCollectionRef.doc().id;
    final model = TransactionModel(
      id: id,
      amount: amount.toDouble(),
      currency: 'AED',
      userId: PreferenceManager.getInstance().getCurrentUser()!.id,
      type: TransactionType.WITHDRAW,
      status: TransactionStatus.PENDING,
      description: 'Amount Withdraw',
      time: DateTime.now().millisecondsSinceEpoch,
    );
    await _transCollectionRef.doc(id).set(model.toJson());
    currentUserBalance -= amount;
    final userModel = PreferenceManager.getInstance().getCurrentUser()!;
    PreferenceManager.getInstance().saveUserModelInPref(
      userModel.copyWith(
        balance: currentUserBalance,
      ),
    );
    await _userCollectionRef
        .doc(userModel.id)
        .update({'balance': currentUserBalance});
    notifyListeners();

    return 'Withdraw request submitted successfully!';
  }

  Stream<List<TransactionModel>> streamMyTransactions() {
    return _transCollectionRef
        .where(
          'userId',
          isEqualTo: PreferenceManager.getInstance().getCurrentUser()!.uId,
        )
        .orderBy('time', descending: true)
        .snapshots()
        .map((querySnapshots) {
      final transactions = <TransactionModel>[];
      for (final DocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshots.docs) {
        transactions.add(TransactionModel.fromJson(doc.data()!));
      }
      return transactions;
    });
  }
}
