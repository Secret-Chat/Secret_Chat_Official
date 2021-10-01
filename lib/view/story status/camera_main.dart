import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:secretchat/view/story%20status/camera_buttons.dart';
import 'package:secretchat/view/story%20status/camera_preview.dart';
import 'package:secretchat/view/story%20status/preview_camera_screen.dart';

List<CameraDescription> cameras;

class CameraMain extends StatefulWidget {
  //const CameraMain({ Key? key }) : super(key: key);

  @override
  _CameraMainState createState() => _CameraMainState();
}

class _CameraMainState extends State<CameraMain> {
  CameraController controller;

  Future<void> cameraContent;

  bool cameraOpenFront = true;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
    cameraContent = controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            !controller.value.isInitialized
                ? Container()
                : Container(
                    //height: 100.h,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black,
                    child: Center(
                      child: Container(
                        //height: 90.h,
                        child: FutureBuilder(
                            future: cameraContent,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  color: Colors.black,
                                  height: MediaQuery.of(context).size.height,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Container(
                                  color: Colors.black,
                                  height:
                                      MediaQuery.of(context).size.height * 0.9,
                                  child: Center(
                                    child: CameraPreview(controller),
                                  ),
                                );
                              }

                              return Container(
                                color: Colors.black,
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                  child: Text('Camera'),
                                ),
                              );
                            }
                            //child: CameraPreview(controller)),
                            ),
                      ),
                    ),
                  ),
            Container(
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
                        XFile imagePath = await controller.takePicture();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PreviewCameraScreen(imagePath.path)));
                        // onNewCameraSelected(controller.description);
                        print('hey');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
