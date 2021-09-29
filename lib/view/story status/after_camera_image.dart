import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/storyController.dart';

class AfterCameraImage extends StatefulWidget {
  //const AfterCameraImage({ Key? key }) : super(key: key);

  @override
  _AfterCameraImageState createState() => _AfterCameraImageState();
}

class _AfterCameraImageState extends State<AfterCameraImage> {
  final imagePreview = Get.put(StoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Image.file(
          File(imagePreview.imagePath.value),
        ),
      ),
    );
  }
}
