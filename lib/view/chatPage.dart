import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _auth = FirebaseAuth.instance;
  final _titleController = TextEditingController();

  final getxController = Get.put(AuthController());

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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      // .collection('users/${getxController.authData.value}/mescsages')

                      .collection('personal_connections')
                      .doc('bKGgYVxEw2Abbke5t5QG')
                      .collection('messages')
                      .orderBy('createdOn', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    // return new ListView(
                    //   reverse: false,
                    //   children:
                    //       snapshot.data.docs.map((DocumentSnapshot document) {
                    //     if (getxController.authData.value ==
                    //         document.data()['sentBy']) {
                    //       return new ListTile(
                    //         title: new Text(document.data()['message']),
                    //         leading: Text('ME'),
                    //         //subtitle: new Text(document.data()['company']),
                    //       );
                    //     } else {
                    //       return new ListTile(
                    //         title: new Text(document.data()['message']),
                    //         leading: Text('meno'),
                    //         //subtitle: new Text(document.data()['company']),
                    //       );
                    //     }
                    //   }).toList(),
                    // );

                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              leading: getxController.authData.value ==
                                      snapshot.data.docs[index]['sentBy']
                                  ? Text("Me")
                                  : Text("Not mE"),
                              title: Text(
                                  '${snapshot.data.docs[index]['message']}'),
                            );
                          },
                          itemCount: snapshot.data.docs.length);
                    }

                    return Container();
                  },
                ),
              ),
            ),
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
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Enter Message'),
                      controller: _titleController,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_titleController.text.isNotEmpty) {
                          FirebaseFirestore.instance
                              // .collection(
                              //     'personal_connections')  //${getxController.authData}/messages')
                              .collection('personal_connections')
                              .doc('bKGgYVxEw2Abbke5t5QG')
                              .collection('messages')
                              .add({
                            'message': _titleController.text,
                            'sentBy': getxController.authData.value,
                            'createdOn': Timestamp.now(),
                          });
                          getxController.printer();
                        }
                        _titleController.text = '';
                      },
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
