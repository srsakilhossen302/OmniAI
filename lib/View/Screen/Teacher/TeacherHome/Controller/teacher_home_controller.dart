import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Student/ChatWithAI/View/ai_chat_screen.dart';
import '../../QuestionGenerator/View/question_generator_screen.dart';
import '../../TeacherLibrary/View/teacher_library_screen.dart';

class TeacherProfileModel {
  final String name;
  final String greeting;
  final String email;

  TeacherProfileModel({
    required this.name,
    required this.greeting,
    required this.email,
  });
}

class RecentActivityModel {
  final String title;
  final String time;
  final String type;

  RecentActivityModel({
    required this.title,
    required this.time,
    required this.type,
  });
}

class TeacherHomeController extends GetxController {
  final textController = TextEditingController();
  final selectedImage = Rx<File?>(null);

  final teacherProfile = Rx<TeacherProfileModel?>(null);
  final recentActivities = <RecentActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
    _loadRecentActivities();
  }

  void _loadProfile() {
    // Mock data for now
    teacherProfile.value = TeacherProfileModel(
      name: 'hj hjj',
      greeting: 'Good Morning',
      email: 'teacher@omniai.edu',
    );
  }

  void _loadRecentActivities() {
    recentActivities.assignAll([
      RecentActivityModel(title: 'dsds Preparation', time: '24/03/2026', type: 'exam'),
      RecentActivityModel(title: 'dsffdsfsddfsdfsd', time: '24/03/2026', type: 'report'),
      RecentActivityModel(title: 'gj', time: '24/03/2026', type: 'assignment'),
      RecentActivityModel(title: 'Renewable Energy Sources', time: '24/03/2026', type: 'project'),
    ]);
  }

  void logout() {
    Get.back(); // Simple for now
  }

  void openLibrary() {
    Get.to(() => const TeacherLibraryScreen());
  }

  void openQuestionGenerator() {
    Get.to(() => const QuestionGeneratorScreen());
  }

  void openAIAssistant() {
    Get.to(() => const AIChatScreen(), arguments: {'source': 'teacher_home'});
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
