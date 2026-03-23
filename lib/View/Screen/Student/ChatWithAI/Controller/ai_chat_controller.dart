import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Model/ai_chat_model.dart';

class AIChatController extends GetxController {
  final textController = TextEditingController();
  final isTyping = false.obs;
  
  // Observable list to support real chat UI like ChatGPT
  final messages = <AIChatMessage>[].obs;
  
  final source = ''.obs;

  // Image Picking
  final selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

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

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args != null) {
      if (args['source'] != null) {
        source.value = args['source'];
      }
      if (args['initialMessage'] != null) {
      messages.insert(0,
        AIChatMessage(
          text: args['initialMessage'],
          isUser: false,
          timestamp: DateTime.now(),
        )
      );
      }
    } else {
      messages.insert(0,
        AIChatMessage(
          text: 'Hello! I am OmniAI, your intelligent companion.\n\nI can help you:\n- Solve math equations\n- Draft complete structured assignments\n- Explain complex topics\n\nHow can I help you today?',
          isUser: false,
          timestamp: DateTime.now(),
        )
      );
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty && selectedImage.value == null) return;
    
    final prompt = text;
    final img = selectedImage.value;
    
    // Clear Input
    textController.clear();
    selectedImage.value = null;
    
    // Add user message to UI immediately
    messages.insert(0,
      AIChatMessage(
        text: prompt,
        isUser: true,
        timestamp: DateTime.now(),
        image: img,
      )
    );
    
    isTyping.value = true;
    
    // Simulate AI generating a response
    Future.delayed(const Duration(seconds: 2), () {
      isTyping.value = false;
      messages.insert(0,
        AIChatMessage(
          text: 'This is a simulated AI response to: "$prompt".\n\nI can format **bold text**, *italics*, and render seamlessly like ChatGPT.',
          isUser: false,
          timestamp: DateTime.now(),
        )
      );
    });
  }
}
