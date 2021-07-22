import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/model/user_in_group.dart';
import 'package:secretchat/view/mainPage.dart';
import 'package:secretchat/view/team%20chat/addMemberPage.dart';
import 'package:secretchat/view/team%20chat/teamEditingPage.dart';
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
  var groupname = '';
  var descriptionName = '';
  List<UserEntity> admins = [];

  onLongPresses(String id, String role) {
    print(id);
    print(role);
    if (role == 'owner') {
      return theDialog(id, role);
    }
    return theDialog(id, role);
  }

  theDialog(String id, String role) {
    return Get.defaultDialog(
        title: '',
        content: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: 50,
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Color.fromRGBO(233, 34, 12, 0.4),
                  child: role == 'owner'
                      ? Center(
                          child: Text('Take thee ownership'),
                        )
                      : Center(
                          child: Text('Make owner'),
                        ),
                ),
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('personal_connections')
                      .doc('${widget.teamModel.teamId}')
                      .collection('users')
                      .doc(id)
                      .update({'role': role == 'owner' ? 'member' : 'owner'});
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: Color.fromRGBO(98, 233, 34, 0.4),
                  child: role == 'owner'
                      ? Center(
                          child: Text('Remove from group'),
                        )
                      : Center(
                          child: Text('Kick this ass'),
                        ),
                ),
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('personal_connections')
                      .doc('${widget.teamModel.teamId}')
                      .collection('users')
                      .doc(id)
                      .update({'status': 'dead'});
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ));
  }

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
                groupname = snapshot.data['teamName'];
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
          actions: [
            Container(
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Get.to(TeamEditingPage(
                    teamName: groupname,
                    teamDescription: descriptionName,
                    teamModel: widget.teamModel,
                  ));
                },
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text('Description'),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('personal_connections')
                            .doc('${widget.teamModel.teamId}')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            descriptionName = snapshot.data['description'];
                            return SizedBox(
                              child: Text("${snapshot.data['description']}"),
                            );
                          }
                          return SizedBox(
                            height: 0,
                            width: 0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
                height: MediaQuery.of(context).size.height - 250,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('personal_connections')
                            .doc('${widget.teamModel.teamId}')
                            .collection('users')
                            .where('status', isEqualTo: 'alive')
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
                      height: 300,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('personal_connections')
                            .doc('${widget.teamModel.teamId}')
                            .collection('users')
                            .where('status', isEqualTo: 'alive')
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
                                if (snapshots.data.docs[index]['role'] ==
                                    'owner') {
                                  admins.add(UserEntity(
                                      name: snapshots.data.docs[index]
                                          ['username'],
                                      userId: snapshots.data.docs[index].id));
                                }
                                // print(
                                //     '${snapshots.data.docs[index]['username']}');
                                return GestureDetector(
                                  child: ListTile(
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
                                            userId:
                                                snapshots.data.docs[index].id,
                                          ),
                                        );
                                      }
                                      return null;
                                    },
                                  ),
                                  onLongPress: () async {
                                    //
                                    // final result = admins.where((element) =>
                                    //     element.userId ==
                                    //     getxController.user.value.userId);
                                    // print(result);
                                    // if (result.isNotEmpty) {
                                    //   onLongPresses(
                                    //       snapshots.data.docs[index].id,
                                    //       snapshots.data.docs[index]['role']);
                                    //   //check admin ist

                                    // }

                                    //check if user tapping himself

                                    if (getxController.user.value.userId ==
                                        snapshots.data.docs[index].id) {
                                      return;
                                    }

                                    DocumentSnapshot memberWhoPressedRoleCheck =
                                        await FirebaseFirestore.instance
                                            .collection('personal_connections')
                                            .doc('${widget.teamModel.teamId}')
                                            .collection('users')
                                            .doc(getxController
                                                .user.value.userId)
                                            .get();
                                    //check if the user tapping the button is a owner
                                    //don't kick the owner itself lol
                                    if (memberWhoPressedRoleCheck['role'] ==
                                        "owner") {
                                      //the kick function
                                      onLongPresses(
                                          snapshots.data.docs[index].id,
                                          snapshots.data.docs[index]['role']);
                                    }
                                  },
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black54),
                        ),
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('personal_connections')
                                .doc('${widget.teamModel.teamId}')
                                .collection('users')
                                .doc(getxController.user.value.userId)
                                .snapshots(),
                            builder: (context, snapshots) {
                              if (snapshots.hasData) {
                                if (snapshots.data['status'] == 'alive') {
                                  return Center(
                                    child: Text('Leave Group'),
                                  );
                                }
                                return Center(
                                  child: Text('Delete Group'),
                                );
                              }
                              return Container();
                            }),
                      ),
                      onTap: () async {
                        DocumentSnapshot leaveDeleteGroup =
                            await FirebaseFirestore.instance
                                .collection('personal_connections')
                                .doc('${widget.teamModel.teamId}')
                                .collection('users')
                                .doc(getxController.user.value.userId)
                                .get();

                        if (leaveDeleteGroup['status'] == 'alive') {
                          return FirebaseFirestore.instance
                              .collection('personal_connections')
                              .doc('${widget.teamModel.teamId}')
                              .collection('users')
                              .doc(getxController.user.value.userId)
                              .update({'status': 'dead'});
                        }

                        await FirebaseFirestore.instance
                            .collection('personal_connections')
                            .doc('${widget.teamModel.teamId}')
                            .collection('users')
                            .doc(getxController.user.value.userId)
                            .delete();

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc('${getxController.user.value.userId}')
                            .collection('connections')
                            .doc(widget.teamModel.teamId)
                            .delete();

                        Get.offAll(MainPage());
                      },
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
