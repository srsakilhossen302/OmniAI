import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ChatWithAI/View/ai_chat_screen.dart';

class ExamPrepController extends GetxController {
  final examNameController = TextEditingController();
  final bookNamesController = TextEditingController();
  
  final isGenerating = false.obs;
  final isValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    examNameController.addListener(_validate);
    bookNamesController.addListener(_validate);
  }

  void _validate() {
    isValid.value = examNameController.text.trim().isNotEmpty && 
                    bookNamesController.text.trim().isNotEmpty;
  }

  @override
  void onClose() {
    examNameController.dispose();
    bookNamesController.dispose();
    super.onClose();
  }

  void generateStudyPlan() {
    if (!isValid.value) return;

    isGenerating.value = true;
    final examName = examNameController.text.trim();
    final books = bookNamesController.text.trim();
    
    Future.delayed(const Duration(seconds: 2), () {
      isGenerating.value = false;
      
      final String generatedMarkdown = '''# Study Plan: $examName

## Overview
This personalized study plan is designed to help you prepare effectively for **$examName** using your suggested resources: *$books*.

## Week 1-2: Core Concepts & Foundation
### Focus Areas
- Review the fundamental theories in your primary textbook.
- Understand the core syllabus requirements for $examName.

### Action Items
1. Read the first 3 chapters of the main resource.
2. Create summary notes for quick revision.
3. Solve introductory practice problems.

## Week 3-4: Advanced Topics & Application
### Focus Areas
- Dive into complex topics and application-based questions.
- Start using curriculum-specific shortcuts.

### Action Items
1. Complete remaining chapters.
2. Review past exam papers.
3. Identify weak areas and re-read those sections.

## Final Week: Revision & Mock Tests
- **Day 1-3:** Full syllabus rapid revision.
- **Day 4-5:** Take 2 full-length timed mock exams.
- **Day 6:** Rest and light review of formulas/key points.''';

      Get.to(() => const AIChatScreen(), arguments: {
        'initialMessage': generatedMarkdown,
        'source': 'exam_prep'
      });
      
      examNameController.clear();
      bookNamesController.clear();
      isValid.value = false;
    });
  }
}
