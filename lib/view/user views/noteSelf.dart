import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/widgets/noteChatWidget.dart';

class NoteSelf extends StatefulWidget {
  @override
  _NoteSelfState createState() => _NoteSelfState();
}

class _NoteSelfState extends State<NoteSelf> {
  final _auth = FirebaseAuth.instance;
  final _titleController = TextEditingController();

  final getxController = Get.put(AuthController());
  // CollectionReference stream = FirebaseFirestore.instance
  //     .collection('users/${getxController.authData}/messages');
  //.orderBy('createdOn', descending: false);
  //.orderBy('createdOn', descending: true);

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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 80,
          child: Column(
            children: <Widget>[
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   color: Color.fromRGBO(200, 200, 200, 0.3),
              //   height: MediaQuery.of(context).size.height - 250,
              //child:
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      // .collection('users/${getxController.authData.value}/mescsages')

                      .collection('users')
                      .doc('${getxController.authData.value}')
                      .collection('messages')
                      .orderBy('createdOn', descending: true)
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

                    return new ListView(
                      reverse: true,
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        // return new ListTile(
                        //   title: new Text(document.data()['text']),
                        //   //subtitle: new Text(document.data()['company']),
                        // );
                        return NoteChatWidget(document.data()['text']);
                      }).toList(),
                    );
                  },
                ),
              ),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: Color.fromRGBO(23, 234, 34, 0.2),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 98,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: Colors.black87,
                            style: BorderStyle.solid),
                      ),
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextField(
                        decoration: InputDecoration(labelText: 'Title'),
                        controller: _titleController,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.black,
                        size: 25,
                      ),
                      onPressed: () {
                        // ignore: prefer_is_not_empty
                        if (_titleController.text.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection(
                                  'users/${getxController.authData}/messages')
                              .add({
                            'text': _titleController.text,
                            'createdOn': Timestamp.now(),
                          });
                          // getxController.printer();
                        }
                        _titleController.text = '';
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       // Firestore.instance
      //       //     .collection('chat/G8Rk0dGURGZna9CdyyNf/messages')
      //       //     .snapshots()
      //       //     .listen((data) {
      //       //   data.documents.forEach((document) {
      //       //     print(
      //       //       document['text'],
      //       //     );
      //       FirebaseFirestore.instance
      //           .collection('users/FlcIcaaSnmc4DFWDTBXgUuruxI22/messages')
      //           .add({'text': 'This is another another another message'});
      //     }),
    );
  }
}
