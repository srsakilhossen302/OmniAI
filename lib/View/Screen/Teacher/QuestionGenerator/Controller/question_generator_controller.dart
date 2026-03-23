import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Student/ChatWithAI/View/ai_chat_screen.dart';

class QuestionGeneratorController extends GetxController {
  final currentStep = 0.obs;

  // Selections
  final selectedCategory = ''.obs;
  final selectedGroup = ''.obs;
  final selectedDepartment = ''.obs;
  final selectedExamType = ''.obs;
  final selectedSemester = ''.obs;
  
  final subjectController = TextEditingController();
  final topicController = TextEditingController();

  // Data Synced with RoleSelectionController
  final List<String> categories = [
    'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10',
    'Class 11 (HSC 1st Year)', 'Class 12 (HSC 2nd Year)',
    'Honors', 'Masters', 'diploma', 'others'
  ];

  final List<String> groups = ['science', 'commerce', 'humanities'];

  final List<String> departments = [
    'Computer', 'Civil', 'Electrical', 'Mechanical', 'Electronics',
    'Power', 'Textile', 'Architecture', 'Automobile', 'others'
  ];

  final List<String> semesters = [
    '1st Semester', '2nd Semester', '3rd Semester', '4th Semester',
    '5th Semester', '6th Semester', '7th Semester', '8th Semester',
  ];

  final List<String> examTypes = ['Final', 'Half-Yearly', 'Test'];

  @override
  void onClose() {
    subjectController.dispose();
    topicController.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    } else {
      generateQuestion();
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // Logic checks synced with RoleSelectionController
  bool get showGroupSelection {
    final sc = selectedCategory.value;
    return sc == 'Class 9' || sc == 'Class 10' || 
           sc == 'Class 11 (HSC 1st Year)' || sc == 'Class 12 (HSC 2nd Year)';
  }

  bool get isDiplomaSelected => selectedCategory.value.toLowerCase() == 'diploma';

  bool get canProceed {
    if (currentStep.value == 0) return selectedCategory.value.isNotEmpty;
    if (currentStep.value == 1) {
      if (showGroupSelection) return selectedGroup.value.isNotEmpty;
      if (isDiplomaSelected) return selectedDepartment.value.isNotEmpty;
      return true; // Honors/Masters skip this
    }
    if (currentStep.value == 2) {
      if (isDiplomaSelected) return selectedSemester.value.isNotEmpty;
      if (selectedCategory.value.startsWith('Class')) return selectedExamType.value.isNotEmpty;
      return true;
    }
    return subjectController.text.isNotEmpty;
  }

  void generateQuestion() {
    String prompt = "Generate a formal Question Paper based on following details:\n";
    prompt += "Category: ${selectedCategory.value}\n";
    if (selectedGroup.value.isNotEmpty) prompt += "Group: ${selectedGroup.value.tr}\n";
    if (selectedDepartment.value.isNotEmpty) prompt += "Department: ${selectedDepartment.value}\n";
    if (selectedSemester.value.isNotEmpty) prompt += "Semester: ${selectedSemester.value}\n";
    if (selectedExamType.value.isNotEmpty) prompt += "Exam Type: ${selectedExamType.value}\n";
    prompt += "Subject: ${subjectController.text}\n";
    prompt += "Topics to cover: ${topicController.text}\n";
    prompt += "\nPlease format it as a proper exam paper with marks distribution and sections.";

    Get.to(() => const AIChatScreen(), arguments: {
      'initialMessage': prompt,
      'source': 'question_generator'
    });
  }
}
