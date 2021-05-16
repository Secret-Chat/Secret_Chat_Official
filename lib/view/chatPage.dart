import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OtherUser'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 68,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 7,
                child: Container(
                  color: Color.fromRGBO(23, 34, 24, 0.3),
                  child: Center(
                    child: Text('chats'),
                  ),
                )),
            Expanded(
                child: Container(
              color: Color.fromRGBO(34, 35, 23, 0.5),
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 98,
                    width: MediaQuery.of(context).size.width - 140,
                    child: TextField(),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
