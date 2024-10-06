import 'package:flutter/material.dart';
import 'package:horti_vige/data/models/consultation_pricing/consultation_pricing.dart';
import 'package:horti_vige/data/models/user/user_model.dart';
import 'package:horti_vige/providers/user_provider.dart';

class ConsultationPricingProvider extends ChangeNotifier {
  ConsultationPricingProvider({required this.userProvider});
  final UserProvider userProvider;

  ConsultationPricingModel? consultationPricingModel;

  bool _isLoading = false;
  UserModel? _user;

  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    _user = userProvider.getCurrentUser();

    if (_user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (_user!.consultationPricing != null) {
      await setConsultationPricing(_user!.consultationPricing!);
    } else {
      await setConsultationPricing(ConsultationPricingModel.empty());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setConsultationPricing(ConsultationPricingModel model) async {
    consultationPricingModel = model;
    await userProvider.updateUser(
      model: _user!.copyWith(consultationPricing: consultationPricingModel),
    );
    notifyListeners();
  }

  Future<void> updateConsultationPricing(ConsultationPricingModel model) async {
    _isLoading = true;
    notifyListeners();

    consultationPricingModel = model;
    await userProvider.updateUser(
      model: _user!.copyWith(consultationPricing: consultationPricingModel),
    );

    _isLoading = false;
    notifyListeners();
  }
}
