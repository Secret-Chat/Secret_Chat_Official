import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/controller/tagListController.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/model/user_in_group.dart';
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
  final _pollQuestionController = TextEditingController();
  final _pollAnswerOne = TextEditingController();
  final _pollAnswerTwo = TextEditingController();
  final _pollAnswerThree = TextEditingController();
  bool showUsersTagList = false;
  TagListControllr tagListControllr = Get.put(TagListControllr());
  bool isTagMessage = false;
  List<UserEntity> taggedMembers = [];

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
    // print("listenForTaggingMembers");
    _textController.addListener(() {
      // print("split ${_textController.text.split("@")}");
      if (_textController.text.endsWith('@')) {
        // print("at the rate hai ");
        tagListControllr.showUserTagList.value = true;
        isTagMessage = true;
        // });
      } else {
        // setState(() {
        //   showUsersTagList = false;
        // });
        tagListControllr.showUserTagList.value = false;
        // isTagMessage = false;
      }
    });
  }

  pollingSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 40,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Text('Polling'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Polling Question'),
                  ),
                  Container(
                    child: TextField(
                      controller: _pollQuestionController,
                      decoration: InputDecoration(hintText: 'Ask a question'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Text('Answer Options'),
                  ),
                  Container(
                    child: TextField(
                      controller: _pollAnswerOne,
                      decoration: InputDecoration(hintText: 'Option'),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: _pollAnswerTwo,
                      decoration: InputDecoration(hintText: 'Option'),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: _pollAnswerThree,
                      decoration: InputDecoration(hintText: 'Option'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: GestureDetector(
                      child: Text('Create Poll'),
                      onTap: () {
                        print('iam pressed');
                        if (_pollQuestionController.text.isNotEmpty &&
                            _pollAnswerOne.text.isNotEmpty &&
                            _pollAnswerTwo.text.isNotEmpty &&
                            _pollAnswerThree.text.isNotEmpty) {
                          FirebaseFirestore.instance
                              // .collection(
                              //     'personal_connections')  //${getxController.authData}/messages')
                              .collection('personal_connections')
                              .doc('${widget.teamModel.teamId}')
                              .collection('messages')
                              .add(
                            {
                              'message': _textController.text,
                              'sentBy': getxController.authData.value,
                              'createdOn': FieldValue.serverTimestamp(),
                              'type': 'pollingMessage',
                              'question': _pollQuestionController.text,
                              // 'optionOne': _pollAnswerOne.text,
                              // 'optionTwo': _pollAnswerTwo.text,
                              // 'optionThree': _pollAnswerThree.text,
                            },
                          ).then((value) {
                            FirebaseFirestore.instance
                                .collection('personal_connections')
                                .doc('${widget.teamModel.teamId}')
                                .collection('messages')
                                .doc(value.id)
                                .collection('pollOptions')
                                .doc('');
                          });

                          //FirebaseFirestore.instance.collection('personal_connections').doc('${widget.teamModel.teamId}').collection('messages').
                          // getxController.printer();
                        }
                        _pollQuestionController.text = '';
                        _pollAnswerOne.text = '';
                        _pollAnswerTwo.text = '';
                        _pollAnswerThree.text = '';

                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
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
                                  if (snapshot.data.docs[index]['type'] ==
                                      'textMessage') {
                                    return ListTile(
                                      leading: getxController.authData.value !=
                                              snapshot.data.docs[index]
                                                  ['sentBy']
                                          ? Text(
                                              "${snapshot.data.docs[index]['sentBy']}")
                                          : SizedBox(
                                              height: 0,
                                              width: 0,
                                            ),
                                      title: Text(
                                          '${snapshot.data.docs[index]['message']}'),
                                    );
                                  }
                                  return Container(
                                    height: 300,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          color:
                                              Color.fromRGBO(12, 96, 255, 0.4),
                                          child: Text(
                                              '${snapshot.data.docs[index]['question']}'),
                                        ),
                                        Container(
                                          color:
                                              Color.fromRGBO(12, 96, 255, 0.4),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'poll',
                                            style: TextStyle(fontSize: 1),
                                          ),
                                        ),
                                        Container(
                                          color:
                                              Color.fromRGBO(12, 96, 255, 0.4),
                                          child: Text(
                                            '${snapshot.data.docs[index]['sentBy']}',
                                            style: TextStyle(fontSize: 2),
                                          ),
                                        ),
                                        ListTile(
                                          tileColor:
                                              Color.fromRGBO(12, 96, 255, 0.4),
                                          leading: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.black),
                                                shape: BoxShape.circle),
                                            child: GestureDetector(
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: SizedBox(
                                                  height: 0,
                                                ),
                                              ),
                                              onTap: () {},
                                            ),
                                          ),
                                          title: Text(
                                              '${snapshot.data.docs[index]['optionOne']}'),
                                          subtitle: Text(
                                            '',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                        ListTile(
                                          tileColor:
                                              Color.fromRGBO(12, 96, 255, 0.4),
                                          leading: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.black),
                                                shape: BoxShape.circle),
                                            child: GestureDetector(
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: SizedBox(
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                              '${snapshot.data.docs[index]['optionTwo']}'),
                                          subtitle: Text(
                                            '',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                        ListTile(
                                          tileColor:
                                              Color.fromRGBO(12, 96, 255, 0.4),
                                          leading: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.black),
                                                shape: BoxShape.circle),
                                            child: GestureDetector(
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: SizedBox(
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                              '${snapshot.data.docs[index]['optionThree']}'),
                                          subtitle: Text(
                                            '',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                    if (snapshot.data.docs[index]['username']
                                        .toString()
                                        .toLowerCase()
                                        .contains(_textController.text
                                            .toString()
                                            .toLowerCase())) {
                                      print(
                                          "matches: ${snapshot.data.docs[index]['username']}");
                                    }
                                    return Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          print('kk');
                                          _textController.text +=
                                              "${snapshot.data.docs[index]['username']}";
                                          // print(
                                          //     "split ${_textController.text.split("@")}");
                                          tagListControllr
                                                  .showUserTagList.value =
                                              false; //hide the UI after tapping

                                          taggedMembers.add(UserEntity(
                                              name: snapshot.data.docs[index]
                                                  ['username'],
                                              userId: snapshot
                                                  .data.docs[index].id));

                                          taggedMembers.forEach((element) {
                                            print("tagged");
                                            print(element.toString());
                                          });
                                          isTagMessage = true;
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
                                            'type': 'textMessage',
                                            'isTagMessage': isTagMessage
                                          },
                                        ).then(
                                          (value) {
                                            print("docId: ${value.id}");
                                            if (isTagMessage) {
                                              print(
                                                  "sending taggedmembers to db");
                                              taggedMembers.forEach(
                                                (element) {
                                                  FirebaseFirestore.instance
                                                      // .collection(
                                                      //     'personal_connections')  //${getxController.authData}/messages')
                                                      .collection(
                                                          'personal_connections')
                                                      .doc(
                                                          '${widget.teamModel.teamId}')
                                                      .collection('messages')
                                                      .doc(value.id)
                                                      .collection(
                                                          'taggedMembers')
                                                      .doc(element.userId)
                                                      .set(element.toMap())
                                                      .then((value) {
                                                    isTagMessage = false;
                                                    taggedMembers.clear();
                                                  });
                                                },
                                              );
                                            }
                                          },
                                        );
                                      }
                                      _textController.text = '';
                                    },
                                  ),
                                ),
                                Container(
                                  child: IconButton(
                                    icon: Icon(Icons.bar_chart),
                                    onPressed: () {
                                      pollingSheet();
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
