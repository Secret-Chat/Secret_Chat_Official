import 'dart:io';

import 'package:flutter/material.dart';
import 'package:secretchat/view/story%20status/camera_main.dart';
// import 'package:secretchat/view/story%20status/after_camera_button.dart';
// import 'package:secretchat/view/story%20status/after_camera_image.dart';

class PreviewCameraScreen extends StatefulWidget {
  final String imagePath;

  PreviewCameraScreen(this.imagePath);
  //const AfterCameraMain({ Key? key }) : super(key: key);

  @override
  _PreviewCameraScreenState createState() => _PreviewCameraScreenState();
}

class _PreviewCameraScreenState extends State<PreviewCameraScreen> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Center(
                child: Image.file(
                  File(widget.imagePath),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                //color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 15, right: 20, top: 35, bottom: 5),
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Container(
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 17,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CameraMain()));
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width - 50,
                            padding: EdgeInsets.only(left: 7),
                            color: Colors.black,
                            child: TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Caption it',
                                  hintStyle: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              child:
                                  Icon(Icons.send_sharp, color: Colors.purple),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
