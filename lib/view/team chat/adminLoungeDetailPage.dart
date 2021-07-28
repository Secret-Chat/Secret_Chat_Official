import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/model/user_in_group.dart';
import 'package:secretchat/view/mainPage.dart';
import 'package:secretchat/view/user%20views/profileDetail.dart';

class AdminLoungeDetailPage extends StatefulWidget {
  final TeamModel teamModel;

  AdminLoungeDetailPage({this.teamModel});
  //const AdminLoungeDetailPage({ Key? key }) : super(key: key);

  @override
  _AdminLoungeDetailPageState createState() => _AdminLoungeDetailPageState();
}

class _AdminLoungeDetailPageState extends State<AdminLoungeDetailPage> {
  final getxController = Get.put(AuthController());
  List<UserEntity> admins = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            child: GestureDetector(
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipOval(
                      child: Container(
                        color: Colors.grey,
                        child: widget.teamModel.groupIcon != ''
                            ? Image.network(
                                widget.teamModel.groupIcon,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(width: 212, child: Text('Admin Lounge Detail')),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              ////////////////////////////////////////////////////////////////////////////
              ///to be used in future
              // StreamBuilder<DocumentSnapshot>(
              //     stream: FirebaseFirestore.instance
              //         .collection('personal_connections')
              //         .doc('${widget.teamModel.teamId}')
              //         .collection('users')
              //         .doc(getxController.user.value.userId)
              //         .snapshots(),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         if (snapshot.data['role'] == 'owner')
              //           return Container(
              //             height: 50,
              //         child: GestureDetector(
              //           child: Center(
              //             child: Text('Add Member'),
              //           ),
              //           onTap: () {
              //             Get.to(AddMemberPage(
              //               teamModel: widget.teamModel,
              //             ));
              //           },
              //         ),
              //       );
              //   }
              //   return Container();
              // }),
              /////////////////////////////////////////////////////////////////////////////////

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
                            .where('role', isEqualTo: 'owner')
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
                            // }

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
                            .where('role', isEqualTo: 'owner')
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
