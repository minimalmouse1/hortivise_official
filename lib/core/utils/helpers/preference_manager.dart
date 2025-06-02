import 'dart:convert';
import 'package:horti_vige/data/models/user/user_model.dart';
import 'package:horti_vige/data/services/stripe.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/core/utils/app_consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  PreferenceManager._();

  late SharedPreferences _prefs;
  static final PreferenceManager _instance = PreferenceManager._();

  static PreferenceManager getInstance() {
    return _instance;
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> deleteUser() {
    return _prefs.remove(Constants.userModel);
  }

  // Authentication token methods
  Future<void> saveAuthToken(String token) async {
    try {
      await _prefs.setString(Constants.authToken, token);
      print(
          'Token stored successfully in SharedPreferences with key: ${Constants.authToken}');
      print(
          'Stored token: ${token.substring(0, 20)}...'); // Show first 20 characters for security
    } catch (e) {
      e.logError();
    }
  }

  String? getAuthToken() {
    return _prefs.getString(Constants.authToken);
  }

  Future<bool> deleteAuthToken() {
    return _prefs.remove(Constants.authToken);
  }

  UserModel? getCurrentUser() {
    final userString = _prefs.getString(Constants.userModel);
    if (userString == null) {
      return null;
    } else {
      final Map<String, dynamic> user = jsonDecode(userString);

      final model = UserModel.fromJson(user);
      if (model.specialist != null && model.specialist!.stripeId != '') {
        StripeController.instance.initStripe(model.specialist!.stripeId);
      }
      return model;
    }
  }

  Future<void> saveUserModelInPref(UserModel? userModel) async {
    try {
      await _prefs.setString(
        Constants.userModel,
        jsonEncode(userModel!.toJson()),
      );
    } catch (e) {
      e.logError();
    }
  }
}
