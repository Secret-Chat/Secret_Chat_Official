import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/model/user_in_group.dart';
import 'package:secretchat/view/mainPage.dart';
import 'package:secretchat/view/settingsPage.dart';
import 'package:secretchat/view/team%20chat/addMemberPage.dart';
import 'package:secretchat/view/team%20chat/teamEditingPage.dart';
import 'package:secretchat/view/user%20views/profileDetail.dart';

class ScrollGroupDetailsPage extends StatefulWidget {
  // final String groupID;
  final TeamModel teamModel;

  const ScrollGroupDetailsPage({Key key, @required this.teamModel})
      : super(key: key);

  @override
  _ScrollGroupDetailsPageState createState() => _ScrollGroupDetailsPageState();
}

class _ScrollGroupDetailsPageState extends State<ScrollGroupDetailsPage> {
  final getxController = Get.put(AuthController());
  var groupname = '';
  var descriptionName = '';
  List<UserEntity> admins = [];
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

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
    return Scaffold(
      // appBar: AppBar(
      //   title: StreamBuilder<DocumentSnapshot>(
      //     stream: FirebaseFirestore.instance
      //         .collection('personal_connections')
      //         .doc('${widget.teamModel.teamId}')
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         groupname = snapshot.data['teamName'];
      //         return GestureDetector(
      //           child: SizedBox(
      //             child: Row(
      //               children: [
      //                 SizedBox(
      //                   height: 40,
      //                   width: 40,
      //                   child: ClipOval(
      //                     child: Container(
      //                       color: Colors.grey,
      //                       child: widget.teamModel.groupIcon != ''
      //                           ? Image.network(
      //                               widget.teamModel.groupIcon,
      //                               fit: BoxFit.cover,
      //                             )
      //                           : Container(),
      //                     ),
      //                   ),
      //                 ),
      //                 SizedBox(width: 10),
      //                 Text("${snapshot.data['teamName']}"),
      //               ],
      //             ),
      //           ),
      //           onTap: () {
      //             Navigator.of(context).pop();
      //           },
      //         );
      //       }
      //       //TODO: loading spinners to implement later on
      //       return SizedBox(
      //         height: 0,
      //         width: 0,
      //       );
      //     },
      //   ),
      //   actions: [
      //     Container(
      //       child: StreamBuilder<DocumentSnapshot>(
      //           stream: FirebaseFirestore.instance
      //               .collection('personal_connections')
      //               .doc('${widget.teamModel.teamId}')
      //               .collection('users')
      //               .doc(getxController.user.value.userId)
      //               .snapshots(),
      //           builder: (context, snapshots) {
      //             if (snapshots.hasData) {
      //               if (snapshots.data['status'] == 'alive') {
      //                 return IconButton(
      //                   icon: Icon(Icons.edit),
      //                   onPressed: () {
      //                     Get.to(TeamEditingPage(
      //                       teamName: groupname,
      //                       teamDescription: descriptionName,
      //                       teamModel: widget.teamModel,
      //                     ));
      //                   },
      //                 );
      //               }
      //               return Container();
      //             }
      //             return Container();
      //           }),

      //       //   IconButton(
      //       //     icon: Icon(Icons.edit),
      //       //     onPressed: () {
      //       //       Get.to(TeamEditingPage(
      //       //         teamName: groupname,
      //       //         teamDescription: descriptionName,
      //       //         teamModel: widget.teamModel,
      //       //       ));
      //       //     },
      //       //   ),
      //       // ),
      //     ),
      //   ],
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.pink[50],
              pinned: _pinned,
              snap: _snap,
              floating: _floating,
              elevation: 0,
              expandedHeight: 212.0,

              // centerTitle: false,
              // title: Text(
              //   'All notes',
              //   style: TextStyle(color: Colors.black),
              // ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                //titlePadding: EdgeInsets.only(),
                background: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      widget.teamModel.groupIcon != ''
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                widget.teamModel.groupIcon,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(),
                      // Center(
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.transparent,
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         'All Notes',
                      //         style: TextStyle(fontSize: 25),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),

                // background: Image.network(
                //     'https://www.google.com/imgres?imgurl=https%3A%2F%2Fakm-img-a-in.tosshub.com%2Findiatoday%2Fimages%2Fstory%2F201912%2Fpost-it-notes-1284667_960_720.jpeg%3FgR6sVQyc4bC7CXp.HHR2uFzTilSyqiBP%26size%3D770%3A433&imgrefurl=https%3A%2F%2Fwww.indiatoday.in%2Finformation%2Fstory%2Fhow-to-send-google-keep-note-to-another-app-using-computer-1628978-2019-12-17&tbnid=2nli-ParvZ3ytM&vet=12ahUKEwi986KRrtXxAhUSRysKHbQdBI0QMygeegUIARCTAg..i&docid=Yoggz_UzKKqe3M&w=770&h=433&q=notes&ved=2ahUKEwi986KRrtXxAhUSRysKHbQdBI0QMygeegUIARCTAg'),
                // background: Image.network(
                //      'https://github.com/flutter/plugins/raw/master/packages/video_player/video_player/doc/demo_ipod.gif?raw=true'),
                stretchModes: [StretchMode.blurBackground],
                title: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('personal_connections')
                      .doc('${widget.teamModel.teamId}')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      groupname = snapshot.data['teamName'];
                      return GestureDetector(
                        child: Text("${snapshot.data['teamName']}"),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                    //TODO: loading spinners to implement later on
                    return SizedBox(
                      height: 0,
                      width: 0,
                    );
                  },
                ),
                //centerTitle: true,
              ),
              actions: [
                Container(
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
                            return IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Get.to(TeamEditingPage(
                                  teamName: groupname,
                                  teamDescription: descriptionName,
                                  teamModel: widget.teamModel,
                                ));
                              },
                            );
                          }
                          return Container();
                        }
                        return Container();
                      }),

                  //   IconButton(
                  //     icon: Icon(Icons.edit),
                  //     onPressed: () {
                  //       Get.to(TeamEditingPage(
                  //         teamName: groupname,
                  //         teamDescription: descriptionName,
                  //         teamModel: widget.teamModel,
                  //       ));
                  //     },
                  //   ),
                  // ),
                ),
              ],
            ),
            // SliverToBoxAdapter(
            //   child: SizedBox(
            //     height: 10,
            //   ),
            // ),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('personal_connections')
                    .doc('${widget.teamModel.teamId}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Container(
                          height: 50,
                          color: Colors.pink[100],
                          child: Center(
                              //child: CircularProgressIndicator(),
                              ),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    descriptionName = snapshot.data['description'];
                    if (descriptionName == '') {
                      return SliverToBoxAdapter(
                        child: GestureDetector(
                          child: Container(
                            color: Colors.pink[100],
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text('Add Group Description'),
                          ),
                          onTap: () {
                            Get.to(TeamEditingPage(
                              teamName: groupname,
                              teamDescription: descriptionName,
                              teamModel: widget.teamModel,
                            ));
                          },
                        ),
                      );
                    }
                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            color: Colors.pink[100],
                            child: Text(
                              'Description',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            color: Colors.pink[100],
                            child: Text("${snapshot.data['description']}"),
                          ),
                        ],
                      ),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        height: 50,
                        color: Colors.pink[100],
                        child: Center(
                            //child: CircularProgressIndicator(),
                            ),
                      ),
                    ),
                  );
                }),

            SliverToBoxAdapter(
              child: Container(
                color: Colors.pink[200],
                height: 10,
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<DocumentSnapshot>(
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
                        color: Colors.pink[100],
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
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.pink[200],
                height: 10,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.pink[100],
                alignment: Alignment.center,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('personal_connections')
                      .doc('${widget.teamModel.teamId}')
                      .collection('users')
                      .where('status', isEqualTo: 'alive')
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          height: 20,
                          color: Colors.pink[100],
                          //child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshots.hasData) {
                      return Container(
                        padding: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 5),
                        alignment: Alignment.centerLeft,
                        child: Text('${snapshots.data.docs.length} members'),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: SizedBox(
            //     height: 10,
            //   ),
            // ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('personal_connections')
                  .doc('${widget.teamModel.teamId}')
                  .collection('users')
                  .where('status', isEqualTo: 'alive')
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        color: Colors.pink[100],
                        height: 500,
                        child: Center(
                            //child: CircularProgressIndicator(),
                            ),
                      ),
                    ),
                  );
                }
                if (snapshots.hasData) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (snapshots.data.docs[index]['role'] == 'owner') {
                          admins.add(UserEntity(
                              name: snapshots.data.docs[index]['username'],
                              userId: snapshots.data.docs[index].id));
                        }
                        // print(
                        //     '${snapshots.data.docs[index]['username']}');
                        return GestureDetector(
                          child: ListTile(
                            tileColor: Colors.pink[100],
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
                            // subtitle: Text(snapshots.data.docs.
                            //     '${snapshots.data.docs[index]['about']}'),
                            trailing:
                                Text('${snapshots.data.docs[index]['role']}'),
                            onTap: () {
                              if (getxController.user.value.userId !=
                                  snapshots.data.docs[index].id) {
                                return Get.to(
                                  ProfileDetail(
                                    userId: snapshots.data.docs[index].id,
                                  ),
                                );
                              } else {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Get.to(SettingsPage());
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
                                    .doc(getxController.user.value.userId)
                                    .get();
                            //check if the user tapping the button is a owner
                            //don't kick the owner itself lol
                            if (memberWhoPressedRoleCheck['role'] == "owner") {
                              //the kick function
                              onLongPresses(snapshots.data.docs[index].id,
                                  snapshots.data.docs[index]['role']);
                            }
                          },
                        );
                      },
                      childCount: snapshots.data.docs.length,
                    ),
                  );
                }
                return SliverToBoxAdapter(
                  child: Container(),
                );
              },
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.pink[200],
                height: 5,
              ),
            ),
            SliverToBoxAdapter(
              child: GestureDetector(
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    //border: Border.all(width: 1, color: Colors.black54),
                    color: Colors.pink[100],
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
                  DocumentSnapshot leaveDeleteGroup = await FirebaseFirestore
                      .instance
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

                  Get.offAll(MainPage());

                  FirebaseFirestore.instance
                      .collection('personal_connections')
                      .doc('${widget.teamModel.teamId}')
                      .collection('users')
                      .doc(getxController.user.value.userId)
                      .delete();

                  FirebaseFirestore.instance
                      .collection('users')
                      .doc('${getxController.user.value.userId}')
                      .collection('connections')
                      .doc(widget.teamModel.teamId)
                      .delete();
                },
              ),
            ),
          ],
        ),
      ),

      // body: Container(
      //   height: MediaQuery.of(context).size.height - 50,
      //   child: Column(
      //     children: <Widget>[
      //       SizedBox(
      //         height: 10,
      //       ),
      //       Container(
      //         height: 50,
      //         child: Column(
      //           children: <Widget>[
      //             Container(
      //               alignment: Alignment.topLeft,
      //               child: Text('Description'),
      //             ),
      //             Container(
      //               alignment: Alignment.centerLeft,
      //               child: StreamBuilder<DocumentSnapshot>(
      //                 stream: FirebaseFirestore.instance
      //                     .collection('personal_connections')
      //                     .doc('${widget.teamModel.teamId}')
      //                     .snapshots(),
      //                 builder: (context, snapshot) {
      //                   if (snapshot.hasData) {
      //                     descriptionName = snapshot.data['description'];
      //                     return SizedBox(
      //                       child: Text("${snapshot.data['description']}"),
      //                     );
      //                   }
      //                   return SizedBox(
      //                     height: 0,
      //                     width: 0,
      //                   );
      //                 },
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       StreamBuilder<DocumentSnapshot>(
      //           stream: FirebaseFirestore.instance
      //               .collection('personal_connections')
      //               .doc('${widget.teamModel.teamId}')
      //               .collection('users')
      //               .doc(getxController.user.value.userId)
      //               .snapshots(),
      //           builder: (context, snapshot) {
      //             if (snapshot.hasData) {
      //               if (snapshot.data['role'] == 'owner')
      //                 return Container(
      //                   height: 50,
      //                   child: GestureDetector(
      //                     child: Center(
      //                       child: Text('Add Member'),
      //                     ),
      //                     onTap: () {
      //                       Get.to(AddMemberPage(
      //                         teamModel: widget.teamModel,
      //                       ));
      //                     },
      //                   ),
      //                 );
      //             }
      //             return Container();
      //           }),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       Container(
      //         height: MediaQuery.of(context).size.height - 250,
      //         child: Column(
      //           children: <Widget>[
      //             Container(
      //               child: StreamBuilder<QuerySnapshot>(
      //                 stream: FirebaseFirestore.instance
      //                     .collection('personal_connections')
      //                     .doc('${widget.teamModel.teamId}')
      //                     .collection('users')
      //                     .where('status', isEqualTo: 'alive')
      //                     .snapshots(),
      //                 builder: (context, snapshots) {
      //                   if (snapshots.connectionState ==
      //                       ConnectionState.waiting) {
      //                     return Center(
      //                       child: Container(
      //                         child: CircularProgressIndicator(),
      //                       ),
      //                     );
      //                   }
      //                   if (snapshots.hasData) {
      //                     return Container(
      //                       child:
      //                           Text('${snapshots.data.docs.length} members'),
      //                     );
      //                   }
      //                   return Container();
      //                 },
      //               ),
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             Container(
      //               height: 300,
      //               child: StreamBuilder<QuerySnapshot>(
      //                 stream: FirebaseFirestore.instance
      //                     .collection('personal_connections')
      //                     .doc('${widget.teamModel.teamId}')
      //                     .collection('users')
      //                     .where('status', isEqualTo: 'alive')
      //                     .snapshots(),
      //                 builder: (context, snapshots) {
      //                   if (snapshots.connectionState ==
      //                       ConnectionState.waiting) {
      //                     return Center(
      //                       child: Container(
      //                         child: CircularProgressIndicator(),
      //                       ),
      //                     );
      //                   }
      //                   if (snapshots.hasData) {
      //                     return ListView.builder(
      //                       itemCount: snapshots.data.docs.length,
      //                       itemBuilder: (context, index) {
      //                         if (snapshots.data.docs[index]['role'] ==
      //                             'owner') {
      //                           admins.add(UserEntity(
      //                               name: snapshots.data.docs[index]
      //                                   ['username'],
      //                               userId: snapshots.data.docs[index].id));
      //                         }
      //                         // print(
      //                         //     '${snapshots.data.docs[index]['username']}');
      //                         return GestureDetector(
      //                           child: ListTile(
      //                             leading: SizedBox(
      //                               height: 40,
      //                               width: 40,
      //                               child: ClipOval(
      //                                 child: Container(
      //                                   color: Colors.grey,
      //                                 ),
      //                               ),
      //                             ),
      //                             title: Text(
      //                                 '${snapshots.data.docs[index]['username']}'),
      //                             // subtitle: Text(snapshots.data.docs.
      //                             //     '${snapshots.data.docs[index]['about']}'),
      //                             trailing: Text(
      //                                 '${snapshots.data.docs[index]['role']}'),
      //                             onTap: () {
      //                               if (getxController.user.value.userId !=
      //                                   snapshots.data.docs[index].id) {
      //                                 return Get.to(
      //                                   ProfileDetail(
      //                                     userId:
      //                                         snapshots.data.docs[index].id,
      //                                   ),
      //                                 );
      //                               } else {
      //                                 Navigator.of(context).pop();
      //                                 Navigator.of(context).pop();
      //                                 Get.to(SettingsPage());
      //                               }
      //                               return null;
      //                             },
      //                           ),
      //                           onLongPress: () async {
      //                             //
      //                             // final result = admins.where((element) =>
      //                             //     element.userId ==
      //                             //     getxController.user.value.userId);
      //                             // print(result);
      //                             // if (result.isNotEmpty) {
      //                             //   onLongPresses(
      //                             //       snapshots.data.docs[index].id,
      //                             //       snapshots.data.docs[index]['role']);
      //                             //   //check admin ist

      //                             // }

      //                             //check if user tapping himself

      //                             if (getxController.user.value.userId ==
      //                                 snapshots.data.docs[index].id) {
      //                               return;
      //                             }

      //                             DocumentSnapshot memberWhoPressedRoleCheck =
      //                                 await FirebaseFirestore.instance
      //                                     .collection('personal_connections')
      //                                     .doc('${widget.teamModel.teamId}')
      //                                     .collection('users')
      //                                     .doc(getxController
      //                                         .user.value.userId)
      //                                     .get();
      //                             //check if the user tapping the button is a owner
      //                             //don't kick the owner itself lol
      //                             if (memberWhoPressedRoleCheck['role'] ==
      //                                 "owner") {
      //                               //the kick function
      //                               onLongPresses(
      //                                   snapshots.data.docs[index].id,
      //                                   snapshots.data.docs[index]['role']);
      //                             }
      //                           },
      //                         );
      //                       },
      //                     );
      //                   }
      //                   return Container();
      //                 },
      //               ),
      //             ),
      //             SizedBox(height: 5),
      //             GestureDetector(
      //               child: Container(
      //                 height: 45,
      //                 width: MediaQuery.of(context).size.width,
      //                 margin: EdgeInsets.symmetric(horizontal: 5),
      //                 decoration: BoxDecoration(
      //                   border: Border.all(width: 1, color: Colors.black54),
      //                 ),
      //                 child: StreamBuilder<DocumentSnapshot>(
      //                     stream: FirebaseFirestore.instance
      //                         .collection('personal_connections')
      //                         .doc('${widget.teamModel.teamId}')
      //                         .collection('users')
      //                         .doc(getxController.user.value.userId)
      //                         .snapshots(),
      //                     builder: (context, snapshots) {
      //                       if (snapshots.hasData) {
      //                         if (snapshots.data['status'] == 'alive') {
      //                           return Center(
      //                             child: Text('Leave Group'),
      //                           );
      //                         }
      //                         return Center(
      //                           child: Text('Delete Group'),
      //                         );
      //                       }
      //                       return Container();
      //                     }),
      //               ),
      //               onTap: () async {
      //                 DocumentSnapshot leaveDeleteGroup =
      //                     await FirebaseFirestore.instance
      //                         .collection('personal_connections')
      //                         .doc('${widget.teamModel.teamId}')
      //                         .collection('users')
      //                         .doc(getxController.user.value.userId)
      //                         .get();

      //                 if (leaveDeleteGroup['status'] == 'alive') {
      //                   return FirebaseFirestore.instance
      //                       .collection('personal_connections')
      //                       .doc('${widget.teamModel.teamId}')
      //                       .collection('users')
      //                       .doc(getxController.user.value.userId)
      //                       .update({'status': 'dead'});
      //                 }

      //                 Get.offAll(MainPage());

      //                 FirebaseFirestore.instance
      //                     .collection('personal_connections')
      //                     .doc('${widget.teamModel.teamId}')
      //                     .collection('users')
      //                     .doc(getxController.user.value.userId)
      //                     .delete();

      //                 FirebaseFirestore.instance
      //                     .collection('users')
      //                     .doc('${getxController.user.value.userId}')
      //                     .collection('connections')
      //                     .doc(widget.teamModel.teamId)
      //                     .delete();
      //               },
      //             ),
      //           ],
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
