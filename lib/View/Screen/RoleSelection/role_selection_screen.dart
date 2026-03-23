import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Utils/AppColors/app_colors.dart';
import '../../../Controller/role_selection_controller.dart';

class RoleSelectionScreen extends GetView<RoleSelectionController> {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Force a fresh controller to ensure the country-specific logic re-runs on entry
    Get.delete<RoleSelectionController>(force: true); 
    final controller = Get.put(RoleSelectionController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 40),
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'create_profile'.tr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'tell_us'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'i_am_a'.tr,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Role Selection Cards
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildRoleCard(
                  'student',
                  'student_desc',
                  Icons.school_outlined,
                ),
                const SizedBox(height: 20),
                _buildRoleCard(
                  'job_holder',
                  'job_holder_desc',
                  Icons.business_center_outlined,
                ),
                const SizedBox(height: 30),

                // Dynamic Student Section
                Obx(() {
                  if (controller.isStudent) {
                    return _buildStudentExtraSection();
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Sign Up & Continue Button
          Obx(() => Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.canContinue ? () {
                      // Navigate to next (e.g., Auth or Home)
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA5D6A7), // Green from screenshot
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'signup_continue'.tr,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStudentExtraSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'select_class'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          
          // Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: Text('choose_class_hint'.tr),
                value: controller.selectedClass.value.isEmpty ? null : controller.selectedClass.value,
                items: controller.classOptions.map((String value) {
                  String label = value;
                  if (value.toLowerCase() == 'others') label = 'others'.tr;
                  if (value.toLowerCase() == 'diploma') label = 'diploma'.tr;
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (val) => controller.selectClass(val),
              ),
            ),
          ),

          // Dynamic Group Selection (BD Class 9-12)
          if (controller.showGroupSelection) ...[
            const SizedBox(height: 16),
            Text(
              'select_group'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('group_hint'.tr),
                  value: controller.selectedGroup.value.isEmpty ? null : controller.selectedGroup.value,
                  items: controller.groupOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.tr),
                    );
                  }).toList(),
                  onChanged: (val) => controller.selectGroup(val),
                ),
              ),
            ),
          ],

          // Conditional Department & Semester Selection (for Diploma)
          if (controller.isDiplomaSelected) ...[
            const SizedBox(height: 16),
             Text(
              'select_department'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text('department_hint'.tr),
                  value: controller.selectedDepartment.value.isEmpty ? null : controller.selectedDepartment.value,
                  items: controller.departmentOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value == 'others' ? 'others'.tr : value),
                    );
                  }).toList(),
                  onChanged: (val) => controller.selectDepartment(val),
                ),
              ),
            ),

            // Only show semester if department is selected
            if (controller.selectedDepartment.value.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'select_semester'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text('semester_hint'.tr),
                    value: controller.selectedSemester.value.isEmpty ? null : controller.selectedSemester.value,
                    items: controller.semesterOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) => controller.selectSemester(val),
                  ),
                ),
              ),
            ],
          ],

          // Conditional "Others" input
          if (controller.isOthersSelected) ...[
            const SizedBox(height: 16),
            TextField(
              onChanged: (val) => controller.customClass.value = val,
              decoration: InputDecoration(
                hintText: 'enter_class_hint'.tr,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ],
      )),
    );
  }

  Widget _buildRoleCard(String titleKey, String descKey, IconData icon) {
    return Obx(() {
      bool isSelected = controller.selectedRole.value == titleKey;
      return GestureDetector(
        onTap: () => controller.selectRole(titleKey),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade200,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                  ? AppColors.primaryColor.withOpacity(0.1) 
                  : Colors.black.withOpacity(0.02),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                titleKey.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                descKey.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
