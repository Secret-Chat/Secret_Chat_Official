import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/controller/chatController.dart';
import 'package:secretchat/controller/user_operations.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _titleController = TextEditingController();

  get child => null;
  final search = ChatController();
  // Future<void> searchEmailId({String email}) async {
  //   var result = await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('email', isEqualTo: email)
  //       .get();
  //   print(result);

  final getxController = Get.put(AuthController());
  bool userExists = false;

  UserOperations userOperations = Get.put(UserOperations());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 68,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        decoration:
                            InputDecoration(labelText: 'Search by Username!!'),
                        controller: _titleController,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                      size: 25,
                    ),
                    onPressed: () {
                      // ignore: prefer_is_not_empty
                      // if (_titleController.text.isNotEmpty) {
                      //   FirebaseFirestore.instance
                      //       .collection(
                      //           'users/${getxController.authData}/messages')
                      //       .add({
                      //     'text': _titleController.text,
                      //     'createdOn': Timestamp.now(),
                      //   });
                      //   getxController.printer();
                      // }
                      // if (_titleController.text.isNotEmpty) {
                      //   search.searchEmailId(email: _titleController.text);
                      // }
                      _titleController.text = '';
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        //.where('username', isEqualTo: _titleController.text)

                        //.where('email')
                        .snapshots(),
                    // .collection('users/${getxController.authData.value}/mescsages')

/////////////////////////////////////////////////////////////////
                    ///.where((user) =>
                    ///             user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
////////////////////////////////////////////////////////////////////////////////////////////
                    // .collection('users')
                    // .doc('${getxController.authData.value}')
                    // .collection('messages')
                    // .orderBy('createdOn', descending: false)
                    // .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return new ListView(
                        reverse: false,
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          // if (document
                          //     .data()['email']
                          //     .contains(_titleController.text)) {
                          print('hjnedkjdkjflfflmnfdkjnfne');
                          if (document
                              .data()['username']
                              .toLowerCase()
                              .contains(_titleController.text.toLowerCase())) {
                            print(document.data()['username']);

                            return ListTile(
                              title: new Text(document.data()['email']),
                              subtitle: new Text(document.data()['username']),
                              onTap: () async {
                                //don't add if connection is already there
                                bool userExists =
                                    await userOperations.ifUserExist(
                                  document: document,
                                  getxController: getxController,
                                );
                                print(userExists);
                                //if user is not there
                                if (!userExists) {
                                  await userOperations.addContact(
                                      document, getxController);
                                } else {
                                  //TODO: send the user to chat page if the connection is already there

                                }
                              },

                              //subtitle: new Text(document.data()['company']),
                            );
                          }
                          return Container();
                          // }
                          //return print(document.data()['email']);
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
