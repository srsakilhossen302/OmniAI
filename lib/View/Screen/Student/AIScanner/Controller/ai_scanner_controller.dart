import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import '../../ChatWithAI/View/ai_chat_screen.dart';
import 'dart:io';

class AIScannerController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  
  CameraController? cameraController;
  final isCameraInitialized = false.obs;
  List<CameraDescription>? cameras;

  final capturedImage = Rx<File?>(null);
  final isProcessing = false.obs;
  
  final promptController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initLiveCamera();
  }

  Future<void> _initLiveCamera() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      try {
        cameras = await availableCameras();
        if (cameras != null && cameras!.isNotEmpty) {
          cameraController = CameraController(
            cameras![0],
            ResolutionPreset.max,
            enableAudio: false,
          );
          await cameraController!.initialize();
          isCameraInitialized.value = true;
        }
      } catch (e) {
        print("Camera init error: $e");
      }
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    promptController.dispose();
    super.onClose();
  }

  Future<void> uploadFromGallery() async {
    PermissionStatus status = await Permission.photos.request();
    if (status.isDenied) {
      status = await Permission.storage.request();
    }

    if (status.isGranted || status.isLimited) {
      try {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          capturedImage.value = File(image.path);
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to pick image: $e', snackPosition: SnackPosition.BOTTOM);
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> captureImage() async {
    try {
      if (isCameraInitialized.value && cameraController != null) {
        final XFile photo = await cameraController!.takePicture();
        capturedImage.value = File(photo.path);
      } else {
        // Fallback to native system camera if live feed failed
        final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          capturedImage.value = File(photo.path);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture photo.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> processImage() async {
    isProcessing.value = true;
    // Simulate AI processing for 2.5 seconds
    await Future.delayed(const Duration(milliseconds: 2500));
    isProcessing.value = false;
    
    final String mathSolution = '''**Solution: Quadratic Equation**

To solve **x² + 5x + 6 = 0**, we can use the factoring method.

### Step 1: Identify the equation
The equation is in standard form: **ax² + bx + c = 0**
Where:
- a = **1**
- b = **5**
- c = **6**

### Step 2: Factor the equation
We need to find two numbers that:
- Multiply to give **c (6)**
- Add up to give **b (5)**

The numbers are **2** and **3** because:
`2 + 3 = 5`
`2 × 3 = 6`''';

    // Route to results page showing the nice chat answer via arguments
    Get.to(() => const AIChatScreen(), arguments: {'initialMessage': mathSolution}, transition: Transition.rightToLeft);
  }

  void retake() {
    capturedImage.value = null;
  }
}


