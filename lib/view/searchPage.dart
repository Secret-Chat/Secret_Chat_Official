import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/controller/chatController.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _titleController = TextEditingController();

  get child => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 68,
        child: Expanded(
            child: Container(
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
                              InputDecoration(labelText: 'Search by Email'),
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
                        ChatController()
                            .searchEmailId(email: _titleController.text);
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
                  child: Container(
                child: ListTile(),
              ))
            ],
          ),
        )),
      ),
    );
  }
}
