import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/assignment_writer_controller.dart';

class AssignmentWriterScreen extends StatelessWidget {
  const AssignmentWriterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AssignmentWriterController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light grey matching BG
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
                  _buildTipsCard(),
                  const SizedBox(height: 24),
                  _buildExampleTopicsCard(controller),
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
        color: Color(0xFF4CAF50), // Green header
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
                'assignment_writer_title'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'assignment_writer_subtitle'.tr,
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

  Widget _buildInputCard(AssignmentWriterController controller) {
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
            'share_assignment_idea'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A), // Deep Blue Title
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'describe_assignment_topic'.tr,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9), // Light grey input BG
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller.topicController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'assignment_hint'.tr,
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  height: 1.5,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              final isGen = controller.isGenerating.value;
              final hasText = controller.hasText.value;
              
              Color bgColor;
              if (isGen) {
                bgColor = const Color(0xFFA5D6A7); // light green during generation
              } else if (hasText) {
                bgColor = const Color(0xFF4CAF50); // deep green active
              } else {
                bgColor = const Color(0xFFA5D6A7); // light green when empty
              }

              return ElevatedButton.icon(
                onPressed: (hasText && !isGen) ? controller.generateAssignment : null,
                icon: isGen 
                  ? const _SpinningIcon(icon: Icons.auto_awesome)
                  : const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                label: Text(
                  isGen ? 'generating_assignment'.tr : 'generate_assignment_btn'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  disabledForegroundColor: Colors.white,
                  disabledBackgroundColor: bgColor, // match visual theme exactly
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

  Widget _buildTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light green BG
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8E6C9)), // Light green border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'tips_better_results'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A), // Deep Blue Title
            ),
          ),
          const SizedBox(height: 16),
          _buildTipLine('tip_specific_topic'.tr),
          _buildTipLine('tip_subject_area'.tr),
          _buildTipLine('tip_specific_points'.tr),
          _buildTipLine('tip_academic_level'.tr),
        ],
      ),
    );
  }

  Widget _buildTipLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: CircleAvatar(
              radius: 2,
              backgroundColor: Color(0xFF64748B),
            ),
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

  Widget _buildExampleTopicsCard(AssignmentWriterController controller) {
    return Container(
      width: double.infinity,
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
            'example_topics'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A), // Deep Blue Title
            ),
          ),
          const SizedBox(height: 24),
          _buildTopicItem(controller, 'topic_1'.tr),
          const SizedBox(height: 24),
          _buildTopicItem(controller, 'topic_2'.tr),
          const SizedBox(height: 24),
          _buildTopicItem(controller, 'topic_3'.tr),
          const SizedBox(height: 24),
          _buildTopicItem(controller, 'topic_4'.tr),
        ],
      ),
    );
  }

  Widget _buildTopicItem(AssignmentWriterController controller, String topic) {
    return InkWell(
      onTap: () {
        controller.setExampleTopic(topic);
      },
      child: Text(
        topic,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF0F172A),
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
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
      duration: const Duration(seconds: 2), // Infinite smooth rotation
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
