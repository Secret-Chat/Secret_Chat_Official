import 'package:flutter/material.dart';

class NoteSelf extends StatefulWidget {
  @override
  _NoteSelfState createState() => _NoteSelfState();
}

class _NoteSelfState extends State<NoteSelf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            children: <Widget>[
              Text('Secret Chat'),
              Icon(Icons.panorama_fish_eye_sharp),
            ],
          ),
        ),
      ),
    );
  }
}
