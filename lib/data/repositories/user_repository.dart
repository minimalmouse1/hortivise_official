import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:horti_vige/core/exceptions/app_exception.dart';
import 'package:horti_vige/data/database/collection_refs.dart';
import 'package:horti_vige/data/models/user/user_model.dart';

class UserRepository {
  UserRepository._();

  static Future<UserModel?> get(String email) async {
    try {
      final user = await CollectionRefs.users.doc(email).get();
      if (user.data() == null) return null;
      return UserModel.fromJson(user.data()!);
    } on FirebaseException catch (e) {
      throw AppException(
        title: 'Getting user data failed',
        message: e.message ?? 'Something went wrong',
      );
    } catch (e) {
      throw AppException(
        title: 'Getting user data failed',
        message: e.toString(),
      );
    }
  }

  static Stream<UserModel> getUserStream(String email) {
    try {
      return CollectionRefs.users
          .doc(email)
          .snapshots()
          .map((event) => UserModel.fromJson(event.data()!));
    } on FirebaseException catch (e) {
      throw AppException(
        title: 'Getting user data failed',
        message: e.message ?? 'Something went wrong',
      );
    }
  }

  static Future<void> saveFCMToken(String email, String fcmToken) async {
    try {
      await CollectionRefs.users.doc(email).update({
        'fcmToken': fcmToken,
      });
    } on FirebaseException catch (e) {
      throw AppException(
        message: e.message ?? '',
        title: 'Error deleting user',
      );
    }
  }

  static Future<void> updateUser(UserModel user) async {
    try {
      await CollectionRefs.users.doc(user.email).update(user.toJson());
    } on FirebaseException catch (e) {
      throw AppException(
        message: e.message ?? '',
        title: 'Error updating user',
      );
    }
  }

  static Future<void> createUser(UserModel user) async {
    try {
      await CollectionRefs.users.doc(user.email).set(user.toJson());
    } on FirebaseException catch (e) {
      throw AppException(
        message: e.message ?? '',
        title: 'Error creating user',
      );
    }
  }
}
