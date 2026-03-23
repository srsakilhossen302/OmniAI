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
      final String? sourceVal = args['source'];
      if (sourceVal != null) {
        source.value = sourceVal;
      }
      
      final String? initialMsg = args['initialMessage'];
      final File? initialImg = args['image'];

      if (initialMsg != null || initialImg != null) {
        // Decide if it should be a User message or an AI message based on source
        bool isUserMsg = (sourceVal == 'teacher_home');

        messages.insert(0,
          AIChatMessage(
            text: initialMsg ?? '',
            isUser: isUserMsg,
            timestamp: DateTime.now(),
            image: initialImg,
          )
        );

        // If it's a user message, trigger a simulated AI response
        if (isUserMsg) {
          _simulateAIResponse(initialMsg ?? 'Sent an image');
        }
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

  void _simulateAIResponse(String promptText) {
    isTyping.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isTyping.value = false;
      messages.insert(0,
        AIChatMessage(
          text: 'This is a simulated AI response to your request: "$promptText".\n\nI can help you with professional tasks like drafting emails, summarizing business reports, or planning projects!',
          isUser: false,
          timestamp: DateTime.now(),
        )
      );
    });
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
    _simulateAIResponse(prompt);
  }
}
