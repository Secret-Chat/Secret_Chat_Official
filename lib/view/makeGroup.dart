import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MakeGroup extends StatefulWidget {
  //const MakeGroup({ Key? key }) : super(key: key);

  @override
  _MakeGroupState createState() => _MakeGroupState();
}

class _MakeGroupState extends State<MakeGroup> {
  onTap(String id, String username) {
    print(id);
    print(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Group'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 200,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')

              //.where('email')
              .snapshots(),
          // .collection('users/${getxController.authData.value}/mescsages')

          // .collection('users')
          // .doc('${getxController.authData.value}')
          // .collection('messages')
          // .orderBy('createdOn', descending: false)
          // .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

            return new ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return new ListTile(
                  tileColor:
                      //Color.fromRGBO(255, 0, 0, 0.4) :
                      Colors.white,
                  title: new Text(snapshot.data.docs[index]['username']),
                  subtitle: new Text(snapshot.data.docs[index]['email']),
                  onTap: () async {
                    onTap(snapshot.data.docs[index]['userId'],
                        snapshot.data.docs[index]['username']);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
