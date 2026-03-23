import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/exam_prep_controller.dart';

class ExamPrepScreen extends StatelessWidget {
  const ExamPrepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExamPrepController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  _buildInputCard(controller),
                  const SizedBox(height: 24),
                  _buildBenefitsCard(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF59E0B), // Vibrant Orange
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'exam_prep_title'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'exam_prep_subtitle'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(ExamPrepController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'create_study_plan'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A), // Deep Blue Title
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'enter_exam_details'.tr,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'exam_name'.tr,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // Light grey input BG
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller.examNameController,
              decoration: InputDecoration(
                hintText: 'exam_name_hint'.tr,
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'book_names'.tr,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // Light grey input BG
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller.bookNamesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'book_names_hint'.tr,
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), height: 1.5),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              final isGen = controller.isGenerating.value;
              final isValid = controller.isValid.value;
              
              Color bgColor;
              if (isGen) {
                bgColor = const Color(0xFFFCD34D); // Soft orange/yellow
              } else if (isValid) {
                bgColor = const Color(0xFFF59E0B); // Active Deep orange
              } else {
                bgColor = const Color(0xFFFCD34D); // Disabled soft orange
              }

              return ElevatedButton.icon(
                onPressed: (isValid && !isGen) ? controller.generateStudyPlan : null,
                icon: isGen 
                  ? const _SpinningIcon(icon: Icons.menu_book)
                  : const Icon(Icons.menu_book, color: Colors.white, size: 20),
                label: Text(
                  isGen ? 'generating_study_plan'.tr : 'generate_study_plan_btn'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  disabledForegroundColor: Colors.white,
                  disabledBackgroundColor: bgColor, 
                  backgroundColor: bgColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Very Light Orange/Yellow BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)), // Soft orange border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'what_you_will_get'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A), // Deep Blue Title
            ),
          ),
          const SizedBox(height: 16),
          _buildCheckLine('benefit_1'.tr),
          _buildCheckLine('benefit_2'.tr),
          _buildCheckLine('benefit_3'.tr),
          _buildCheckLine('benefit_4'.tr),
        ],
      ),
    );
  }

  Widget _buildCheckLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2, right: 8),
            child: Icon(Icons.check, size: 16, color: Color(0xFF64748B)),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpinningIcon extends StatefulWidget {
  final IconData icon;
  const _SpinningIcon({required this.icon});

  @override
  State<_SpinningIcon> createState() => _SpinningIconState();
}

class _SpinningIconState extends State<_SpinningIcon> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animationController,
      child: Icon(widget.icon, color: Colors.white),
    );
  }
}
