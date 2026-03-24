import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../../../Utils/AppColors/app_colors.dart';
import '../../../Utils/StaticString/static_string.dart';
import '../../../service/firebase_service.dart';
import '../LanguageSelection/language_selection_screen.dart';
import '../Student/StudentHome/View/student_home_screen.dart';
import '../Teacher/TeacherHome/View/teacher_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.95, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    final firebaseService = Get.find<FirebaseService>();
    final user = firebaseService.auth.currentUser;

    // Simulate splash delay
    await Future.delayed(const Duration(seconds: 3));

    if (user != null) {
      // Check if profile exists
      final profile = await firebaseService.getUserProfile(user.uid);
      
      if (profile != null && profile.exists) {
        final data = profile.data() as Map<String, dynamic>;
        final role = data['role'] ?? '';
        
        if (role == 'student') {
          Get.offAll(() => const StudentHomeScreen());
          return;
        } else if (role == 'job_holder') {
          Get.offAll(() => const TeacherHomeScreen());
          return;
        }
      }
    }

    // Default to Language Selection
    Get.offAll(() => const LanguageSelectionScreen());
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.splashGradientStart,
              AppColors.splashGradientEnd,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: const Icon(
                Icons.school_outlined,
                size: 120,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              StaticStrings.appName,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: Colors.white70,
                ),
                const SizedBox(width: 8),
                Text(
                  StaticStrings.appDescription,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: LinearProgressIndicator(
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
