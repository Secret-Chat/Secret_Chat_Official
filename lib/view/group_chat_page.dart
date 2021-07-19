import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupChatID;

  const GroupChatScreen({Key key, this.groupChatID}) : super(key: key);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _textController = TextEditingController();
  final getxController = Get.put(AuthController());

  //dispose the controllers
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Group ID: ${widget.groupChatID}");
    final Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: size.width,
        child: Scaffold(
          appBar: AppBar(
              // title: Text('${widget.otherUserContactModal.otherUserName}'),
              ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 68,
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
                            .doc('${widget.groupChatID}')
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
                            return ListView.builder(
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
                                itemCount: snapshot.data.docs.length);
                          }

                          return Container();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Color.fromRGBO(34, 35, 23, 0.5),
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 98,
                            width: MediaQuery.of(context).size.width - 140,
                            child: TextField(
                              decoration:
                                  InputDecoration(labelText: 'Enter Message'),
                              controller: _textController,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                if (_textController.text.isNotEmpty) {
                                  FirebaseFirestore.instance
                                      // .collection(
                                      //     'personal_connections')  //${getxController.authData}/messages')
                                      .collection('personal_connections')
                                      .doc('${widget.groupChatID}')
                                      .collection('messages')
                                      .add({
                                    'message': _textController.text,
                                    'sentBy': getxController.authData.value,
                                    'createdOn': FieldValue.serverTimestamp(),
                                  });
                                  // getxController.printer();
                                }
                                _textController.text = '';
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
