import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Observable for current user
  late Rx<User?> currentUser;

  @override
  void onInit() {
    super.onInit();
    currentUser = Rx<User?>(auth.currentUser);
    auth.userChanges().listen((User? user) {
      currentUser.value = user;
    });
  }

  // Common method to save user profile
  Future<void> saveUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      await firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      print("Error saving user profile: $e");
      rethrow;
    }
  }

  // Get user profile
  Future<DocumentSnapshot?> getUserProfile(String uid) async {
    try {
      return await firestore.collection('users').doc(uid).get();
    } catch (e) {
      print("Error getting user profile: $e");
      return null;
    }
  }
}
