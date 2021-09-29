import 'package:flutter/material.dart';
import 'package:secretchat/view/story%20status/camera_buttons.dart';
import 'package:secretchat/view/story%20status/camera_preview.dart';

class CameraMain extends StatefulWidget {
  //const CameraMain({ Key? key }) : super(key: key);

  @override
  _CameraMainState createState() => _CameraMainState();
}

class _CameraMainState extends State<CameraMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            CameraPreviewScreen(),
            CameraButtons(),
          ],
        ),
      ),
    );
  }
}
