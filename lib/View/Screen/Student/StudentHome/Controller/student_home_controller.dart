import 'package:get/get.dart';
import '../Model/student_home_model.dart';

class StudentHomeController extends GetxController {
  // Observables for Models
  final studentProfile = Rx<StudentProfileModel?>(null);
  final recentActivities = <RecentActivityModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  void _fetchData() {
    // Simulating fetching data from an API or database
    studentProfile.value = StudentProfileModel(
      name: 'Class 6 Student',
      greeting: 'good_morning',
    );

    recentActivities.assignAll([
      RecentActivityModel(
        title: 'Science Exam Preparation',
        time: '23/03/2026',
        type: 'exam',
      ),
      RecentActivityModel(
        title: 'History Assignment Draft',
        time: '23/03/2026',
        type: 'assignment',
      ),
      RecentActivityModel(
        title: 'Math Problem Scan',
        time: '23/03/2026',
        type: 'scanner',
      ),
      RecentActivityModel(
        title: 'Algebra Step-by-Step Solution',
        time: '22/03/2026',
        type: 'problem',
      ),
    ]);
  }

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
