import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omniai/service/ai_service.dart';
import 'package:omniai/service/firebase_service.dart';
import '../Model/ai_chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class AIChatController extends GetxController {
  final textController = TextEditingController();
  final isTyping = false.obs;
  final messages = <AIChatMessage>[].obs;
  final source = ''.obs;

  final selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final FlutterTts _flutterTts = FlutterTts();

  final AIService _aiService = Get.find<AIService>();
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  Future<void> pickCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> pickGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  // User Context
  final userRole = ''.obs;
  final userCountry = ''.obs;
  final userClass = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserContext();
    _loadChatHistory();
    
    final args = Get.arguments;
    if (args != null) {
      source.value = args['source'] ?? '';
      final String? initialMsg = args['initialMessage'];
      final File? initialImg = args['image'];

      if (initialMsg != null || initialImg != null) {
        bool isUserMsg = (source.value == 'teacher_home');
        final msg = AIChatMessage(
          text: initialMsg ?? '',
          isUser: isUserMsg,
          timestamp: DateTime.now(),
          image: initialImg,
        );
        messages.insert(0, msg);
        if (isUserMsg) _getRealAIResponse(initialMsg ?? 'Process this request');
      }
    }
  }

  Future<void> _fetchUserContext() async {
    final user = _firebaseService.auth.currentUser;
    if (user != null) {
      final doc = await _firebaseService.getUserProfile(user.uid);
      if (doc != null && doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        userRole.value = data['role'] ?? 'unknown';
        userCountry.value = data['country'] ?? 'unknown';
        userClass.value = data['class'] ?? data['profession'] ?? 'unknown';
      }
    }
  }

  Future<void> _loadChatHistory() async {
    final user = _firebaseService.auth.currentUser;
    if (user == null) return;
    try {
      final snapshot = await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        messages.addAll(snapshot.docs.map((doc) => AIChatMessage(
          text: doc['text'] ?? '',
          isUser: doc['isUser'] ?? false,
          timestamp: (doc['timestamp'] as Timestamp).toDate(),
        )));
      } else {
        messages.add(AIChatMessage(
          text: 'Hello! I am OmniAI.\nHow can I help you today?',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }
    } catch (e) { print("Error: $e"); }
  }

  Future<void> _getRealAIResponse(String promptText) async {
    isTyping.value = true;
    try {
      // Create context-aware prompt
      final contextPrompt = "Customer context: Role: ${userRole.value}, Country: ${userCountry.value}, Level: ${userClass.value}.\n"
          "Please answer the following request based on this context if relevant:\n$promptText";

      final response = await _aiService.sendMessage(contextPrompt);
      final aiMessage = AIChatMessage(text: response, isUser: false, timestamp: DateTime.now());
      messages.insert(0, aiMessage);
      
      final uid = _firebaseService.auth.currentUser?.uid;
      if (uid != null) await _firebaseService.saveChatMessage(uid: uid, text: response, isUser: false);
    } catch (e) { print("AI Error: $e"); }
    finally { isTyping.value = false; }
  }

  void sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty && selectedImage.value == null) return;
    
    final prompt = text;
    textController.clear();
    final img = selectedImage.value;
    selectedImage.value = null;

    final userMessage = AIChatMessage(text: prompt, isUser: true, timestamp: DateTime.now(), image: img);
    messages.insert(0, userMessage);
    
    final uid = _firebaseService.auth.currentUser?.uid;
    if (uid != null) await _firebaseService.saveChatMessage(uid: uid, text: prompt, isUser: true);
    
    _getRealAIResponse(prompt);
  }

  // Text to Speech
  Future<void> speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  // Export to PDF
  Future<void> downloadAsPDF(String text) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(child: pw.Text(text));
    }));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/OmniAI_Response_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    
    await OpenFilex.open(file.path);
  }

  @override
  void onClose() {
    textController.dispose();
    _flutterTts.stop();
    super.onClose();
  }
}
