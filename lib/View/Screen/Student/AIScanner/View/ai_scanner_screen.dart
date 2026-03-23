import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import '../Controller/ai_scanner_controller.dart';

class AIScannerScreen extends StatelessWidget {
  const AIScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AIScannerController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Obx(() {
                if (controller.capturedImage.value != null) {
                  return _buildPreviewState(controller);
                }
                return _buildCameraState(controller);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraState(AIScannerController controller) {
    return Column(
      children: [
        _buildCameraViewfinder(controller),
        const SizedBox(height: 24),
        _buildUploadButton(controller),
        const SizedBox(height: 20),
        Text(
          'or_tap_capture'.tr,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        _buildCaptureButton(controller),
        const SizedBox(height: 32),
        _buildTipsSection(),
      ],
    );
  }

  Widget _buildPreviewState(AIScannerController controller) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'preview'.tr,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: controller.retake,
              child: Text(
                'retake'.tr,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            image: DecorationImage(
              image: FileImage(controller.capturedImage.value!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller.promptController,
            decoration: InputDecoration(
              hintText: 'add_instruction'.tr,
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Obx(() {
            final isProc = controller.isProcessing.value;
            return ElevatedButton.icon(
              onPressed: isProc ? null : controller.processImage,
              icon: isProc 
                  ? const _SpinningIcon(icon: Icons.auto_awesome)
                  : const Icon(Icons.auto_awesome, color: Colors.white),
              label: Text(
                isProc ? 'processing_ai'.tr : 'scan_solve'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                disabledForegroundColor: Colors.white, // Keeps text/icon white when null onPressed
                disabledBackgroundColor: const Color(0xFF81C784), // Lighter green matching second image
                backgroundColor: const Color(0xFF4CAF50), // Normal Green Theme
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            );
          }),
        ),
        const SizedBox(height: 32),
        _buildTipsSection(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0EA5E9), // Cyan Blue Header
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
              const Text(
                'AI Scanner', // Not translated explicitly to keep acronym universally recognized
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'scan_subtitle'.tr,
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

  Widget _buildCameraViewfinder(AIScannerController controller) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark Slate Background
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Live Camera Feed or Fallback Design
            Obx(() {
              if (controller.isCameraInitialized.value && controller.cameraController != null) {
                return SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.cameraController!.value.previewSize?.height ?? 1,
                      height: controller.cameraController!.value.previewSize?.width ?? 1,
                      child: CameraPreview(controller.cameraController!),
                    ),
                  ),
                );
              }
              // Center Content (Fallback UI)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'camera_view'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'position_problem'.tr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }),
            
            // Corner Brackets inside the viewfinder (drawn on top of camera feed)
            Positioned(
              top: 24, left: 24, right: 24, bottom: 24,
              child: CustomPaint(
                painter: _CornerBracketsPainter(
                  color: Colors.white,
                  strokeWidth: 4.0,
                  cornerLength: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(AIScannerController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.uploadFromGallery,
        icon: const Icon(Icons.upload_file, color: Colors.white),
        label: Text(
           'upload_gallery_doc'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0EA5E9), // Cyan Button
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildCaptureButton(AIScannerController controller) {
    return GestureDetector(
      onTap: controller.captureImage,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF0EA5E9), width: 3), // Cyan outer ring
        ),
        child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: Color(0xFF0EA5E9), // Inner solid cyan button
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE), // Very light cyan/blue
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBAE6FD)), // Slightly darker border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'tips_best_results'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0369A1), // Dark cyan blue text
            ),
          ),
          const SizedBox(height: 16),
          _buildTipLine('tip_1'.tr),
          _buildTipLine('tip_2'.tr),
          _buildTipLine('tip_3'.tr),
          _buildTipLine('tip_4'.tr),
        ],
      ),
    );
  }

  Widget _buildTipLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: CircleAvatar(
              radius: 3,
              backgroundColor: Color(0xFF0284C7),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0C4A6E),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerBracketsPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;

  _CornerBracketsPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Top-Left
    var path = Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, 0)
      ..lineTo(cornerLength, 0);
    canvas.drawPath(path, paint);

    // Top-Right
    path = Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, cornerLength);
    canvas.drawPath(path, paint);

    // Bottom-Left
    path = Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height)
      ..lineTo(cornerLength, size.height);
    canvas.drawPath(path, paint);

    // Bottom-Right
    path = Path()
      ..moveTo(size.width - cornerLength, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - cornerLength);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
