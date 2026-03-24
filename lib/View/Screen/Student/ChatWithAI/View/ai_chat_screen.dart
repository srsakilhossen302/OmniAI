import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../AIScanner/View/ai_scanner_screen.dart';
import '../../AssignmentWriter/View/assignment_writer_screen.dart';
import '../../ExamPreparation/View/exam_prep_screen.dart';
import '../Controller/ai_chat_controller.dart';
import '../Model/ai_chat_model.dart';

class AIChatScreen extends StatelessWidget {
  const AIChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AIChatController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Very light grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF475569)),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6), // Strong Blue back
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ai_assistant_title'.tr,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'online'.tr,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true, // This automatically pushes content up, anchors to the bottom, and auto-scrolls when keyboard opens!
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
                itemBuilder: (context, index) {
                  // If AI is typing, it sits at the very bottom (index 0)
                  if (controller.isTyping.value) {
                    if (index == 0) return _buildTypingIndicator();
                    final msg = controller.messages[index - 1]; // Shift index manually by 1
                    if (msg.isUser) return _buildUserBubble(msg);
                    return _buildAIBubble(msg);
                  }
                  
                  // Normal item mapping
                  final msg = controller.messages[index];
                  if (msg.isUser) {
                    return _buildUserBubble(msg);
                  } else {
                    return _buildAIBubble(msg);
                  }
                },
              );
            }),
          ),
          _buildBottomInput(controller),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 16),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFF3B82F6)),
          const SizedBox(width: 8),
          Text(
            'ai_typing'.tr,
            style: const TextStyle(color: Color(0xFF64748B), fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBubble(AIChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 40),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: Color(0xFF0EA5E9), // User cyan blue
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(4), // Pointy chat tail
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.image != null)
                Padding(
                  padding: EdgeInsets.only(bottom: message.text.isNotEmpty ? 12 : 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      message.image!,
                      height: 180,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (message.text.isNotEmpty)
                Text(
                  message.text,
                  style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIBubble(AIChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar
          Container(
            margin: const EdgeInsets.only(right: 12, top: 4),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6), // Strong Blue background
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
          ),
          // Chat Content Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
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
                  MarkdownBody(
                    data: message.text,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(color: Color(0xFF334155), fontSize: 15, height: 1.6),
                      strong: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                      h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                      code: const TextStyle(
                        backgroundColor: Color(0xFFF1F5F9), 
                        color: Color(0xFF0F172A), 
                        fontWeight: FontWeight.w600
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildActionButton(
                          Icons.volume_up_outlined, 
                          'Speak', 
                          const Color(0xFF4F46E5),
                          () => Get.find<AIChatController>().speak(message.text),
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          Icons.picture_as_pdf_outlined, 
                          'PDF', 
                          const Color(0xFF2563EB),
                          () => Get.find<AIChatController>().downloadAsPDF(message.text),
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          Icons.share_outlined, 
                          'Share', 
                          const Color(0xFF2563EB),
                          () {}, // Share logic can be added later
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 18),
      label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade200),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildBottomInput(AIChatController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (controller.selectedImage.value == null) return const SizedBox.shrink();
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 12, left: 12),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: FileImage(controller.selectedImage.value!),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: GestureDetector(
                      onTap: controller.removeImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              );
            }),
            Obx(() {
              if (controller.source.value.isEmpty || 
                  controller.source.value == 'problem_solution' || 
                  controller.source.value == 'teacher_home' || 
                  controller.source.value == 'chat_with_ai') {
                return const SizedBox.shrink(); // Hide if accessed from home tiles
              }
              
              Widget icon;
              VoidCallback onTap;
              
              if (controller.source.value == 'scanner') {
                icon = const Icon(Icons.camera_alt_outlined, color: Color(0xFF3B82F6), size: 24);
                onTap = () => Get.to(() => const AIScannerScreen());
              } else if (controller.source.value == 'exam_prep') {
                icon = const Icon(Icons.menu_book, color: Color(0xFF3B82F6), size: 24);
                onTap = () => Get.to(() => const ExamPrepScreen());
              } else if (controller.source.value == 'assignment') {
                icon = const Icon(Icons.edit_document, color: Color(0xFF3B82F6), size: 24);
                onTap = () => Get.to(() => const AssignmentWriterScreen());
              } else {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF6FF), // very light blue background
                          shape: BoxShape.circle,
                        ),
                        child: icon,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                    controller.source.value == 'scanner' ? 'ai_scanner'.tr :
                    controller.source.value == 'exam_prep' ? 'exam_prep'.tr :
                    controller.source.value == 'assignment' ? 'write_assignment'.tr : '',
                      style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }),
            Row(
              children: [
                GestureDetector(
                  onTap: controller.pickCamera,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF6FF), // very light blue background
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF3B82F6), size: 24),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: controller.pickGallery,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF6FF), // very light blue background
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.image_outlined, color: Color(0xFF3B82F6), size: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Light grey matching input
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller.textController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ask_follow_up'.tr,
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: controller.sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6), // Sending blue bubble
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);
}
}

