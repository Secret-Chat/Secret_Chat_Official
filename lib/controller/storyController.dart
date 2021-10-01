import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:secretchat/view/story%20status/camera_main.dart';
import 'package:secretchat/view/story%20status/camera_preview.dart';

class RecordController extends GetxController {
  //Rx<bool> isFlashOpen = false.obs;
  Rx<CameraController> controller =
      CameraController(cameras[0], ResolutionPreset.max).obs;
  //Rx<bool> isCameraOutFacing = true.obs;
  Rx<Future<void>> cameraValue =
      CameraController(cameras[0], ResolutionPreset.max).initialize().obs;
  //Rx<bool> isVideoRecording = false.obs;
  //Rx<String> videoPath = ''.obs;
  // Rx<VideoPlayerController> videoPlayerController = VideoPlayerController.network(
  //         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
  //     .obs;
  // Rx<double> scale = 1.0.obs;
}
