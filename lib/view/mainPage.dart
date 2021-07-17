import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secretchat/view/chatPage.dart';
import 'package:secretchat/view/noteSelf.dart';
import 'package:secretchat/view/searchPage.dart';
import 'package:get/get.dart';
import 'settingsPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
              if (itemIdentifier == 'settings') {
                // Navigator.of(context).pushNamed(SettingsPage));
                Get.to(SettingsPage());
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
