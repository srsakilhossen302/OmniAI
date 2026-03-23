import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/teacher_home_controller.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen>
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
    final controller = Get.put(TeacherHomeController());

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
                Row(
                  children: [
                    const Icon(Icons.business_center_outlined, size: 20, color: Color(0xFF0D9488)),
                    const SizedBox(width: 8),
                    Text(
                      'the_work_hub'.tr,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                    ),
                  ],
                ),
                _buildAnimatedItem(
                  delay: 0,
                  child: _buildActionCard(
                    title: 'ai_prof_assistant'.tr,
                    subtitle: 'ai_prof_assistant_desc'.tr,
                    icon: Icons.auto_awesome_rounded,
                    iconColor: const Color(0xFF10B981),
                    onTap: () => controller.openAIAssistant(),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnimatedItem(
                  delay: 1,
                  child: _buildActionCard(
                    title: 'quiz_gen'.tr,
                    subtitle: 'quiz_gen_desc'.tr,
                    icon: Icons.quiz_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                    onTap: () => controller.openQuestionGenerator(),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnimatedItem(
                  delay: 3,
                  child: _buildActionCard(
                    title: 'report_drafter'.tr,
                    subtitle: 'report_drafter_desc'.tr,
                    icon: Icons.article_outlined,
                    iconColor: const Color(0xFF0EA5E9),
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 20),
                _buildAnimatedItem(
                  delay: 4,
                  child: _buildActionCard(
                    title: 'my_workspace_teacher'.tr,
                    subtitle: 'my_workspace_teacher_desc'.tr,
                    icon: Icons.view_headline_rounded,
                    iconColor: const Color(0xFF1E3A8A),
                    onTap: () => controller.openLibrary(),
                  ),
                ),
                const SizedBox(height: 32),

                // Recent Work Section
                _buildAnimatedItem(
                  delay: 6,
                  child: _buildRecentWorkSection(controller),
                ),
                const SizedBox(height: 40),
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
        final start = 0.05 * delay;
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
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildHeader(TeacherHomeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      decoration: const BoxDecoration(
        color: Color(0xFF059669),
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
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon( Icons.business_center_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (controller.teacherProfile.value?.greeting ?? 'good_morning').tr,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Text(
                        controller.teacherProfile.value?.name ?? 'Teacher Name',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ],
              ),
              IconButton(
                onPressed: () => controller.logout(),
                icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'optimize_workflow'.tr,
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

  Widget _buildRecentWorkSection(TeacherHomeController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time_filled_rounded, size: 20, color: Color(0xFF0D9488)),
                const SizedBox(width: 8),
                Text(
                  'recent_activity'.tr,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                ),
              ],
            ),
            TextButton(
              onPressed: () => controller.openLibrary(),
              child: Row(
                children: [
                  Text('view_all'.tr, style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF0EA5E9)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.recentActivities.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final activity = controller.recentActivities[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                    child: Icon(_getIconForType(activity.type), size: 22, color: const Color(0xFF10B981)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                        const SizedBox(height: 2),
                        Text(activity.time, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        )),
      ],
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'exam': return Icons.quiz_outlined;
      case 'report': return Icons.article_outlined;
      case 'assignment': return Icons.assignment_outlined;
      case 'project': return Icons.folder_copy_outlined;
      default: return Icons.description_outlined;
    }
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
