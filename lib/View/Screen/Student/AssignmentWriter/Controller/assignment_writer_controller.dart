import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    
    // Simulate generation delay
    Future.delayed(const Duration(seconds: 2), () {
      isGenerating.value = false;
      // TODO: navigate to a generated result or chat screen
      Get.snackbar('Success', 'Assignment generated successfully!', snackPosition: SnackPosition.BOTTOM);
    });
  }

  void setExampleTopic(String topic) {
    topicController.text = topic;
    hasText.value = true;
  }
}
