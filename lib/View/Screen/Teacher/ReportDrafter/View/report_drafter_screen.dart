import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/report_drafter_controller.dart';

class ReportDrafterScreen extends StatelessWidget {
  const ReportDrafterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportDrafterController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDocumentDetailsCard(context, controller),
                  const SizedBox(height: 24),
                  _buildFeaturesCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF0EA5E9),
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
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'report_drafter_title'.tr,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48),
            child: Text(
              'report_drafter_subtitle'.tr,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentDetailsCard(BuildContext context, ReportDrafterController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'document_details'.tr,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9)),
          ),
          const SizedBox(height: 12),
          Text(
            'report_description_intro'.tr,
            style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 32),
          _buildFieldLabel('report_type'.tr),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('select_report_type'.tr, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    value: controller.selectedReportType.value,
                    items: controller.reportTypes.map((type) => DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(fontSize: 14)))).toList(),
                    onChanged: (val) => controller.selectedReportType.value = val,
                  ),
                ),
              )),
          const SizedBox(height: 24),
          _buildFieldLabel('title_label'.tr),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
            child: TextField(
              controller: controller.titleController,
              decoration: InputDecoration(
                hintText: 'title_hint'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildFieldLabel('brief_description'.tr),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
            child: TextField(
              controller: controller.descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'description_hint'.tr,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => controller.generateReport(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF81D4FA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              icon: const Icon(Icons.article_outlined),
              label: Text(
                'generate_report_btn'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF334155))),
    );
  }

  Widget _buildFeaturesCard() {
    final features = [
      'feature_formatting'.tr,
      'feature_summary'.tr,
      'feature_analysis'.tr,
      'feature_recommendations'.tr,
      'feature_markdown'.tr,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5FE).withOpacity(0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFB3E5FC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'features_title'.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9)),
          ),
          const SizedBox(height: 20),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Color(0xFF0EA5E9), size: 16),
                    const SizedBox(width: 12),
                    Expanded(child: Text(feature, style: const TextStyle(color: Color(0xFF475569), fontSize: 13))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
