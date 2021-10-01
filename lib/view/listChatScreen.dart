import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/controller/chat_sync_controller.dart';
import 'package:secretchat/model/contact.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/view/personal%20chat/ChatPagePersonal.dart';
import 'package:secretchat/temp%20files/chatPage.dart';
import 'package:secretchat/view/team%20chat/groupPage.dart';
import 'package:secretchat/view/user%20views/noteSelf.dart';
import 'package:secretchat/view/team%20chat/group_chat_page.dart';
import 'package:secretchat/view/user%20views/searchPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'team chat/makeGroup.dart';
import 'package:get/get.dart';
import 'settingsPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ListChatScreen extends StatefulWidget {
  @override
  _ListChatScreenState createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen> {
  // final instance = FirebaseFirestore.instance;
  final getxController = Get.put(AuthController());
  final ChatSyncController chatSyncController = Get.put(ChatSyncController());
  //TabController tabController;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    FirebaseMessaging.onMessage;

    // fetchFromServer();
    // tabController = TabController(vsync: this, length: 4)
    //   ..addListener(() {
    //     setState(() {
    //       switch (tabController.index) {
    //         case 0:
    //           break;
    //         case 1:
    //           //fabIcon = Icons.message;
    //           break;
    //         case 2:
    //           //fabIcon = Icons.camera_enhance;
    //           break;
    //         case 3:
    //           //fabIcon = Icons.call;
    //           break;
    //       }
    //     });
    //   });
  }

  // void fetchFromServer() {
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(getxController.user.value.userId)
  //       .collection("connections")
  //       .snapshots()
  //       .listen((event) {
  //     chatSyncController.syncFromServerPersonalConnectionList(
  //         data: event.docs);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        color: Colors.black,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: ListTile(
                leading: ClipOval(
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(175, 103, 235, 0.3),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.notes,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'Note to self',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NoteSelf()));
                },
              ),
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.circle,
            //     color: Colors.black,
            //   ),
            //   title: Text('Other User'),
            //   tileColor: Color.fromRGBO(34, 23, 24, 0.3),
            //   onTap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => ChatPage()));
            //   },
            // ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(getxController.user.value.userId)
                      .collection("connections")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    // print(snapshot.data);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // if (snapshot.hasError) {
                    //   Center(
                    //     child: CircularProgressIndicator(),
                    //   );
                    // }

                    if (snapshot.hasData) {
                      // chatSyncController.syncFromServerPersonalConnectionList(
                      //     data: snapshot.data.docs);

                      return ListView.builder(
                        itemBuilder: (ctx, index) {
                          print("type: ${snapshot.data.docs[index]['type']}");
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9),
                              ),
                              color: Color.fromRGBO(175, 103, 235, 0.05),
                            ),
                            child: ListTile(
                              leading:
                                  // ClipOval(
                                  //   child:
                                  Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Color.fromRGBO(175, 103, 235, 0.3),
                                ),
                                child: snapshot.data.docs[index]['type'] ==
                                        "personal"
                                    ? Center(
                                        child: Text(
                                          '${snapshot.data.docs[index]["userName"].toString().substring(0, 1)}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : snapshot.data.docs[index]["groupIcon"] !=
                                            ''
                                        ? Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              color: Color.fromRGBO(
                                                  175, 103, 235, 0.3),
                                            ),
                                            child: Image.network(
                                              snapshot.data.docs[index]
                                                  ['groupIcon'],
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Center(
                                            child: Text(
                                              snapshot
                                                  .data.docs[index]['teamName']
                                                  .toString()
                                                  .substring(0, 1),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                              ),
                              //),
                              title: Text(
                                snapshot.data.docs[index]['type'] == "personal"
                                    ? '${snapshot.data.docs[index]["userName"]}'
                                    : '${snapshot.data.docs[index]['teamName']}',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: snapshot.data.docs[index]['type'] ==
                                      "personal"
                                  // ? Text(
                                  //     '${snapshot.data.docs[index]["email"]}')
                                  ? Container(
                                      height: 20,
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('personal_connections')
                                            .doc(snapshot.data.docs[index].id)
                                            .collection('messages')
                                            .orderBy('createdOn',
                                                descending: true)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshots) {
                                          if (snapshots.hasError) {
                                            return Text(
                                              'Something went wrong',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          }
                                          if (snapshots.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          }
                                          if (snapshots.hasData) {
                                            return ListView.builder(
                                              itemBuilder: (context, index1) {
                                                if (snapshots
                                                    .data.docs.isEmpty) {
                                                  return Text(
                                                    '${snapshot.data.docs[index]["email"]}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  );
                                                }
                                                return Text(
                                                  snapshots.data.docs[0]
                                                      ['message'],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                );
                                              },
                                              itemCount: 1,
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                    )
                                  : Container(
                                      height: 20,
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('personal_connections')
                                            .doc(snapshot.data.docs[index].id)
                                            .collection('messages')
                                            .orderBy('createdOn',
                                                descending: true)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshots) {
                                          if (snapshots.hasError) {
                                            return Text(
                                              'Something went wrong',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            );
                                          }
                                          if (snapshots.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          }
                                          if (snapshots.hasData) {
                                            return ListView.builder(
                                              itemBuilder: (context, index) {
                                                if (snapshots
                                                    .data.docs.isEmpty) {
                                                  return Container();
                                                }
                                                return Text(
                                                  snapshots.data
                                                          .docs[0]['message']
                                                          .toString()
                                                          .contains(
                                                              'https://tse')
                                                      ? 'GIF'
                                                      : snapshots
                                                              .data
                                                              .docs[0]
                                                                  ['message']
                                                              .toString()
                                                              .contains(
                                                                  'https://firebasestorage')
                                                          ? 'Image'
                                                          : snapshots
                                                                  .data.docs[0]
                                                              ['message'],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                );
                                              },
                                              itemCount: 1,
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                              onTap: () {
                                //only go to personal if the type is personal
                                if (snapshot.data.docs[index]['type'] ==
                                    "personal")
                                  Get.to(ChatPagePersonal(
                                    personalChatModel: Contacts(
                                        chatId: snapshot.data.docs[index].id,
                                        otherUserId: snapshot.data.docs[index]
                                            ["userId"],
                                        otherUserEmail:
                                            snapshot.data.docs[index]["email"],
                                        otherUserName: snapshot.data.docs[index]
                                            ["userName"]),
                                  ));
                                else {
                                  // print(snapshot.data.docs[index]);
                                  Get.to(GroupPage(
                                    teamModel: TeamModel(
                                      // createdBy: snapshot.data.docs[index]
                                      //     ['createdBy'],
                                      // createdOn: snapshot.data.docs[index]
                                      //     ['createdOn'],
                                      teamName: snapshot.data.docs[index]
                                          ['teamName'],
                                      teamId: snapshot.data.docs[index].id,
                                      groupIcon: snapshot.data.docs[index]
                                          ['groupIcon'],
                                    ),
                                  ));
                                }
                              },
                              //subtitle: new Text(document.data()['company']),
                            ),
                          );
                        },
                        itemCount: snapshot.data.docs.length,
                      );
                    }
                    return Container();
                  }),
            ),
            // Container(
            //   child: InkWell(
            //     child: Text('open google'),
            //     onTap: () => launch('https://www.google.com/'),
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // Container(
            //   child: Linkify(
            //     onOpen: (link) async {
            //       print("Linkify link = ${link.url}");
            //       var linkurl = "https://${link.url}";
            //       print(link.url);
            //       //if (await canLaunch(link.text)) {
            //       await launch(link.url);
            //       // } else {
            //       //   print(link.text);
            //       //   print('no problem');
            //       // }
            //     },
            //     text: "Linkify click -  https://www.google.com/",
            //     style: TextStyle(color: Colors.black),
            //     linkStyle: TextStyle(color: Colors.blue),
            //     options: LinkifyOptions(humanize: false),
            //   ),
            // ),

            // Container(
            //   height: 200,
            //   width: 200,
            //   child: Image.network(
            //       'https://tse1.mm.bing.net/th?id=OGC.2bdbd4fdb7b20ac6c0718da73c598f3f&pid=Api&rurl=https%3a%2f%2fmedia.giphy.com%2fmedia%2f12XkB6MEykrhU4%2fgiphy.gif&ehk=kss5j0cNswFG2S9YcdxyRyLTAnW%2f2vFJfliBTHRWXwU%3d'),
            // ),
            // Container(
            //   height: 200,
            //   width: 200,
            //   child: Image.network(
            //       'https://tse1.mm.bing.net/th?id=OGC.6bf35a1f1359441764cf832b2d0f698b&pid=Api&rurl=https%3a%2f%2fmedia.tenor.co%2fimages%2f6bf35a1f1359441764cf832b2d0f698b%2fraw&ehk=NIfPGU4Hz93GH%2fwyKnuSpkGzH0lXjD%2fxVPhJL6QAZXM%3d'),
            // ),
          ],
        ),
      ),
    );
  }
}
