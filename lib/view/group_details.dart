import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupDetailsPage extends StatefulWidget {
  final String groupID;

  const GroupDetailsPage({Key key, this.groupID}) : super(key: key);

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('personal_connections')
                .doc('${widget.groupID}')
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
                      Text("${snapshot.data['groupName']}"),
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
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 100,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('personal_connections')
                            .doc('${widget.groupID}')
                            .collection('users')
                            .snapshots(),
                        builder: (context, snapshots) {
                          if (snapshots.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Container(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshots.hasData) {
                            return Container(
                              child:
                                  Text('${snapshots.data.docs.length} members'),
                            );
                          }

                          return Container();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 600,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('personal_connections')
                            .doc('${widget.groupID}')
                            .collection('users')
                            .snapshots(),
                        builder: (context, snapshots) {
                          if (snapshots.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Container(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshots.hasData) {
                            return ListView.builder(
                                itemCount: snapshots.data.docs.length,
                                itemBuilder: (context, index) {
                                  print(
                                      '${snapshots.data.docs[index]['username']}');
                                  return ListTile(
                                    leading: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: ClipOval(
                                        child: Container(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                        '${snapshots.data.docs[index]['username']}'),
                                    trailing: Text(
                                        '${snapshots.data.docs[index]['role']}'),
                                  );
                                });
                          }

                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
