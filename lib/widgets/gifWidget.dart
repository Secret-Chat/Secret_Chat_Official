import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/model/user_in_group.dart';

import '../main.dart';

class AlertDialogWidget {
  final getxController = Get.put(AuthController());
  final _editingController = TextEditingController();
  var pinMessages = 0;
  //const GifWidget({ Key? key }) : super(key: key);

  Future<void> showGif({String text, TeamModel teamModel}) async {
    return showDialog(
        context: navigatorKey.currentContext,
        builder: (context) {
          return AlertDialog(
            title: Text('Gif file'),
            content: SingleChildScrollView(
              child: Container(
                //height: MediaQuery.of(context).size.height - 40,
                //width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 400,
                      child: Center(
                        child: Image.network(
                          text.removeAllWhitespace,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        child: Container(
                          color: Color.fromRGBO(123, 12, 34, 0.4),
                          padding: EdgeInsets.all(10),
                          child: Text('send'),
                        ),
                        onTap: () async {
                          await FirebaseFirestore.instance
                              // .collection(
                              //     'personal_connections')  //${getxController.authData}/messages')
                              .collection('personal_connections')
                              .doc('${teamModel.teamId}')
                              .collection('messages')
                              .add({
                            'message': text,
                            'sentBy': getxController.authData.value,
                            'createdOn': FieldValue.serverTimestamp(),
                            'type': 'gifMessage',
                            'isTagMessage': false,
                            'isDeleted': false,
                            //'isGif': isGif,
                          }).then((value) => {text = ''});

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> onTapOnMessage(
      String messageId,
      String message,
      String sentBy,
      doc,
      String messageType,
      bool isPinMessage,
      TeamModel teamModel,
      bool isTagMessage,
      List<UserEntity> taggedMembers) {
    return showDialog(
        context: navigatorKey.currentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black87,
            content: Container(
              width: MediaQuery.of(context).size.width - 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  messageType == 'gifMessage' ||
                          sentBy != getxController.user.value.userId
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(
                              'Edit',
                              style: TextStyle(color: Colors.white70),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              editBottomSheet(
                                  messageId,
                                  message,
                                  doc,
                                  context,
                                  teamModel,
                                  isTagMessage,
                                  isPinMessage,
                                  taggedMembers);
                            },
                          ),
                        ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: isPinMessage == false
                          ? Text(
                              'Pin',
                              style: TextStyle(color: Colors.white70),
                            )
                          : Text(
                              'UnPin',
                              style: TextStyle(color: Colors.white70),
                            ),
                      onTap: () {
                        Navigator.of(context).pop();
                        isPinMessage == true
                            ? onUnPin(messageId, teamModel)
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text('Pin Message'),
                                      content: Container(
                                          child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                                'Do you want to pin this message in the group?'),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Spacer(),
                                                GestureDetector(
                                                  child: Container(
                                                    child: Text('Cancel'),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                SizedBox(width: 20),
                                                GestureDetector(
                                                  child: Container(
                                                    child: Text('Pin'),
                                                  ),
                                                  onTap: () async {
                                                    await onPin(
                                                        messageId,
                                                        message,
                                                        doc,
                                                        sentBy,
                                                        messageType,
                                                        teamModel);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )));
                                });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        //if (sentBy == getxController.user.value.userId) {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete message'),
                                content: Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                            'Are you sure you want to delete the message'),
                                      ),
                                      sentBy == getxController.user.value.userId
                                          ? ListTile(
                                              trailing:
                                                  Text('Delete for everyone'),
                                              onTap: () {
                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'personal_connections')
                                                    .doc('${teamModel.teamId}')
                                                    .collection('messages')
                                                    .doc('$messageId')
                                                    .delete();

                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          : Container(),
                                      ListTile(
                                        trailing: Text('No'),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        trailing: Text('Delete for me'),
                                        onTap: () {
                                          FirebaseFirestore.instance
                                              .collection(
                                                  'personal_connections')
                                              .doc('${teamModel.teamId}')
                                              .collection('messages')
                                              .doc('$messageId')
                                              .update({'isDeleted': true});

                                          FirebaseFirestore.instance
                                              .collection(
                                                  'personal_connections')
                                              .doc('${teamModel.teamId}')
                                              .collection('messages')
                                              .doc('$messageId')
                                              .collection('notShowFor')
                                              .doc(sentBy)
                                              .set({'userId': sentBy});
                                          //.add({'userId': sentBy});

                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                        // FirebaseFirestore.instance
                        //     .collection('personal_connections')
                        //     .doc('${widget.teamModel.teamId}')
                        //     .collection('messages')
                        //     .doc('$messageId')
                        //     .delete();

                        // Navigator.of(context).pop();
                        //}
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  editBottomSheet(
      String id,
      String message,
      doc,
      BuildContext context,
      TeamModel teamModel,
      bool isTagMessage,
      bool isPinMessage,
      List<UserEntity> taggedMembers) {
    // showModalBottomSheet<void>(
    //     context: context,
    //     builder: (BuildContext context) {
    _editingController.text = message;
    Get.bottomSheet(
      Container(
        //height: 200,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Text('Edit message'),
            ),
            Container(
              child: Text(message),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    //height: 200,
                    width: MediaQuery.of(context).size.width - 140,
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Enter Message'),
                      controller: _editingController,
                    ),
                  ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_editingController.text.isNotEmpty) {
                          // if (_textController.text
                          //     .contains('https://tse')) {
                          //   setState(() {
                          //     isGif = true;
                          //   });
                          // }
                          FirebaseFirestore.instance
                              // .collection(
                              //     'personal_connections')  //${getxController.authData}/messages')
                              .collection('personal_connections')
                              .doc('${teamModel.teamId}')
                              .collection('messages')
                              .doc(id)
                              .update(
                            {
                              'message': _editingController.text,
                              'sentBy': getxController.authData.value,
                              //'createdOn': doc,
                              'type': 'editedMessage',
                              'isTagMessage': isTagMessage,

                              //'isGif': isGif,
                            },
                          ).then(
                            (value) {
                              print("docId: $id");
                              if (isTagMessage) {
                                print("sending taggedmembers to db");
                                taggedMembers.forEach(
                                  (element) {
                                    FirebaseFirestore.instance
                                        // .collection(
                                        //     'personal_connections')  //${getxController.authData}/messages')
                                        .collection('personal_connections')
                                        .doc('${teamModel.teamId}')
                                        .collection('messages')
                                        .doc(id)
                                        .collection('taggedMembers')
                                        .doc(element.userId)
                                        .set(element.toMap())
                                        .then((value) {
                                      isTagMessage = false;
                                      taggedMembers.clear();
                                    });
                                  },
                                );
                              }
                              // if (isGif) {
                              //   setState(() {
                              //     isGif = false;
                              //   });
                              // }
                            },
                          );
                          Navigator.of(context).pop();
                          _editingController.text = '';
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  onPin(String messageId, String message, doc, String sentBy, String type,
      TeamModel teamModel) async {
    var pin = await FirebaseFirestore.instance
        .collection('personal_connections')
        .doc(teamModel.teamId)
        .collection('pinMessages')
        .get();

    pinMessages = pin.docs.length;
    //setState(() {
    pinMessages = pinMessages + 1;
    //});

    await FirebaseFirestore.instance
        .collection('personal_connections')
        .doc(teamModel.teamId)
        .update({'pinMessages': pinMessages});

    await FirebaseFirestore.instance
        .collection('personal_connections')
        .doc(teamModel.teamId)
        .collection('messages')
        .doc(messageId)
        .update({'isPinMessage': true});

    await FirebaseFirestore.instance
        .collection('personal_connections')
        .doc(teamModel.teamId)
        .collection('pinMessages')
        .doc(messageId)
        .set({
      'messageId': messageId,
      'createdOn': doc,
      'sentBy': sentBy,
      'message': message,
      'type': type,
    });
  }

  onUnPin(String messageId, TeamModel teamModel) async {
    var pin = await FirebaseFirestore.instance
        .collection('personal_connections')
        .doc(teamModel.teamId)
        .collection('pinMessages')
        .get();

    pinMessages = pin.docs.length;
    //setState(() {
    pinMessages = pinMessages - 1;
    //});

    await FirebaseFirestore.instance
        .collection('personal_connections')
        .doc(teamModel.teamId)
        .update({'pinMessages': pinMessages});

    await FirebaseFirestore.instance
        .collection('personal_connections')
        .doc(teamModel.teamId)
        .collection('messages')
        .doc(messageId)
        .update({'isPinMessage': false});

    await FirebaseFirestore.instance
        .collection('personal_connections')
        .doc(teamModel.teamId)
        .collection('pinMessages')
        .doc(messageId)
        .delete();
  }
}
