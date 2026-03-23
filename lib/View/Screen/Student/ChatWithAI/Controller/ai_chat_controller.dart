import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Model/ai_chat_model.dart';

class AIChatController extends GetxController {
  final textController = TextEditingController();
  final isTyping = false.obs;
  
  // Observable list to support real chat UI like ChatGPT
  final messages = <AIChatMessage>[].obs;
  
  final source = ''.obs;

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
    if (textController.text.trim().isEmpty) return;
    
    final prompt = textController.text.trim();
    textController.clear();
    
    // Add user message to UI immediately
    messages.insert(0,
      AIChatMessage(
        text: prompt,
        isUser: true,
        timestamp: DateTime.now(),
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
