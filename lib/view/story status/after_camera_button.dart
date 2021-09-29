import 'package:flutter/material.dart';

class AfterCameraButton extends StatefulWidget {
  //const AfterCameraButton({ Key? key }) : super(key: key);

  @override
  _AfterCameraButtonState createState() => _AfterCameraButtonState();
}

class _AfterCameraButtonState extends State<AfterCameraButton> {
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Caption it',
              ),
            ),
          )
        ],
      ),
    );
  }
}
