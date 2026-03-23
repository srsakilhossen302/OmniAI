import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../Model/ai_chat_model.dart';

class AIChatController extends GetxController {
  final textController = TextEditingController();
  final isTyping = false.obs;
  
  // Observable list to support real chat UI like ChatGPT
  final messages = <AIChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Start with a generated scanner response
    messages.insert(0,
      AIChatMessage(
        text: '''**Solution: Quadratic Equation**

To solve **x² + 5x + 6 = 0**, we can use the factoring method.

### Step 1: Identify the equation
The equation is in standard form: **ax² + bx + c = 0**
Where:
- a = **1**
- b = **5**
- c = **6**

### Step 2: Factor the equation
We need to find two numbers that:
- Multiply to give **c (6)**
- Add up to give **b (5)**

The numbers are **2** and **3** because:
`2 + 3 = 5`
`2 × 3 = 6`

Is there anything else you need help with?''',
        isUser: false,
        timestamp: DateTime.now(),
      )
    );
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
