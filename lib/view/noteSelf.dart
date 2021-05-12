import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteSelf extends StatefulWidget {
  @override
  _NoteSelfState createState() => _NoteSelfState();
}

class _NoteSelfState extends State<NoteSelf> {
  final _auth = FirebaseAuth.instance;
  CollectionReference stream = FirebaseFirestore.instance
      .collection('users/FlcIcaaSnmc4DFWDTBXgUuruxI22/messages');

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
      body: StreamBuilder<QuerySnapshot>(
        stream: stream.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text(document.data()['text']),
                //subtitle: new Text(document.data()['company']),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // Firestore.instance
            //     .collection('chat/G8Rk0dGURGZna9CdyyNf/messages')
            //     .snapshots()
            //     .listen((data) {
            //   data.documents.forEach((document) {
            //     print(
            //       document['text'],
            //     );
            FirebaseFirestore.instance
                .collection('users/FlcIcaaSnmc4DFWDTBXgUuruxI22/messages')
                .add({'text': 'This is another another another message'});
          }),
    );
  }
}
