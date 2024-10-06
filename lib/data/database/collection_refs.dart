import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'collection_names.dart';

class CollectionRefs {
  CollectionRefs._();

  static final _db = FirebaseFirestore.instance;

  static final uid = FirebaseAuth.instance.currentUser!.uid;

  static CollectionReference<Map<String, dynamic>> get users =>
      _db.collection(_users);

  static CollectionReference<Map<String, dynamic>> get consultations =>
      _db.collection(_consultations);
}
