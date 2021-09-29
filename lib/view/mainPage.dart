import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/controller/chat_sync_controller.dart';
import 'package:secretchat/model/contact.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/view/callPage.dart';
import 'package:secretchat/view/listChatScreen.dart';
import 'package:secretchat/view/personal%20chat/ChatPagePersonal.dart';
import 'package:secretchat/temp%20files/chatPage.dart';
import 'package:secretchat/view/story%20status/camera_main.dart';
import 'package:secretchat/view/storyPage.dart';
import 'package:secretchat/view/team%20chat/groupPage.dart';
import 'package:secretchat/view/user%20views/noteSelf.dart';
import 'package:secretchat/view/team%20chat/group_chat_page.dart';
import 'package:secretchat/view/user%20views/searchPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'team chat/makeGroup.dart';
import 'package:get/get.dart';
import 'settingsPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  // final instance = FirebaseFirestore.instance;
  final getxController = Get.put(AuthController());
  final ChatSyncController chatSyncController = Get.put(ChatSyncController());
  TabController tabController;
  var icon = Icons.message;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    FirebaseMessaging.onMessage;

    // fetchFromServer();
    tabController = TabController(vsync: this, length: 3)
      ..addListener(() {
        setState(() {
          print(tabController.index);
          switch (tabController.index) {
            case 0:
              icon = Icons.message_rounded;
              break;
            case 1:
              icon = Icons.camera_enhance;
              break;
            case 2:
              icon = Icons.call;
              break;
          }
        });
      });
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
        title: Text(
          'SecApp',
          style: TextStyle(
            color: Color.fromRGBO(175, 103, 235, 0.3),
          ),
        ),
        //centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          tabs: [
            Tab(
              child: Text(
                "CHATS",
                style: TextStyle(
                  color: Color.fromRGBO(175, 103, 235, 0.3),
                ),
              ),
            ),
            Tab(
              child: Text(
                "STORY",
                style: TextStyle(
                  color: Color.fromRGBO(175, 103, 235, 0.3),
                ),
              ),
            ),
            Tab(
              child: Text(
                "CALLS",
                style: TextStyle(
                  color: Color.fromRGBO(175, 103, 235, 0.3),
                ),
              ),
            ),
          ],
          indicatorColor: Color.fromRGBO(175, 103, 235, 0.3),
          controller: tabController,
        ),
        actions: [
          Container(
            //padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Icon(
                Icons.search,
                size: 25,
                color: Color.fromRGBO(175, 103, 235, 0.3),
              ),
              onTap: () {
                Get.to(SearchPage());
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 0),
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Color.fromRGBO(175, 103, 235, 0.3),
              ),
              //underline: Container(),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Container(
                    // margin: EdgeInsets.zero,
                    // color: Color.fromRGBO(175, 103, 235, 0.3),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          color: Color.fromRGBO(175, 103, 235, 0.3),
                          size: 20,
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
                PopupMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.settings,
                          color: Color.fromRGBO(175, 103, 235, 0.3),
                          size: 20,
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
                PopupMenuItem(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person_add,
                          color: Color.fromRGBO(175, 103, 235, 0.3),
                          size: 20,
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
              onSelected: (itemIdentifier) {
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
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ListChatScreen(),
          StoryPage(),
          CallPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: tabController.index == 0
            ? Icon(
                Icons.message_rounded,
                color: Colors.white,
              )
            : tabController.index == 1
                ? Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
        backgroundColor: Color.fromRGBO(235, 157, 255, 1),
        onPressed: () {
          if (tabController.index == 0) {
            return Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage()));
          }

          if (tabController.index == 1) {
            return Navigator.push(
                context, MaterialPageRoute(builder: (context) => CameraMain()));
          }
        },
      ),
    );
  }
}
