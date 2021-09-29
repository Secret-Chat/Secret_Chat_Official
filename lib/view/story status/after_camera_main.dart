import 'package:flutter/material.dart';
import 'package:secretchat/view/story%20status/after_camera_button.dart';
import 'package:secretchat/view/story%20status/after_camera_image.dart';

class AfterCameraMain extends StatefulWidget {
  //const AfterCameraMain({ Key? key }) : super(key: key);

  @override
  _AfterCameraMainState createState() => _AfterCameraMainState();
}

class _AfterCameraMainState extends State<AfterCameraMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            AfterCameraImage(),
            AfterCameraButton(),
          ],
        ),
      ),
    );
  }
}
