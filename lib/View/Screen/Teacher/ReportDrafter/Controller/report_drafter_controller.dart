import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Student/ChatWithAI/View/ai_chat_screen.dart';

class ReportDrafterController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedReportType = Rx<String?>(null);
  
  final reportTypes = [
    'Annual Report',
    'Monthly Performance',
    'Academic Assignment',
    'Project Proposal',
    'Business Case',
    'Technical Review',
  ];

  void generateReport() {
    if (selectedReportType.value == null || titleController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields');
      return;
    }

    // Navigate to Chat Screen with context
    Get.to(() => const AIChatScreen(), arguments: {
      'source': 'report_drafter',
      'type': selectedReportType.value,
      'title': titleController.text,
      'description': descriptionController.text,
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
