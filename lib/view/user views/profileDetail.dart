import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileDetail extends StatefulWidget {
  final String userId;

  ProfileDetail({this.userId});
  //const ProfileDetail({ Key? key }) : super(key: key);

  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc('${widget.userId}')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: ClipOval(
                        child: Container(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("${snapshot.data['username']}"),
                  ],
                ),
              );
            }
            //TODO: loading spinners to implement later on
            return SizedBox(
              height: 0,
              width: 0,
            );
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 100,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc('${widget.userId}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      tileColor: Color.fromRGBO(160, 160, 160, 0.3),
                      subtitle: Text('EmailId'),
                      title: Text("${snapshot.data['email']}"),
                    );
                  }
                  //TODO: loading spinners to implement later on
                  return SizedBox(
                    height: 0,
                    width: 0,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
