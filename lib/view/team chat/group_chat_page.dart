import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/controller/tagListController.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/view/team%20chat/adminLounge.dart';
import 'package:secretchat/view/team%20chat/group_details.dart';

class GroupChatScreen extends StatefulWidget {
  // final String groupChatID;
  final TeamModel teamModel;

  const GroupChatScreen({this.teamModel});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _textController = TextEditingController();
  final getxController = Get.put(AuthController());
  bool showUsersTagList = false;
  TagListControllr tagListControllr = Get.put(TagListControllr());

  //dispose the controllers
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForTaggingMembers();
  }

  void listenForTaggingMembers() {
    print("listenForTaggingMembers");
    _textController.addListener(() {
      print("split ${_textController.text.split("@")}");
      if (_textController.text.endsWith('@')) {
        print("at the rate hai ");
        tagListControllr.showUserTagList.value = true;
        // });
      } else {
        // setState(() {
        //   showUsersTagList = false;
        // });
        tagListControllr.showUserTagList.value = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("Group ID: ${widget.teamModel.teamId}");
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          // leading: ClipOval(
          //   child: Container(
          //     color: Colors.grey,
          //   ),
          // ),

          centerTitle: true,
          title: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('personal_connections')
                .doc('${widget.teamModel.teamId}')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Some error occured");
              } else if (snapshot.hasData) {
                return SizedBox(
                  child: GestureDetector(
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
                    onTap: () {
                      //show the Group Details
                      //and the list of users
                      Get.to(GroupDetailsPage(
                        // groupID: widget.teamModel.teamId,
                        teamModel: widget.teamModel,
                      ));
                    },
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
              child: Row(
                children: <Widget>[
                  Container(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          // .collection('users/${getxController.authData.value}/mescsages')
                          .collection('personal_connections')
                          .doc('${widget.teamModel.teamId}')
                          .collection('users')
                          .doc(getxController.user.value.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data['role'] == "owner") {
                            return IconButton(
                              icon: Icon(Icons.admin_panel_settings),
                              onPressed: () {
                                Get.off(AdminLounge(
                                  teamModel: widget.teamModel,
                                ));
                              },
                            );
                          }
                        }
                        return Container();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 168,
                    color: Color.fromRGBO(23, 34, 24, 0.3),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          // .collection('users/${getxController.authData.value}/mescsages')
                          .collection('personal_connections')
                          .doc('${widget.teamModel.teamId}')
                          .collection('messages')
                          .orderBy('createdOn', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return Container(
                            height: size.height - 200,
                            child: ListView.builder(
                                reverse: true,
                                itemBuilder: (ctx, index) {
                                  return ListTile(
                                    leading: getxController.authData.value !=
                                            snapshot.data.docs[index]['sentBy']
                                        ? Text(
                                            "${snapshot.data.docs[index]['sentBy']}")
                                        : SizedBox(
                                            height: 0,
                                            width: 0,
                                          ),
                                    title: Text(
                                        '${snapshot.data.docs[index]['message']}'),
                                  );
                                },
                                itemCount: snapshot.data.docs.length),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),

                //show tag list
                Obx(
                  () => tagListControllr.showUserTagList.value
                      ? Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('personal_connections')
                                .doc('${widget.teamModel.teamId}')
                                .collection('users')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemBuilder: (ctx, index) {
                                    return Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          print('kk');
                                          _textController.text +=
                                              "${snapshot.data.docs[index]['username']}";
                                          // print(
                                          //     "split ${_textController.text.split("@")}");
                                        },
                                        child: Text(
                                            "${snapshot.data.docs[index]['username']}"),
                                      ),
                                    );
                                  },
                                  itemCount: snapshot.data.docs.length,
                                );
                              }
                              return Container();
                            },
                          ),
                        )
                      : Container(),
                ),
                Expanded(
                  child: Container(
                    color: Color.fromRGBO(34, 35, 23, 0.5),
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          // .collection('users/${getxController.authData.value}/mescsages')
                          .collection('personal_connections')
                          .doc('${widget.teamModel.teamId}')
                          .collection('users')
                          .doc(getxController.user.value.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data['status'] == "alive") {
                            return Row(
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  width:
                                      MediaQuery.of(context).size.width - 140,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: 'Enter Message'),
                                    controller: _textController,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                Container(
                                  child: IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () {
                                      if (_textController.text.isNotEmpty) {
                                        FirebaseFirestore.instance
                                            // .collection(
                                            //     'personal_connections')  //${getxController.authData}/messages')
                                            .collection('personal_connections')
                                            .doc('${widget.teamModel.teamId}')
                                            .collection('messages')
                                            .add(
                                          {
                                            'message': _textController.text,
                                            'sentBy':
                                                getxController.authData.value,
                                            'createdOn':
                                                FieldValue.serverTimestamp(),
                                          },
                                        );
                                        // getxController.printer();
                                      }
                                      _textController.text = '';
                                    },
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Container(
                              child: Center(
                                child: Text(
                                    "You can no longer send any messages in this group :("),
                              ),
                            );
                          }
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
