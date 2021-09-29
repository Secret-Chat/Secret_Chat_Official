import 'package:flutter/material.dart';

class CameraButtons extends StatefulWidget {
  //const CameraButtons({ Key? key }) : super(key: key);

  @override
  _CameraButtonsState createState() => _CameraButtonsState();
}

class _CameraButtonsState extends State<CameraButtons> {
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
