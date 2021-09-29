import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secretchat/controller/storyController.dart';
import 'package:secretchat/view/story%20status/after_camera_main.dart';

class CameraButtons extends StatefulWidget {
  //const CameraButtons({ Key? key }) : super(key: key);

  @override
  _CameraButtonsState createState() => _CameraButtonsState();
}

class _CameraButtonsState extends State<CameraButtons> {
  final takeController = Get.put(StoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topCenter,
            child: GestureDetector(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                  color: Colors.white,
                ),
              ),
              onTap: () async {
                // cameraOpenFront
                //     ? controller = CameraController(
                //         cameras[2], ResolutionPreset.ultraHigh)
                //     : controller = CameraController(
                //         cameras[0], ResolutionPreset.ultraHigh);
                // cameraContent = controller.initialize();
                // cameraOpenFront = !cameraOpenFront;
                XFile imagePath =
                    await takeController.controller.value.takePicture();
                takeController.imagePath.value = imagePath.path;
                Get.to(AfterCameraMain());

                // onNewCameraSelected(controller.description);
                print('hey');
              },
            ),
          ),
        ],
      ),
    );
  }
}
