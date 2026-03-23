import 'package:get/get.dart';

class StudentHomeController extends GetxController {
  // Mock data for student info
  final studentName = 'Class 6 Student'.obs;
  final greeting = 'good_morning'.obs;
  
  // Mock Recent Activity
  final recentActivities = [
    {'title': 'Math Problem #42', 'time': '2 hours ago', 'type': 'scanner'},
    {'title': 'Science Assignment', 'time': '5 hours ago', 'type': 'assignment'},
    {'title': 'History Quiz Prep', 'time': 'Yesterday', 'type': 'exam'},
  ].obs;

  void logout() {
    // Implement logout logic
    Get.back();
  }

  void viewAllActivity() {
    // Navigate to all activity screen
  }

  void openAIScanner() {
    // Navigate to AI Scanner
  }

  void openWriteAssignment() {
    // Navigate to Write Assignment
  }

  void openExamPrep() {
    // Navigate to Exam Prep
  }
}
