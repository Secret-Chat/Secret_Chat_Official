import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/controller/chat_sync_controller.dart';
import 'package:secretchat/view/user%20views/profileDetail.dart';
import 'package:secretchat/view/webViewPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../model/contact.dart';

class ChatPagePersonal extends StatefulWidget {
  //const ChatPagePro({ Key? key }) : super(key: key);
  final Contacts personalChatModel;
  ChatPagePersonal({this.personalChatModel});

  @override
  _ChatPagePersonalState createState() => _ChatPagePersonalState();
}

class _ChatPagePersonalState extends State<ChatPagePersonal> {
  final _textController = TextEditingController();
  final getxController = Get.put(AuthController());
  final chatSyncController = ChatSyncController();
  String videoId;
  YoutubePlayerController _controller;

  //dispose the controllers
  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  onTapMessage(String messageId, String message, String sentBy) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Reply'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Copy'),
                      onTap: () async {
                        await FlutterClipboard.copy(message);

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Color.fromRGBO(20, 20, 20, 1),
                            content: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    child: Text(
                                      'The message has been copied',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Edit'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Pin'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Delete'),
                      onTap: () {
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
                                                    .doc(
                                                        '${widget.personalChatModel.chatId}')
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
                                        onTap: () async {
                                          if (getxController
                                                  .user.value.userId !=
                                              widget.personalChatModel
                                                  .otherUserId) {
                                            await FirebaseFirestore.instance
                                                .collection(
                                                    'personal_connections')
                                                .doc(
                                                    '${widget.personalChatModel.chatId}')
                                                .collection('messages')
                                                .doc('$messageId')
                                                .update({'deleteForOne': true});
                                          } else {
                                            FirebaseFirestore.instance
                                                .collection(
                                                    'personal_connections')
                                                .doc(
                                                    '${widget.personalChatModel.chatId}')
                                                .collection('messages')
                                                .doc('$messageId')
                                                .update({'deleteForTwo': true});
                                          }

                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
    // Get.defaultDialog(
    //   content: Container(
    //     child: Column(
    //       children: <Widget>[
    //         ListTile(
    //           title: Text('Copy'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  showYouBottomSheet(String linkurl) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          height: 300,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 50,
                color: Color.fromRGBO(20, 20, 20, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.close,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Open YouTube',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      onTap: () async {
                        await launch(linkurl);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 250,
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: '$videoId',
                    flags: YoutubePlayerFlags(
                      mute: false,
                      autoPlay: true,
                      isLive: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.white54,
                  //videoProgressIndicatorColor: Colors.amber,
                  progressColors: ProgressBarColors(
                    playedColor: Colors.white,
                    handleColor: Colors.white54,
                  ),
                  onReady: () {
                    _controller.addListener(() {});
                  },
                  // onReady: () {
                  //   _controller.addListener();
                  // },
                  // onReady () {
                  //     _controller.addListener(listener);
                  // },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // dropDownButtonShow() {
  //   return DropdownButton(
  //     icon: Icon(
  //       Icons.more_vert,
  //       color: Theme.of(context).primaryIconTheme.color,
  //     ),
  //     underline: Container(),
  //     items: [
  //       DropdownMenuItem(
  //         child: Container(
  //           child: Row(
  //             children: <Widget>[
  //               Icon(
  //                 Icons.exit_to_app,
  //                 color: Colors.black,
  //               ),
  //               SizedBox(
  //                 width: 8,
  //               ),
  //               Text(('Logout'))
  //             ],
  //           ),
  //         ),
  //         value: 'logout',
  //       ),
  //       DropdownMenuItem(
  //         child: Container(
  //           child: Row(
  //             children: <Widget>[
  //               Icon(
  //                 Icons.exit_to_app,
  //                 color: Colors.black,
  //               ),
  //               SizedBox(
  //                 width: 8,
  //               ),
  //               Text(('Settings'))
  //             ],
  //           ),
  //         ),
  //         value: 'settings',
  //       ),
  //       DropdownMenuItem(
  //         child: Container(
  //           child: Row(
  //             children: <Widget>[
  //               Icon(
  //                 Icons.exit_to_app,
  //                 color: Colors.black,
  //               ),
  //               SizedBox(
  //                 width: 8,
  //               ),
  //               Text(('Make Group'))
  //             ],
  //           ),
  //         ),
  //         value: 'group',
  //       ),
  //     ],
  //     onChanged: (itemIdentifier) {
  //       if (itemIdentifier == 'logout') {
  //         //FirebaseAuth.instance.signOut();
  //       }
  //       if (itemIdentifier == 'settings') {
  //         // Navigator.of(context).pushNamed(SettingsPage));
  //         //Get.to(SettingsPage());
  //       }
  //       if (itemIdentifier == 'group') {
  //         // Navigator.of(context).pushNamed(SettingsPage));
  //         //Get.to(MakeGroup());
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    //print(widget.otherUserContactModal.connectionId);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Container(
            child: Text('${widget.personalChatModel.otherUserName}'),
          ),
          onTap: () {
            Get.to(
              ProfileDetail(
                userId: widget.personalChatModel.otherUserId,
              ),
            );
          },
        ),
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
                        .doc('${widget.personalChatModel.chatId}')
                        .collection('messages')
                        .orderBy('createdOn', descending: true)
                        .snapshots(),
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

                      if (snapshot.hasData) {
                        //keep in local storage
                        chatSyncController.syncFromServerPersonalConnectionList(
                            snapshot.data.docs,
                            widget.personalChatModel.chatId);
                        return ListView.builder(
                            reverse: true,
                            itemBuilder: (ctx, index) {
                              return (snapshot.data.docs[index]
                                                  ['deleteForOne'] ==
                                              true &&
                                          getxController.user.value.userId !=
                                              widget.personalChatModel
                                                  .otherUserId) ||
                                      (snapshot.data.docs[index]
                                                  ['deleteForTwo'] ==
                                              true &&
                                          getxController.user.value.userId ==
                                              widget.personalChatModel
                                                  .otherUserId)
                                  ? Container()
                                  : GestureDetector(
                                      child: ListTile(
                                        title: getxController.authData.value !=
                                                snapshot.data.docs[index]
                                                    ['sentBy']
                                            ? Text(
                                                "${widget.personalChatModel.otherUserName}")
                                            : SizedBox(
                                                height: 0,
                                                width: 0,
                                              ),
                                        // title: Text(
                                        //     '${snapshot.data.docs[index]['message']}'),
                                        subtitle: Linkify(
                                          onOpen: (link) async {
                                            print("Linkify link = ${link.url}");
                                            var linkurl = "https://${link.url}";
                                            print(link.url);
                                            // if (await canLaunch(link.text)) {
                                            // await launch(
                                            //     "https://www.google.com/");
                                            if (link.url.contains("youtu")) {
                                              setState(() {
                                                videoId = YoutubePlayer
                                                    .convertUrlToId(
                                                        "${link.url}");
                                                print(videoId);
                                              });

                                              return showYouBottomSheet(
                                                  link.url);
                                              // return YoutubeBottomSheet()
                                              //   ..showYouBottomSheet(
                                              //       videoId,
                                              //       link.url,
                                              //       context,
                                              //       _controller);
                                            }
                                            Get.to(WebViewPage(link.url));

                                            // } else {
                                            //   print(link.text);
                                            //   print('no problem');
                                            // }
                                          },
                                          text:
                                              "${snapshot.data.docs[index]['message']}",
                                          style:
                                              TextStyle(color: Colors.black45),
                                          linkStyle:
                                              TextStyle(color: Colors.blue),
                                          options:
                                              LinkifyOptions(humanize: false),
                                        ),
                                      ),
                                      onTap: () {
                                        onTapMessage(
                                            snapshot.data.docs[index].id,
                                            snapshot.data.docs[index]
                                                ['message'],
                                            snapshot.data.docs[index]
                                                ['sentBy']);
                                        // dropDownButtonShow();
                                      },
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
                                  .doc('${widget.personalChatModel.chatId}')
                                  .collection('messages')
                                  .add({
                                'message': _textController.text,
                                'sentBy': getxController.authData.value,
                                'createdOn': FieldValue.serverTimestamp(),
                                'deleteForOne': false,
                                'deleteForTwo': false,
                              });
                              // getxController.printer();
                            }
                            _textController.text = '';
                          },
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        child: RaisedButton(onPressed: () {
                          print('predd');
                          chatSyncController
                              .checkIfDBWorked(widget.personalChatModel.chatId);
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
