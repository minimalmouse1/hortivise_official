import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:horti_vige/core/exceptions/app_exception.dart';
import 'package:horti_vige/core/services/api.dart';
import 'package:horti_vige/data/enums/enums.dart';
import 'package:horti_vige/data/models/availability/availability.dart';
import 'package:horti_vige/data/models/user/specialist.dart';
import 'package:horti_vige/data/models/user/user_model.dart';
import 'package:horti_vige/data/repositories/user_repository.dart';
import 'package:horti_vige/data/services/auth_service.dart';
import 'package:horti_vige/data/services/stripe.dart';
import 'package:horti_vige/ui/screens/common/profile_screen.dart';
import 'package:horti_vige/ui/utils/extensions/extensions.dart';
import 'package:horti_vige/core/utils/helpers/preference_manager.dart';
import 'package:horti_vige/ui/widgets/app_nav_drawer.dart';

class UserProvider extends ChangeNotifier {
  final _authService = AuthService();
  final _userCollectionRef = FirebaseFirestore.instance.collection('Users');
  final _profilesStoreRef =
      FirebaseStorage.instance.ref().child('UsersProfiles');
  final _firebaseAuth = FirebaseAuth.instance;
  final _prefManager = PreferenceManager.getInstance();

  final List<UserModel> _specialistsList = [];

  var _selectedCat = 'All';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> signUpNewUser({
    required String name,
    required String email,
    required String password,
    required UserType type,
    String profileUrl = '',
  }) async {
    try {
      final user = await _authService.createUserWithEmailAndPassword(
        email,
        password,
      );
      final stripeId = await _createStripeUser(name, email, type);
      final model = UserModel(
        id: user.uid,
        userName: name,
        email: email,
        profileUrl: profileUrl,
        uId: user.uid,
        isAuthenticated: true,
        type: type,
        stripeId: stripeId,
      );
      await UserRepository.createUser(model);
      await _prefManager.saveUserModelInPref(model);

      if (profileUrl.isNotEmpty) {
        await updateProfilePhoto(profileUri: profileUrl);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        title: 'Something went wrong',
        message: e.toString(),
      );
    }
    notifyListeners();
  }

  Future<void> updateUser({required UserModel model}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await UserRepository.updateUser(model);
      if (model.type == UserType.SPECIALIST && bioController.text.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(model.email)
            .update({
          'specialist.bio': bioController.text.trim(),
        });
      }
      _prefManager.saveUserModelInPref(model);
    } catch (e) {
      e.logError();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateFCMToken() async {
    try {
      if (_firebaseAuth.currentUser == null) return;
      final user = await UserRepository.get(_authService.currentUser!.email!);
      if (user == null) return;

      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) return;
      if (fcmToken.isNotEmpty && fcmToken != user.fcmToken) {
        await UserRepository.saveFCMToken(user.email, fcmToken);
      }
    } on AppException catch (e) {
      e.message.logError();
    } catch (e) {
      e.logError();
    }
  }

  Stream<UserModel> getUserStream() {
    return UserRepository.getUserStream(_firebaseAuth.currentUser!.email!);
  }

  Future<void> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _authService.signInWithEmailAndPassword(
        email,
        password,
      );

      final appUser = await UserRepository.get(email);
      if (appUser == null) {
        Future.error('User not found, please check your email or password');
      } else {
        if (appUser.specialist != null && appUser.specialist!.stripeId != '') {
          StripeController.instance.initStripe(appUser.specialist!.stripeId);
        }
        await _prefManager.saveUserModelInPref(appUser);
        Navigator.pushNamed(context, ZoomDrawerScreen.userHome);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        title: 'Something went wrong',
        message: e.toString(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // change password
  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    return _authService.changePassword(oldPassword, newPassword);
  }

  Future<void> updateProfilePhoto({String profileUri = ''}) async {
    final profileImageRef =
        _profilesStoreRef.child(Uri.parse(profileUri).pathSegments.last);
    final file = File(profileUri);
    await profileImageRef.putFile(file);
    final downloadUrl = await profileImageRef.getDownloadURL();
    final map = <String, dynamic>{};
    map['profileUrl'] = downloadUrl;
    await _userCollectionRef
        .doc(FirebaseAuth.instance.currentUser?.email)
        .update(map);
    final model = _prefManager.getCurrentUser();
    _prefManager.saveUserModelInPref(
      model?.copyWith(
        profileUrl: downloadUrl,
      ),
    );
    notifyListeners();
  }

  UserModel? getCurrentUser() {
    return _prefManager.getCurrentUser();
  }

  UserType getCurrentUserType() {
    return _prefManager.getCurrentUser()?.type ?? UserType.CUSTOMER;
  }

  // Future<String> sendSpecialistRequest(
  //     {required String name,
  //     required String email,
  //     required String category,
  //     required String bio,
  //     required String password}) async {
  //   final stripeId = await _createStripeUser(name, email, UserType.SPECIALIST);
  //   final currentTimeZone = await FlutterTimezone.getLocalTimezone();
  //   final placeHolderName = getPlaceHolderName(name);
  //   final userModel = UserModel(
  //     id: _userCollectionRef.doc().id,
  //     userName: name,
  //     email: email,
  //     stripeId: stripeId,
  //     type: UserType.SPECIALIST,
  //     profileUrl:
  //         'https://ui-avatars.com/api/?name=$placeHolderName&background=random&size=200',
  //     // 'https://firebasestorage.googleapis.com/v0/b/hortivige.appspot.com/o/defaults%2FDefault_pfp.svg.png?alt=media&token=acdad01c-7608-421c-b7cd-df899bf00feb&_gl=1*630m8s*_ga*MTYyNjI3NTU0MC4xNjk0NTkzODc3*_ga_CW55HF8NVT*MTY5NjY4Mjc5MS40Mi4xLjE2OTY2ODI4NjQuNDcuMC4w',
  //     uId: '',
  //     isAuthenticated: true,
  //     specialist: Specialist(
  //       isStripeActive: false,
  //       stripeId: stripeId,
  //       professionalName: name,
  //       email: email,
  //       bio: bio,
  //       category: SpecialistCategory.values.byName(category),
  //     ),
  //     availability: Availability(
  //       defaultFrom: const TimeOfDay(hour: 09, minute: 0),
  //       defaultTo: const TimeOfDay(hour: 18, minute: 0),
  //       timeZone: currentTimeZone,
  //       days: const [],
  //     ),
  //   );
  //
  //   final docs =
  //       await _userCollectionRef.where('email', isEqualTo: email).get();
  //   print(userModel.toJson());
  //   if (docs.docs.isNotEmpty) {
  //     return Future.error('User already exist with provided email');
  //   } else {
  //     // run signup function here
  //     try {
  //       final user = await _authService.createUserWithEmailAndPassword(
  //         email,
  //         password,
  //       );
  //       await _userCollectionRef.doc(userModel.email).set(userModel.toJson());
  //       return 'Request submitted successfully!';
  //     } catch (e) {
  //       debugPrint('error in consultant signup: ${e.toString()}');
  //     }
  //     return 'Error in Request submission . Try again later!';
  //   }
  // }

  String getPlaceHolderName(String name) {
    final words = name.split(' ');
    if (words.length == 1) return words.first;
    if (words.length > 1) return words.first + words[1];
    return name;
  }

  Future<List<UserModel>> getAllSpecialistUsers() async {
    final querySnapshots = await _userCollectionRef
        .where('type', isEqualTo: UserType.SPECIALIST.name)
        .get();
    _specialistsList.clear();

    for (final element in querySnapshots.docs) {
      final data = element.data();
      debugPrint('Raw data from Firestore: $data');

      final model = UserModel.fromJson(data);

      // Debug print stripe status
      debugPrint('Parsed Stripe Status: ${model.toJson()}');

      if (model.specialist?.isStripeActive == true) {
        _specialistsList.add(model);
      }
    }
    return _specialistsList;
  }

  List<UserModel> getSpecialistsByCat({required String catName}) {
    if (catName.toLowerCase() == 'all') {
      return _specialistsList;
    } else {
      return _specialistsList
          .where((element) => element.specialist != null)
          .where((element) => element.specialist!.category.name == catName)
          .toList();
    }
  }

  Future<void> logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      _prefManager.deleteUser();
    } catch (e) {
      e.logError();
    }
  }

  void setCategory(String cat) {
    _selectedCat = cat;
    notifyListeners();
  }

  String getSelectedCat() {
    return _selectedCat;
  }

  Future<String> _createStripeUser(
    String name,
    String email,
    UserType type,
  ) async {
    final api = Api();
    // await StripeController.instance.createStripeAccount(email);

    final response = await api.request(
      path: '/consultants',
      method: 'POST',
      data: {
        'first_name': name,
        'email': email,
      },
    );
    debugPrint('consultant response ==> $response');
    final responseData = response.data;
    debugPrint(
        'consultant response data ==> ${responseData['result']['stripe_account_id']}');

    return responseData['result']['stripe_account_id'] ?? '';

    // return StripeController.instance.getAccountId() ?? '';

    // final body = <String, dynamic>{
    //   'name': name,
    //   'email': email,
    //   'description': 'New Stripe ${type.name} user is created',
    //   //'customer': getCurrentUserId()
    // };
    // final response = await http.post(
    //   Uri.parse('https://api.stripe.com/v1/customers'),
    //   headers: {
    //     'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
    //     'Content-Type': 'application/x-www-form-urlencoded',
    //   },
    //   body: body,
    // );
    // print('stripe customer created -> $response');
    // final customerJson = json.decode(response.body);
    // print('stripe customer created -> $customerJson');
    // return customerJson['id'];
  }

  void clearUser() {
    _prefManager.deleteUser();
    notifyListeners();
  }
}
