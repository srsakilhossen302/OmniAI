import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import '../Controller/question_generator_controller.dart';

class QuestionGeneratorScreen extends StatelessWidget {
  const QuestionGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionGeneratorController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Question Generator', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => Column(
        children: [
          _buildProgressIndicator(controller.currentStep.value),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildCurrentStepView(controller),
            ),
          ),
          _buildBottomNav(controller),
        ],
      )),
    );
  }

  Widget _buildProgressIndicator(int step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: List.generate(4, (index) {
          bool isActive = index <= step;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primaryColor : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (index < 3)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isActive ? AppColors.primaryColor : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepView(QuestionGeneratorController controller) {
    int step = controller.currentStep.value;

    if (step == 0) {
      return _buildOptionsStep(
        'Step 1: Select Category',
        controller.categories,
        controller.selectedCategory,
        crossAxisCount: 2,
      );
    } else if (step == 1) {
      if (controller.showGroupSelection) {
        return _buildOptionsStep('Step 2: Select Group', controller.groups, controller.selectedGroup);
      } else if (controller.isDiplomaSelected) {
        return _buildOptionsStep('Step 2: Select Department', controller.departments, controller.selectedDepartment);
      } else {
        return _buildSubjectStep(controller); 
      }
    } else if (step == 2) {
       if (controller.isDiplomaSelected) {
         return _buildOptionsStep('Step 3: Select Semester', controller.semesters, controller.selectedSemester);
       } else if (controller.selectedCategory.value.contains('Class')) {
         return _buildOptionsStep('Step 3: Select Exam Type', controller.examTypes, controller.selectedExamType);
       } else {
          return _buildSubjectStep(controller);
       }
    } else {
      return _buildSubjectStep(controller);
    }
  }

  Widget _buildOptionsStep(String title, List<String> options, RxString selection, {int crossAxisCount = 2}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 2.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            String opt = options[index];
            bool isSelected = selection.value == opt;
            return GestureDetector(
              onTap: () => selection.value = opt,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? AppColors.primaryColor : Colors.grey.shade200, width: 2),
                ),
                child: Center(
                  child: Text(
                    opt.tr,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(color: isSelected ? AppColors.primaryColor : Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubjectStep(QuestionGeneratorController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Final Step: Subject & Topics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
        const SizedBox(height: 24),
        Text('Subject Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.subjectController,
          decoration: InputDecoration(hintText: 'e.g., Chemistry, Data Structures', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
        ),
        const SizedBox(height: 20),
        Text('Specific Topics to include', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.topicController,
          maxLines: 4,
          decoration: InputDecoration(hintText: 'e.g., Chapter 1-5, Thermodynamics, Networking...', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
        ),
      ],
    );
  }

  Widget _buildBottomNav(QuestionGeneratorController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Row(
        children: [
          if (controller.currentStep.value > 0)
            Expanded(
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => controller.prevStep(),
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: controller.canProceed ? () => controller.nextStep() : null,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: Text(controller.currentStep.value == 3 ? 'Generate Question' : 'Next Step', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
