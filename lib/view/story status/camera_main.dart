import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:secretchat/view/story%20status/camera_buttons.dart';
import 'package:secretchat/view/story%20status/camera_preview.dart';

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
            CameraButtons(),
          ],
        ),
      ),
    );
  }
}
