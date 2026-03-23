import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ChatWithAI/View/ai_chat_screen.dart';

class AssignmentWriterController extends GetxController {
  final topicController = TextEditingController();
  final isGenerating = false.obs;
  final hasText = false.obs;

  @override
  void onInit() {
    super.onInit();
    topicController.addListener(() {
      hasText.value = topicController.text.trim().isNotEmpty;
    });
  }

  @override
  void onClose() {
    topicController.dispose();
    super.onClose();
  }

  void generateAssignment() {
    if (topicController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter an assignment topic.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isGenerating.value = true;
    final topic = topicController.text.trim();
    
    // Simulate AI generation delay
    Future.delayed(const Duration(seconds: 2), () {
      isGenerating.value = false;
      
      final String generatedMarkdown = '''# Assignment: $topic

## Introduction
This assignment explores the topic of "$topic" in depth, providing a comprehensive understanding of its key concepts, applications, and significance in the field.

## Objectives
1. Understand the fundamental concepts related to $topic
2. Analyze the practical applications and real-world examples
3. Evaluate the importance and impact of $topic
4. Develop critical thinking skills through research and analysis

## Main Content
### Section 1: Background and Context
$topic is an important subject that has significant relevance in modern education and professional settings. Understanding its foundation helps us appreciate its broader implications and applications.

Key points to consider:
- Historical development and evolution
- Core principles and theories
- Current trends and developments''';

      Get.to(() => const AIChatScreen(), arguments: {
        'initialMessage': generatedMarkdown,
        'source': 'assignment'
      });
      
      // Clear after sending so when user comes back it is fresh
      topicController.clear();
      hasText.value = false;
    });
  }

  void setExampleTopic(String topic) {
    topicController.text = topic;
    hasText.value = true;
  }
}
