import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/controller/chat_sync_controller.dart';
import 'package:secretchat/model/contact.dart';
import 'package:secretchat/view/ChatPagePersonal.dart';
import 'package:secretchat/temp%20files/chatPage.dart';
import 'package:secretchat/temp%20files/noteSelf.dart';
import 'package:secretchat/view/searchPage.dart';
import 'makeGroup.dart';
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
                                  child: (Text(snapshot.data.docs[index]
                                              ['type'] ==
                                          "personal"
                                      ? '${snapshot.data.docs[index]["userName"].toString().substring(0, 1)}'
                                      : '${snapshot.data.docs[index]["teamName"].toString().substring(0, 1)}')),
                                ),
                              ),
                              title: Text(snapshot.data.docs[index]['type'] ==
                                      "personal"
                                  ? '${snapshot.data.docs[index]["userName"]}'
                                  : '${snapshot.data.docs[index]['teamName']}'),
                              subtitle: Text(snapshot.data.docs[index]
                                          ['type'] ==
                                      "personal"
                                  ? '${snapshot.data.docs[index]["email"]}'
                                  : ''),
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
                              },
                              //subtitle: new Text(document.data()['company']),
                            );
                          },
                          itemCount: snapshot.data.docs.length,
                        );
                      }
                      return Container();
                    }),
              )
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
