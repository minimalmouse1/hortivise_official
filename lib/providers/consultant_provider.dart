import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:horti_vige/core/services/api.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/data/models/availability/availability.dart';
import 'package:horti_vige/data/models/user/specialist.dart';
import 'package:horti_vige/data/models/user/user_model.dart';
import 'package:horti_vige/data/services/auth_service.dart';
import 'package:horti_vige/ui/utils/extensions/validation_helpers.dart';

class ConsultantProvider extends ChangeNotifier {
  final _userCollectionRef = FirebaseFirestore.instance.collection('Users');
  final _authService = AuthService();

  // Form fields
  String _consultantName = '';
  String _consultantEmail = '';
  String _category = '';
  String _bio = '';
  String _consultantPassword = '';

  // Form errors
  String? _consultantNameError;
  String? _consultantEmailError;
  String? _categoryError;
  String? _bioError;
  String? _passwordError;

  // Getters
  String get consultantName => _consultantName;
  String get consultantEmail => _consultantEmail;
  String get category => _category;
  String get bio => _bio;
  String get consultantPassword => _consultantPassword;

  String? get consultantNameError => _consultantNameError;
  String? get consultantEmailError => _consultantEmailError;
  String? get categoryError => _categoryError;
  String? get bioError => _bioError;
  String? get passwordError => _passwordError;

  // Setters with validation
  void setConsultantName(String value) {
    _consultantName = value;
    _consultantNameError = isUserNameValid(value);
    notifyListeners();
  }

  void setHortistEmail(String value) {
    _consultantEmail = value;
    _consultantEmailError = isEmailValid(value);
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    _categoryError = null;
    notifyListeners();
  }

  void setBio(String value) {
    _bio = value;
    _bioError = isBioValid(value);
    notifyListeners();
  }

  void setConsultantPassword(String value) {
    _consultantPassword = value;
    _passwordError = isPasswordValid(value);
    notifyListeners();
  }

  // Validation helper
  String? isPasswordValid(String password) {
    if (password.isEmpty || password.length < 6) {
      return 'Password must be at-least 6 characters';
    }
    return null;
  }

  // Form validation
  bool isFormValid() {
    return _consultantNameError == null &&
        _consultantEmailError == null &&
        _categoryError == null &&
        _bioError == null &&
        _passwordError == null &&
        _consultantName.isNotEmpty &&
        _consultantEmail.isNotEmpty &&
        _category.isNotEmpty &&
        _bio.isNotEmpty &&
        _consultantPassword.isNotEmpty;
  }

  // Clear all errors
  void clearErrors() {
    _consultantNameError = null;
    _consultantEmailError = null;
    _categoryError = null;
    _bioError = null;
    _passwordError = null;
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    _consultantName = '';
    _consultantEmail = '';
    _category = '';
    _bio = '';
    _consultantPassword = '';
    clearErrors();
  }

  Future<String> sendSpecialistRequest(
      {required String name,
      required String email,
      required String category,
      required String bio,
      required String password}) async {
    final stripeId = await _createStripeUser(name, email, UserType.SPECIALIST);
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final placeHolderName = getPlaceHolderName(name);
    final userModel = UserModel(
      id: _userCollectionRef.doc().id,
      userName: name,
      email: email,
      // password: password,
      stripeId: stripeId,
      type: UserType.SPECIALIST,
      profileUrl:
          'https://ui-avatars.com/api/?name=$placeHolderName&background=random&size=200',
      // 'https://firebasestorage.googleapis.com/v0/b/hortivige.appspot.com/o/defaults%2FDefault_pfp.svg.png?alt=media&token=acdad01c-7608-421c-b7cd-df899bf00feb&_gl=1*630m8s*_ga*MTYyNjI3NTU0MC4xNjk0NTkzODc3*_ga_CW55HF8NVT*MTY5NjY4Mjc5MS40Mi4xLjE2OTY2ODI4NjQuNDcuMC4w',
      isAuthenticated: true,
      specialist: Specialist(
        isStripeActive: false,
        stripeId: stripeId,
        professionalName: name,
        email: email,
        bio: bio,
        category: SpecialistCategory.values.byName(category),
      ),
      availability: Availability(
        defaultFrom: const TimeOfDay(hour: 09, minute: 0),
        defaultTo: const TimeOfDay(hour: 18, minute: 0),
        timeZone: currentTimeZone,
        days: const [],
      ), uId: '',
    );

    debugPrint(
        '👤 Created UserModel with specialist status: ${userModel.specialist?.status}');
    debugPrint('🔍 Specialist details:');
    debugPrint(
        '   - Professional Name: ${userModel.specialist?.professionalName}');
    debugPrint('   - Email: ${userModel.specialist?.email}');
    debugPrint('   - Stripe ID: ${userModel.specialist?.stripeId}');
    debugPrint(
        '   - Is Stripe Active: ${userModel.specialist?.isStripeActive}');
    debugPrint('   - Status: ${userModel.specialist?.status}');

    final docs =
        await _userCollectionRef.where('email', isEqualTo: email).get();
    print(userModel.toJson());
    if (docs.docs.isNotEmpty) {
      return Future.error('User already exist with provided email');
    } else {
      // run signup function here
      try {
        final user = await _authService.createUserWithEmailAndPassword(
          email,
          password,
        );
        await _userCollectionRef.doc(userModel.email).set(userModel.toJson());
        return 'Request submitted successfully!';
      } catch (e) {
        debugPrint('error in consultant signup: ${e.toString()}');
      }
      return 'Error in Request submission . Try again later!';
    }
  }

  Future<String> _createStripeUser(
    String name,
    String email,
    UserType type,
  ) async {
    final api = Api();
    debugPrint(
        '🚀 Calling API: https://payment.hortivise.com/api/v1/consultants');
    debugPrint('📤 Sending data: {"first_name": "$name", "email": "$email"}');

    final response = await api.request(
      path: '/consultants',
      method: 'POST',
      data: {
        'first_name': name,
        'email': email,
      },
    );

    debugPrint('📥 Full API response: $response');
    final responseData = response.data;
    debugPrint('📋 Response data: $responseData');

    final stripeAccountId = responseData['result']['stripe_account_id'] ?? '';
    debugPrint('💳 Stripe Account ID: $stripeAccountId');

    // Check if there's any status information in the response
    if (responseData['result'] != null) {
      debugPrint('🔍 Checking for status in response...');
      final result = responseData['result'];
      if (result['status'] != null) {
        debugPrint('📊 Status from API: ${result['status']}');
      }
      if (result['verification_status'] != null) {
        debugPrint('✅ Verification status: ${result['verification_status']}');
      }
    }

    return stripeAccountId;
  }

  String getPlaceHolderName(String name) {
    final words = name.split(' ');
    if (words.length == 1) return words.first;
    if (words.length > 1) return words.first + words[1];
    return name;
  }
}
