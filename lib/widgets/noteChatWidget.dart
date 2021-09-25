import 'package:flutter/material.dart';

class NoteChatWidget extends StatelessWidget {
  final text;

  NoteChatWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.only(right: 10, left: 10, top: 2, bottom: 2),
        //color: Color.fromRGBO(10, 10, 255, 0.3),
        alignment: Alignment.bottomRight,
        child: Container(
          padding: EdgeInsets.only(right: 11, bottom: 7, left: 12, top: 9),
          decoration: BoxDecoration(
            color: Color.fromRGBO(200, 30, 50, 0.3),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          //width: 20,
          constraints: BoxConstraints(
            minWidth: 10,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }
}
