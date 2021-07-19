import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/model/user_in_group.dart';
import 'package:secretchat/view/team%20chat/addMemberPage.dart';
import 'package:secretchat/view/user%20views/profileDetail.dart';

class GroupDetailsPage extends StatefulWidget {
  // final String groupID;
  final TeamModel teamModel;

  const GroupDetailsPage({Key key, @required this.teamModel}) : super(key: key);

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  final getxController = Get.put(AuthController());

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
                .doc('${widget.teamModel.teamId}')
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
                      Text("${snapshot.data['teamName']}"),
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
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('personal_connections')
                      .doc('${widget.teamModel.teamId}')
                      .collection('users')
                      .doc(getxController.user.value.userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data['role'] == 'owner')
                        return Container(
                          height: 50,
                          child: GestureDetector(
                            child: Center(
                              child: Text('Add Member'),
                            ),
                            onTap: () {
                              Get.to(AddMemberPage(
                                teamModel: widget.teamModel,
                              ));
                            },
                          ),
                        );
                    }
                    return Container();
                  }),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 170,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('personal_connections')
                            .doc('${widget.teamModel.teamId}')
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
                      height: 400,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('personal_connections')
                            .doc('${widget.teamModel.teamId}')
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
                                  onTap: () {
                                    if (getxController.user.value.userId !=
                                        snapshots.data.docs[index].id) {
                                      return Get.to(
                                        ProfileDetail(
                                          userId: snapshots.data.docs[index].id,
                                        ),
                                      );
                                    }
                                    return null;
                                  },
                                );
                              },
                            );
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
