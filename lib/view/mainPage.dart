import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/controller/chat_sync_controller.dart';
import 'package:secretchat/model/contact.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/view/personal%20chat/ChatPagePersonal.dart';
import 'package:secretchat/temp%20files/chatPage.dart';
import 'package:secretchat/view/user%20views/noteSelf.dart';
import 'package:secretchat/view/team%20chat/group_chat_page.dart';
import 'package:secretchat/view/user%20views/searchPage.dart';
import 'team chat/makeGroup.dart';
import 'package:get/get.dart';
import 'settingsPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final instance = FirebaseFirestore.instance;
  final getxController = Get.put(AuthController());
  final ChatSyncController chatSyncController = Get.put(ChatSyncController());

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // fetchFromServer();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(('Logout'))
                    ],
                  ),
                ),
                value: 'logout',
              ),
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(('Settings'))
                    ],
                  ),
                ),
                value: 'settings',
              ),
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(('Make Group'))
                    ],
                  ),
                ),
                value: 'group',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
              if (itemIdentifier == 'settings') {
                // Navigator.of(context).pushNamed(SettingsPage));
                Get.to(SettingsPage());
              }
              if (itemIdentifier == 'group') {
                // Navigator.of(context).pushNamed(SettingsPage));
                Get.to(MakeGroup());
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.note),
                title: Text('Note to self'),
                tileColor: Color.fromRGBO(20, 20, 20, 0.2),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NoteSelf()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.circle,
                  color: Colors.black,
                ),
                title: Text('Other User'),
                tileColor: Color.fromRGBO(34, 23, 24, 0.3),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatPage()));
                },
              ),
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
                            return ListTile(
                              leading: ClipOval(
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    child: snapshot.data.docs[index]['type'] ==
                                            "personal"
                                        ? Text(
                                            '${snapshot.data.docs[index]["userName"].toString().substring(0, 1)}')
                                        : snapshot.data.docs[index]
                                                    ["groupIcon"] !=
                                                ''
                                            ? Image.network(
                                                snapshot.data.docs[index]
                                                    ['groupIcon'],
                                                fit: BoxFit.cover,
                                              )
                                            : Text(snapshot
                                                .data.docs[index]['teamName']
                                                .toString()
                                                .substring(0, 1))),
                              ),
                              title: Text(snapshot.data.docs[index]['type'] ==
                                      "personal"
                                  ? '${snapshot.data.docs[index]["userName"]}'
                                  : '${snapshot.data.docs[index]['teamName']}'),
                              subtitle: snapshot.data.docs[index]['type'] ==
                                      "personal"
                                  ? Text(
                                      '${snapshot.data.docs[index]["email"]}')
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
                                            return Text('Something went wrong');
                                          }
                                          if (snapshots.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          }
                                          if (snapshots.hasData) {
                                            return ListView.builder(
                                              itemBuilder: (context, index) {
                                                return Text(snapshots
                                                    .data.docs[0]['message']);
                                              },
                                              itemCount:
                                                  snapshots.data.docs.length,
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
                                    otherUserContactModal: Contacts(
                                        connectionId:
                                            snapshot.data.docs[index].id,
                                        otherUserEmail:
                                            snapshot.data.docs[index]["email"],
                                        otherUserName: snapshot.data.docs[index]
                                            ["userName"]),
                                  ));
                                else {
                                  // print(snapshot.data.docs[index]);
                                  Get.to(GroupChatScreen(
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
                            );
                          },
                          itemCount: snapshot.data.docs.length,
                        );
                      }
                      return Container();
                    }),
              ),
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
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        },
      ),
    );
  }
}
