import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/library_controller.dart';


class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final controller = Get.put(LibraryController());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterTabs(),
          Expanded(
            child: Obx(() {
              final items = controller.filteredItems;
              if (items.isEmpty) {
                return const Center(child: Text("No items found."));
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildAnimatedCard(index, item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(int index, item) {
    final start = (index * 0.1).clamp(0.0, 1.0);
    final end = (start + 0.5).clamp(0.0, 1.0);
    final curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(start, end, curve: Curves.easeOutQuart),
    );

    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(curve),
        child: Container(
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
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: _getIconForType(item.type),
            title: Text(
              item.title,
              style: const TextStyle(
                color: Color(0xFF1E3A8A), // Deep blue title like the image
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item.date,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.download_outlined, color: Color(0xFF475569)),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline, color: Color(0xFF475569)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getIconForType(String type) {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (type) {
      case 'pdf':
        iconData = Icons.description_outlined;
        iconColor = const Color(0xFFE53935); // Red text
        bgColor = const Color(0xFFFFEBEE); // Light red background
        break;
      case 'scan':
        iconData = Icons.image_outlined;
        iconColor = const Color(0xFF1E88E5); // Blue text
        bgColor = const Color(0xFFE3F2FD); // Light blue background
        break;
      case 'plan':
      default:
        iconData = Icons.lightbulb_outline;
        iconColor = const Color(0xFFFFA000); // Yellow/Orange text
        bgColor = const Color(0xFFFFF8E1); // Light yellow background
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Light grey matching pill BG
        borderRadius: BorderRadius.circular(30),
      ),
      child: Obx(() {
        final filters = ['All', 'PDFs', 'Scans', 'Plans'];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: filters.map((f) {
            final isSelected = controller.selectedFilter.value == f;
            final translatedName = f.toLowerCase().tr;
            final count = controller.getCount(f);
            
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.setFilter(f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$translatedName ($count)',
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF283593), // Match image deep blue header
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                onPressed: () => Get.back(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'my_library'.tr,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'my_library_desc'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Search Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: TextField(
              onChanged: controller.search,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                icon: const Icon(Icons.search, color: Colors.white70),
                hintText: 'search_library'.tr,
                hintStyle: const TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
