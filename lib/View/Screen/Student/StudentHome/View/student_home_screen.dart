import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../Controller/student_home_controller.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Force animation after build
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentHomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header Section (Slides down)
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildHeader(controller),
          ),

          // Content Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                _buildAnimatedItem(
                  delay: 0,
                  child: _buildActionCard(
                    title: 'ai_scanner'.tr,
                    subtitle: 'ai_scanner_desc'.tr,
                    icon: Icons.document_scanner_outlined,
                    iconColor: const Color(0xFF0EA5E9),
                    onTap: controller.openAIScanner,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnimatedItem(
                  delay: 1,
                  child: _buildActionCard(
                    title: 'write_assignment'.tr,
                    subtitle: 'write_assignment_desc'.tr,
                    icon: Icons.assignment_outlined,
                    iconColor: const Color(0xFF22C55E),
                    onTap: controller.openWriteAssignment,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnimatedItem(
                  delay: 2,
                  child: _buildActionCard(
                    title: 'exam_prep'.tr,
                    subtitle: 'exam_prep_desc'.tr,
                    icon: Icons.menu_book_outlined,
                    iconColor: const Color(0xFFFB923C),
                    onTap: controller.openExamPrep,
                  ),
                ),
                const SizedBox(height: 20),
                // NEW: Problem Solution Card
                _buildAnimatedItem(
                  delay: 3,
                  child: _buildActionCard(
                    title: 'problem_solution'.tr,
                    subtitle: 'problem_solution_desc'.tr,
                    icon: Icons.lightbulb_outline,
                    iconColor: const Color(0xFF8B5CF6), // Purple
                    onTap: () {
                      // Handle Problem Solution
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Recent Activity Section
                _buildAnimatedItem(
                  delay: 4,
                  child: _buildRecentActivitySection(controller),
                ),
                const SizedBox(height: 24),
                // Extra Banners
                _buildAnimatedItem(
                  delay: 5,
                  child: _buildLibraryAndChatCards(controller),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedItem({required int delay, required Widget child}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate dynamic staggered animation
        final start = 0.1 * delay;
        final end = start + 0.6;
        final curve = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeOutQuart,
          ),
        );

        return FadeTransition(
          opacity: curve,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildHeader(StudentHomeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          controller.studentProfile.value?.greeting.tr ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.studentProfile.value?.name.tr ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout, color: Colors.white70, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'learn_today_msg'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return _BouncingCard(
      onTap: onTap,
      pressedColor: iconColor.withOpacity(0.12),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection(StudentHomeController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'recent_activity'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: controller.viewAllActivity,
              child: Row(
                children: [
                  Text(
                    'view_all'.tr,
                    style: const TextStyle(color: Color(0xFF0EA5E9)),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: Color(0xFF0EA5E9),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(
          () => ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.recentActivities.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final activity = controller.recentActivities[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: _getIconForType(activity.type),
                  title: Text(
                    activity.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  subtitle: Text(
                    activity.time,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryAndChatCards(StudentHomeController controller) {
    return Column(
      children: [
        _BouncingCard(
          onTap: controller.openMyLibrary,
          pressedColor: const Color(0xFF1E2A7A),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: const Color(0xFF283593), // Deep indigo/blue matching image
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'my_library'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'my_library_desc'.tr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.my_library_books_rounded,
                  color: Colors.white.withOpacity(0.6),
                  size: 48,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _BouncingCard(
          onTap: controller.openChatWithAI,
          pressedColor: const Color(0xFF439443),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50), // Green matching image
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'chat_with_ai'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'chat_with_ai_desc'.tr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Colors.white.withOpacity(0.6),
                  size: 48,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getIconForType(String type) {
    IconData iconData;
    Color color;

    switch (type) {
      case 'scanner':
        iconData = Icons.camera_alt_outlined;
        color = const Color(0xFF0EA5E9);
        break;
      case 'assignment':
        iconData = Icons.assignment_outlined;
        color = const Color(0xFF22C55E);
        break;
      case 'exam':
        iconData = Icons.menu_book_outlined;
        color = const Color(0xFFFB923C);
        break;
      case 'problem':
        iconData = Icons.lightbulb_outline;
        color = const Color(0xFF8B5CF6);
        break;
      default:
        iconData = Icons.star_border;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Light grey matching image bg
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: color, size: 24),
    );
  }
}

class _BouncingCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color pressedColor;

  const _BouncingCard({
    required this.child,
    required this.onTap,
    required this.pressedColor,
  });

  @override
  State<_BouncingCard> createState() => _BouncingCardState();
}

class _BouncingCardState extends State<_BouncingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: widget.pressedColor,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(_BouncingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pressedColor != widget.pressedColor) {
      _colorAnimation = ColorTween(
        begin: Colors.white,
        end: widget.pressedColor,
      ).animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

