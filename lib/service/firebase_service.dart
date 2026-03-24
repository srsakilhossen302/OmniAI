import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Rx<User?> currentUser;

  @override
  void onInit() {
    super.onInit();
    currentUser = Rx<User?>(auth.currentUser);
    auth.userChanges().listen((User? user) {
      currentUser.value = user;
    });
  }

  // Login anonymously and return the user
  Future<User?> loginAnonymously() async {
    try {
      UserCredential userCredential = await auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print("Firebase Anonymous Login Error: $e");
      return null;
    }
  }

  // Check if user has a profile in Firestore
  Future<bool> hasCompletedProfile(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Save user profile
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

  // Save AI Chat Message
  Future<void> saveChatMessage({
    required String uid,
    required String text,
    required bool isUser,
  }) async {
    try {
      await firestore.collection('users').doc(uid).collection('chats').add({
        'text': text,
        'isUser': isUser,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving chat message: $e");
    }
  }
}
