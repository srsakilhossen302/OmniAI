import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/teacher_library_controller.dart';

class TeacherLibraryScreen extends StatelessWidget {
  const TeacherLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeacherLibraryController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(context, controller),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                   _buildFilterBar(controller),
                   const SizedBox(height: 24),
                   Obx(() => ListView.separated(
                     shrinkWrap: true,
                     physics: const NeverScrollableScrollPhysics(),
                     itemCount: controller.filteredItems.length,
                     separatorBuilder: (context, index) => const SizedBox(height: 16),
                     itemBuilder: (context, index) {
                        final item = controller.filteredItems[index];
                        return _buildLibraryCard(item, controller);
                     },
                   )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TeacherLibraryController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF283593), // Deep blue matching your image
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24)),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Library', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Your saved content and notes', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: TextField(
              onChanged: (val) => controller.searchQuery.value = val,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.white54, size: 22),
                hintText: 'Search your library...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(TeacherLibraryController controller) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: controller.filters.map((filter) {
          return Obx(() {
            bool isSelected = controller.selectedFilter.value == filter;
            return GestureDetector(
              onTap: () => controller.updateFilter(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))] : [],
                ),
                child: Text(
                  '$filter (${controller.getCount(filter)})',
                  style: TextStyle(color: isSelected ? Colors.black87 : Colors.grey.shade600, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 13),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildLibraryCard(item, TeacherLibraryController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getIconColor(item.iconType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_getIconForType(item.type), color: _getIconColor(item.iconType), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(item.date, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          IconButton(onPressed: () => controller.downloadItem(item), icon: const Icon(Icons.download_rounded, color: Colors.grey, size: 22)),
          IconButton(onPressed: () => controller.deleteItem(item), icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey, size: 22)),
        ],
      ),
    );
  }

  Color _getIconColor(String type) {
    if (type == 'red') return Colors.redAccent;
    if (type == 'blue') return Colors.lightBlue;
    return Colors.amber;
  }

  IconData _getIconForType(String type) {
    if (type == 'PDFs') return Icons.picture_as_pdf_outlined;
    if (type == 'Scans') return Icons.image_outlined;
    return Icons.lightbulb_outline_rounded;
  }
}
