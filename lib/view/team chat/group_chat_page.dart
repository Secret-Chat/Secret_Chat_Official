import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/controller/pollController.dart';
import 'package:secretchat/controller/tagListController.dart';
import 'package:secretchat/model/poll_model.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/model/user_in_group.dart';
import 'package:secretchat/view/team%20chat/adminLounge.dart';
import 'package:secretchat/view/team%20chat/group_details.dart';

import 'package:secretchat/view/team%20chat/pinMessagesPage.dart';
import 'package:secretchat/view/webViewPage.dart';

import 'package:secretchat/widgets/custom_button.dart';
import 'package:secretchat/widgets/gifWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class GroupChatScreen extends StatefulWidget {
  // final String groupChatID;
  final TeamModel teamModel;

  const GroupChatScreen({this.teamModel});

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

TextEditingController _editingController = TextEditingController();

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _textController = TextEditingController();
  final getxController = Get.put(AuthController());
  final _pollQuestionController = TextEditingController();

  //final GifWidget gifWidget = GifWidget();
  // final _pollAnswerOne = TextEditingController();
  // final _pollAnswerTwo = TextEditingController();
  // final _pollAnswerThree = TextEditingController();
  bool showUsersTagList = false;
  TagListControllr tagListControllr = Get.put(TagListControllr());
  bool isTagMessage = false;
  List<UserEntity> taggedMembers = [];
  PollController pollController = Get.put(PollController());
  bool isGif = false;
  bool isDeletedMessage = false;
  var pinMessages = 0;
  bool isPinMessage = false;
  File pickingImage;
  File pickingGallery;

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
    listenForGif();
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

  //////////////////////////////////////////////////////////////////////////////////
  ///listening if it is gif or not jugad right now
  void listenForGif() {
    _textController.addListener(() {
      if (_textController.text.contains('https://tse')) {
        AlertDialogWidget()
          ..showGif(text: _textController.text, teamModel: widget.teamModel);
      }
    });
  }

  void showImageSendDialog() {
    showDialog(
        context: navigatorKey.currentContext,
        builder: (context) {
          return AlertDialog(
            title: Text('Image file'),
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
                        child: Image.file(pickingImage),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: GestureDetector(
                            child: Container(
                              color: Color.fromRGBO(123, 12, 34, 0.4),
                              padding: EdgeInsets.all(10),
                              child: Text('Cancel'),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            child: Container(
                              color: Color.fromRGBO(123, 12, 34, 0.4),
                              padding: EdgeInsets.all(10),
                              child: Text('Retake'),
                            ),
                            onTap: pickImage,
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
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child('personal_connections')
                                  .child(widget.teamModel.teamId + '.jpg');

                              await ref.putFile(pickingImage);

                              final url = await ref.getDownloadURL();

                              await FirebaseFirestore.instance
                                  // .collection(
                                  //     'personal_connections')  //${getxController.authData}/messages')
                                  .collection('personal_connections')
                                  .doc('${widget.teamModel.teamId}')
                                  .collection('messages')
                                  .add({
                                'message': url,
                                'sentBy': getxController.authData.value,
                                'createdOn': FieldValue.serverTimestamp(),
                                'type': 'imageMessage',
                                'isTagMessage': false,
                                'isDeleted': false,
                              });

                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showGallerySendDialog() {
    showDialog(
        context: navigatorKey.currentContext,
        builder: (context) {
          return AlertDialog(
            title: Text('Image file'),
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
                        child: Image.file(pickingGallery),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: GestureDetector(
                            child: Container(
                              color: Color.fromRGBO(123, 12, 34, 0.4),
                              padding: EdgeInsets.all(10),
                              child: Text('Cancel'),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            child: Container(
                              color: Color.fromRGBO(123, 12, 34, 0.4),
                              padding: EdgeInsets.all(10),
                              child: Text('Retake'),
                            ),
                            onTap: pickGallery,
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
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child('personal_connections')
                                  .child(widget.teamModel.teamId + '.jpg');

                              await ref.putFile(pickingGallery);

                              final url = await ref.getDownloadURL();

                              await FirebaseFirestore.instance
                                  // .collection(
                                  //     'personal_connections')  //${getxController.authData}/messages')
                                  .collection('personal_connections')
                                  .doc('${widget.teamModel.teamId}')
                                  .collection('messages')
                                  .add({
                                'message': url,
                                'sentBy': getxController.authData.value,
                                'createdOn': FieldValue.serverTimestamp(),
                                'type': 'imageMessage',
                                'isTagMessage': false,
                                'isDeleted': false,
                              });

                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 200,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      pickingImage = pickedImageFile;
    });
    if (pickingImage != null) {
      showImageSendDialog();
    }
    //Navigator.of(context).pop();
  }

  void pickGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 200,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      pickingGallery = pickedImageFile;
    });
    if (pickingGallery != null) {
      showGallerySendDialog();
    }
    //Navigator.of(context).pop();
  }

  showLinkBottomSheet() {
    return Get.bottomSheet(
      Container(
        height: 70,
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.bar_chart),
                onPressed: () {
                  AlertDialogWidget()
                    ..pollingSheet(
                        pollController: pollController,
                        teamModel: widget.teamModel);
                },
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(Icons.camera),
                onPressed: pickImage,
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(Icons.picture_in_picture),
                onPressed: pickGallery,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////////////////////
  ///seeing if the user tapped on any message basics for editing and deleting

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
                              child: widget.teamModel.groupIcon != ''
                                  ? Image.network(
                                      widget.teamModel.groupIcon,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
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
            height: MediaQuery.of(context).size.height - 83.5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          // .collection('users/${getxController.authData.value}/mescsages')
                          .collection('personal_connections')
                          .doc('${widget.teamModel.teamId}')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data['pinMessages'] != 0) {
                            return Container(
                              height: 40,
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Text(
                                        '${snapshot.data['pinMessages']} Pin Messages'),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    child: Container(
                                      child: Center(
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(left: 7),
                                                child: Icon(Icons.menu)),
                                            Transform.rotate(
                                              angle: -200.6,
                                              child: Container(
                                                color: Colors.white,
                                                child: Icon(
                                                  Icons.push_pin,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Get.to(PinMessagesPage(
                                        teamModel: widget.teamModel,
                                        pinMessages:
                                            snapshot.data['pinMessages'],
                                      ));
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ), //('${snapshot.data['pinMessages']} Pin Messages'),
                            );
                          }
                          return Container(
                            height: 0,
                            child: Text('No pinned messages'),
                          );
                        }
                        return Container();
                      }),
                ),

                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 188,
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
                          return Container();
                          // Center(
                          //   child: Container(
                          //     child: CircularProgressIndicator(),
                          //   ),
                          // );
                        }
                        if (snapshot.hasData) {
                          return Container(
                            height: size.height - 200,
                            child: ListView.builder(
                                reverse: true,
                                itemBuilder: (ctx, index) {
                                  print(snapshot.data.docs[index].data());
                                  if (snapshot.data.docs[index]['isDeleted'] ==
                                      true) {
                                    var messageId =
                                        snapshot.data.docs[index].id;
                                    print('plsplsplsplslsplspsplsplsps');
                                    var link;
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('personal_connections')
                                          .doc(widget.teamModel.teamId)
                                          .collection('messages')
                                          .doc(messageId)
                                          .collection('notShowFor')
                                          .where('userId',
                                              isEqualTo: getxController
                                                  .user.value.userId)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          print(
                                              '${snapshot.data.docs.length} iod');
                                          print('has data');
                                          // setState(() {

                                          // });
                                          if (snapshot.data.docs.length == 0) {
                                            setState(() {
                                              isDeletedMessage = false;
                                            });
                                          } else {
                                            setState(() {
                                              isDeletedMessage = true;
                                            });
                                          }
                                        }

                                        return Container();
                                      },
                                    );
                                    ////////////////////////////////////////////////////////////////////////////
                                    // FirebaseFirestore.instance
                                    //     .collection('personal_connections')
                                    //     .doc(widget.teamModel.teamId)
                                    //     .collection('messages')
                                    //     .doc(messageId)
                                    //     .collection('notShowFor')
                                    //     .where('userId',
                                    //         isEqualTo: getxController
                                    //             .user.value.userId)
                                    //     .snapshots()
                                    //     .first
                                    //     .then((value) => {
                                    //           print(value.docs.isNotEmpty),
                                    //           if (value.docs.isNotEmpty)
                                    //             {isDeletedMessage = true}
                                    //           else
                                    //             {isDeletedMessage = false}
                                    //         });
                                    ////////////////////////////////////////////////////////////////////////////////
                                    print('isitreacheing here');
                                    print(isDeletedMessage);
                                    if (isDeletedMessage == true) {
                                      setState(() {
                                        isDeletedMessage = false;
                                      });
                                      return Container();
                                    }
                                    if (snapshot.data.docs[index]['type'] ==
                                        'textMessage') {
                                      // if (snapshot.data.docs[index]['isGif'] ==
                                      //     false) {
                                      return GestureDetector(
                                        child: ListTile(
                                          leading: getxController
                                                      .authData.value !=
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
                                          // trailing: snapshot.data.docs[index]
                                          //             ['isEdited'] ==
                                          //         true
                                          //     ? Text('Edited')
                                          //     : Container(),
                                        ),
                                        onTap: () {
                                          AlertDialogWidget()
                                            ..onTapOnMessage(
                                              snapshot.data.docs[index].id,
                                              snapshot.data.docs[index]
                                                  ['message'],
                                              snapshot.data.docs[index]
                                                  ['sentBy'],
                                              snapshot.data.docs[index]
                                                  ['createdOn'],
                                              snapshot.data.docs[index]['type'],
                                              snapshot.data.docs[index]
                                                  ['isPinMessage'],
                                              widget.teamModel,
                                              snapshot.data.docs[index]
                                                  ['isTagMessage'],
                                              taggedMembers,
                                            );
                                        },
                                      );
                                      //}
                                    }

                                    if (snapshot.data.docs[index]['type'] ==
                                        'editedMessage') {
                                      // if (snapshot.data.docs[index]['isGif'] ==
                                      //     false) {
                                      return GestureDetector(
                                        child: ListTile(
                                          leading: getxController
                                                      .authData.value !=
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
                                          trailing: Text('Edited'),
                                        ),
                                        onTap: () {
                                          AlertDialogWidget()
                                            ..onTapOnMessage(
                                                snapshot.data.docs[index].id,
                                                snapshot.data.docs[index]
                                                    ['message'],
                                                snapshot.data.docs[index]
                                                    ['sentBy'],
                                                snapshot.data.docs[index]
                                                    ['createdOn'],
                                                snapshot.data.docs[index]
                                                    ['type'],
                                                snapshot.data.docs[index]
                                                    ['isPinMessage'],
                                                widget.teamModel,
                                                snapshot.data.docs[index]
                                                    ['isTagMessage'],
                                                taggedMembers);
                                        },
                                      );
                                      //}
                                    }

                                    //////////////////////////////////////////////////////////////
                                    ///getting the gif messages over here
                                    if (snapshot.data.docs[index]['type'] ==
                                        'gifMessage') {
                                      link = snapshot
                                          .data.docs[index]['message']
                                          .toString()
                                          .trimRight();
                                      print('${link}hi');
                                      return GestureDetector(
                                        child: Container(
                                          height: 200,
                                          width: 200,
                                          child: Image.network(
                                            '$link',
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        onTap: () {
                                          AlertDialogWidget()
                                            ..onTapOnMessage(
                                                snapshot.data.docs[index].id,
                                                snapshot.data.docs[index]
                                                    ['message'],
                                                snapshot.data.docs[index]
                                                    ['sentBy'],
                                                snapshot.data.docs[index]
                                                    ['createdOn'],
                                                snapshot.data.docs[index]
                                                    ['type'],
                                                snapshot.data.docs[index]
                                                    ['isPinMessage'],
                                                widget.teamModel,
                                                snapshot.data.docs[index]
                                                    ['isTagMessage'],
                                                taggedMembers);
                                        },
                                      );
                                    }

                                    if (snapshot.data.docs[index]['type'] ==
                                        'imageMessage') {
                                      var link = snapshot
                                          .data.docs[index]['message']
                                          .toString()
                                          .trimRight();
                                      print('${link}hi');
                                      return GestureDetector(
                                        child: Container(
                                          height: 200,
                                          width: 200,
                                          child: Image.network(
                                            '$link',
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        onTap: () {
                                          // AlertDialogWidget()
                                          //   ..onTapOnMessage(
                                          //       snapshot.data.docs[index].id,
                                          //       snapshot.data.docs[index]
                                          //           ['message'],
                                          //       snapshot.data.docs[index]
                                          //           ['sentBy'],
                                          //       snapshot.data.docs[index]
                                          //           ['createdOn'],
                                          //       snapshot.data.docs[index]
                                          //           ['type'],
                                          //       snapshot.data.docs[index]
                                          //           ['isPinMessage'],
                                          //       widget.teamModel,
                                          //       snapshot.data.docs[index]
                                          //           ['isTagMessage'],
                                          //       taggedMembers);
                                        },
                                      );
                                    }

                                    // .doc(
                                    //     '${getxController.user.value.userId}')
                                    // .get()
                                    // .then((value) => print(
                                    //     '${value['userId']} ridbah'))

                                    // if (!FirebaseFirestore.instance
                                    //     .collection('personal_connections')
                                    //     .doc(widget.teamModel.teamId)
                                    //     .collection('messages')
                                    //     .doc(messageId)
                                    //     .collection('notShowFor')
                                    //     .doc(getxController.user.value.userId)
                                    //     .get()
                                    //     .isBlank) {
                                    //   print('whyme');
                                    //   return Container();
                                    // }
                                    // if (snapshot.data.docs[index]['type'] ==
                                    //     'textMessage') {
                                    //   // if (snapshot.data.docs[index]['isGif'] ==
                                    //   //     false) {
                                    //   return GestureDetector(
                                    //     child: ListTile(
                                    //       leading: getxController
                                    //                   .authData.value !=
                                    //               snapshot.data.docs[index]
                                    //                   ['sentBy']
                                    //           ? Text(
                                    //               "${snapshot.data.docs[index]['sentBy']}")
                                    //           : SizedBox(
                                    //               height: 0,
                                    //               width: 0,
                                    //             ),
                                    //       title: Text(
                                    //           '${snapshot.data.docs[index]['message']}'),
                                    //       // trailing: snapshot.data.docs[index]
                                    //       //             ['isEdited'] ==
                                    //       //         true
                                    //       //     ? Text('Edited')
                                    //       //     : Container(),
                                    //     ),
                                    //     onTap: () {
                                    //       onTapOnMessage(
                                    //         snapshot.data.docs[index].id,
                                    //         snapshot.data.docs[index]
                                    //             ['message'],
                                    //         snapshot.data.docs[index]['sentBy'],
                                    //         snapshot.data.docs[index]
                                    //             ['createdOn'],
                                    //         snapshot.data.docs[index]['type'],
                                    //       );
                                    //     },
                                    //   );
                                    // }
                                  } else {
                                    print('rayyanlovessaurab');

                                    if (snapshot.data.docs[index]['type'] ==
                                        'textMessage') {
                                      // if (snapshot.data.docs[index]['isGif'] ==
                                      //     false) {
                                      return GestureDetector(
                                        child: ListTile(
                                          title: getxController
                                                      .authData.value !=
                                                  snapshot.data.docs[index]
                                                      ['sentBy']
                                              ? Text(
                                                  "${snapshot.data.docs[index]['sentByName']}")
                                              : SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                          subtitle: Linkify(
                                            onOpen: (link) async {
                                              print(
                                                  "Linkify link = ${link.url}");
                                              var linkurl =
                                                  "https://${link.url}";
                                              print(link.url);
                                              // if (await canLaunch(link.text)) {
                                              // await launch(
                                              //     "https://www.google.com/");
                                              WebViewPage(link.url);
                                              // } else {
                                              //   print(link.text);
                                              //   print('no problem');
                                              // }
                                            },
                                            text:
                                                "${snapshot.data.docs[index]['message']}",
                                            style:
                                                TextStyle(color: Colors.black),
                                            linkStyle:
                                                TextStyle(color: Colors.blue),
                                            options:
                                                LinkifyOptions(humanize: false),
                                          ),

                                          // Text(
                                          //     '${snapshot.data.docs[index]['message']}'),
                                          // trailing: Text(
                                          //     '${snapshot.data.docs[index]['createdOn'].toString().substring(10, 20)}'),
                                        ),
                                        onTap: () {
                                          AlertDialogWidget()
                                            ..onTapOnMessage(
                                                snapshot.data.docs[index].id,
                                                snapshot.data.docs[index]
                                                    ['message'],
                                                snapshot.data.docs[index]
                                                    ['sentBy'],
                                                snapshot.data.docs[index]
                                                    ['createdOn'],
                                                snapshot.data.docs[index]
                                                    ['type'],
                                                snapshot.data.docs[index]
                                                    ['isPinMessage'],
                                                widget.teamModel,
                                                snapshot.data.docs[index]
                                                    ['isTagMessage'],
                                                taggedMembers);
                                        },
                                      );
                                    }

                                    if (snapshot.data.docs[index]['type'] ==
                                        'editedMessage') {
                                      // if (snapshot.data.docs[index]['isGif'] ==
                                      //     false) {
                                      return GestureDetector(
                                        child: ListTile(
                                          title: getxController
                                                      .authData.value !=
                                                  snapshot.data.docs[index]
                                                      ['sentBy']
                                              ? Text(
                                                  "${snapshot.data.docs[index]['sentByName']}")
                                              : SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                          subtitle: Text(
                                              '${snapshot.data.docs[index]['message']}'),
                                          trailing: Text('Edited'),
                                        ),
                                        onTap: () {
                                          AlertDialogWidget()
                                            ..onTapOnMessage(
                                                snapshot.data.docs[index].id,
                                                snapshot.data.docs[index]
                                                    ['message'],
                                                snapshot.data.docs[index]
                                                    ['sentBy'],
                                                snapshot.data.docs[index]
                                                    ['createdOn'],
                                                snapshot.data.docs[index]
                                                    ['type'],
                                                snapshot.data.docs[index]
                                                    ['isPinMessage'],
                                                widget.teamModel,
                                                snapshot.data.docs[index]
                                                    ['isTagMessage'],
                                                taggedMembers);
                                        },
                                      );
                                      //}

                                    }

                                    //////////////////////////////////////////////////////////////
                                    ///getting the gif messages over here
                                    if (snapshot.data.docs[index]['type'] ==
                                        'gifMessage') {
                                      var link = snapshot
                                          .data.docs[index]['message']
                                          .toString()
                                          .trimRight();
                                      print('${link}hi');
                                      return GestureDetector(
                                        child: Container(
                                          height: 200,
                                          width: 200,
                                          child: Image.network(
                                            '$link',
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        onTap: () {
                                          AlertDialogWidget()
                                            ..onTapOnMessage(
                                              snapshot.data.docs[index].id,
                                              snapshot.data.docs[index]
                                                  ['message'],
                                              snapshot.data.docs[index]
                                                  ['sentBy'],
                                              snapshot.data.docs[index]
                                                  ['createdOn'],
                                              snapshot.data.docs[index]['type'],
                                              snapshot.data.docs[index]
                                                  ['isPinMessage'],
                                              widget.teamModel,
                                              snapshot.data.docs[index]
                                                  ['isTagMessage'],
                                              taggedMembers,
                                            );
                                        },
                                      );
                                    }
                                  }

                                  if (snapshot.data.docs[index]['type'] ==
                                      'imageMessage') {
                                    var link = snapshot
                                        .data.docs[index]['message']
                                        .toString()
                                        .trimRight();
                                    print('${link}hi');
                                    return GestureDetector(
                                      child: Container(
                                        height: 200,
                                        width: 200,
                                        child: Image.network(
                                          '$link',
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      onTap: () {
                                        // AlertDialogWidget()
                                        //   ..onTapOnMessage(
                                        //       snapshot.data.docs[index].id,
                                        //       snapshot.data.docs[index]
                                        //           ['message'],
                                        //       snapshot.data.docs[index]
                                        //           ['sentBy'],
                                        //       snapshot.data.docs[index]
                                        //           ['createdOn'],
                                        //       snapshot.data.docs[index]
                                        //           ['type'],
                                        //       snapshot.data.docs[index]
                                        //           ['isPinMessage'],
                                        //       widget.teamModel,
                                        //       snapshot.data.docs[index]
                                        //           ['isTagMessage'],
                                        //       taggedMembers);
                                      },
                                    );
                                  }

                                  if (snapshot.data.docs[index]['type'] ==
                                      'pollMessage') {
                                    return Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.red)),
                                      height: 250,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${snapshot.data.docs[index]['sentBy']}',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            '${snapshot.data.docs[index]['question']}',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          //render options for users to Tap
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection(
                                                    'personal_connections')
                                                .doc(
                                                    '${widget.teamModel.teamId}')
                                                .collection('messages')
                                                .doc(snapshot
                                                    .data.docs[index].id)
                                                .collection('pollOptions')
                                                .snapshots(),
                                            builder: (ctx,
                                                AsyncSnapshot<QuerySnapshot>
                                                    optionSnapshot) {
                                              if (optionSnapshot.hasError) {
                                                return Text(
                                                    "Some error occured");
                                              } else if (optionSnapshot
                                                  .hasData) {
                                                return Expanded(
                                                  // height: 200,
                                                  child: Container(
                                                    child: ListView.builder(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (ctx, optionIndex) {
                                                        return Container(
                                                          height: 50,
                                                          child: Card(
                                                            child: Stack(
                                                              children: [
                                                                StreamBuilder(
                                                                  stream: pollController.usersWhoPolled(
                                                                      teamId: widget
                                                                          .teamModel
                                                                          .teamId,
                                                                      messageId: snapshot
                                                                          .data
                                                                          .docs[
                                                                              index]
                                                                          .id),
                                                                  builder: (ctx,
                                                                      allUsersPolledSnapShot) {
                                                                    if (allUsersPolledSnapShot
                                                                        .hasData) {
                                                                      return StreamBuilder<
                                                                          QuerySnapshot>(
                                                                        stream: FirebaseFirestore
                                                                            .instance
                                                                            .collection('personal_connections')
                                                                            .doc('${widget.teamModel.teamId}')
                                                                            .collection('messages')
                                                                            .doc(snapshot.data.docs[index].id)
                                                                            .collection('pollOptions')
                                                                            .doc(optionSnapshot.data.docs[optionIndex].id)
                                                                            .collection('usersPolled')
                                                                            .snapshots(),
                                                                        builder:
                                                                            (context,
                                                                                specificPollSnapshot) {
                                                                          if (specificPollSnapshot
                                                                              .hasData) {
                                                                            return FractionallySizedBox(
                                                                              widthFactor: allUsersPolledSnapShot.data.docs.length == 0 ? 0 : specificPollSnapshot.data.docs.length / allUsersPolledSnapShot.data.docs.length,
                                                                              child: Container(
                                                                                color: Colors.greenAccent,
                                                                              ),
                                                                            );
                                                                          }
                                                                          return Container();
                                                                        },
                                                                      );
                                                                    }
                                                                    return Container();
                                                                  },
                                                                ),
                                                                ListTile(
                                                                  title: Text(
                                                                      '${optionSnapshot.data.docs[optionIndex]['pollText']}'),
                                                                  subtitle:
                                                                      Text(
                                                                    '',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10),
                                                                  ),
                                                                  trailing:
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            //remove the poll for that user
                                                                            pollController.revertPollOptions(
                                                                                messageId: snapshot.data.docs[index].id,
                                                                                teamId: widget.teamModel.teamId,
                                                                                pollId: optionSnapshot.data.docs[optionIndex].id,
                                                                                userId: getxController.user.value.userId);
                                                                          },
                                                                          icon:
                                                                              Icon(Icons.clear)),
                                                                  onTap: () {
                                                                    //send the poll of that specific user
                                                                    pollController.sendPollAnswer(
                                                                        messageId: snapshot
                                                                            .data
                                                                            .docs[
                                                                                index]
                                                                            .id,
                                                                        pollOptionId: optionSnapshot
                                                                            .data
                                                                            .docs[
                                                                                optionIndex]
                                                                            .id,
                                                                        teamId: widget
                                                                            .teamModel
                                                                            .teamId,
                                                                        userNameofPoller: getxController
                                                                            .user
                                                                            .value
                                                                            .userName,
                                                                        userPollingId: getxController
                                                                            .user
                                                                            .value
                                                                            .userId);
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      itemCount: optionSnapshot
                                                          .data.docs.length,
                                                    ),
                                                  ),
                                                );
                                              }
                                              return Container();
                                            },
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                            stream:
                                                pollController.usersWhoPolled(
                                                    teamId:
                                                        widget.teamModel.teamId,
                                                    messageId: snapshot
                                                        .data.docs[index].id),
                                            builder: (BuildContext ctx,
                                                AsyncSnapshot<QuerySnapshot>
                                                    usersWhopolledSnapsho) {
                                              if (usersWhopolledSnapsho
                                                  .hasData) {
                                                return Text(
                                                    '${usersWhopolledSnapsho.data.docs.length} polled');
                                              }
                                              return Container();
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Container();
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
                                            .toLowerCase())) {}
                                    return Container(
                                      child: GestureDetector(
                                        onTap: () {
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

                                          taggedMembers.forEach((element) {});
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
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 200,
                                  width:
                                      MediaQuery.of(context).size.width - 130,
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
                                            'isTagMessage': isTagMessage,
                                            'isDeleted': false,
                                            'isPinMessage': false,
                                            'sentByName': getxController
                                                .user.value.userName,
                                            //'isImage': false,
                                          },
                                        ).then(
                                          (value) {
                                            if (isTagMessage) {
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
                                            // if (isGif) {
                                            //   setState(() {
                                            //     isGif = false;
                                            //   });
                                            // }
                                          },
                                        );
                                      }
                                      _textController.text = '';
                                    },
                                  ),
                                ),
                                Container(
                                  child: IconButton(
                                    icon: Icon(Icons.attach_file),
                                    onPressed: () {
                                      showLinkBottomSheet();
                                    },
                                  ),
                                ),
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
