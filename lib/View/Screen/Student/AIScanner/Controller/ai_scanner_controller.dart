import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class AIScannerController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  
  CameraController? cameraController;
  final isCameraInitialized = false.obs;
  List<CameraDescription>? cameras;

  final capturedImage = Rx<File?>(null);
  final isProcessing = false.obs;

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
    
    // TODO: Route to results page
    Get.snackbar('Success', 'AI analysis complete!', snackPosition: SnackPosition.BOTTOM);
  }

  void retake() {
    capturedImage.value = null;
  }
}


