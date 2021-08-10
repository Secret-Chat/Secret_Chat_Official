import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/widgets/alertDialogWidget.dart';

class PinMessagesPage extends StatefulWidget {
  final TeamModel teamModel;
  final pinMessages;

  PinMessagesPage({this.teamModel, this.pinMessages});
  //const PinMessagesPage({ Key? key }) : super(key: key);

  @override
  _PinMessagesPageState createState() => _PinMessagesPageState();
}

class _PinMessagesPageState extends State<PinMessagesPage> {
  final getxController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.pinMessages} Pin Messages'),
        // StreamBuilder<DocumentSnapshot>(
        //   stream: FirebaseFirestore.instance
        //       .collection('personal_connections')
        //       .doc('${widget.teamModel.teamId}')
        //       .snapshots(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       Container(
        //         height: 40,
        //         child: Text('${snapshot.data['pinMessages']} Pin Messages'),
        //       );
        //     }
        //     return Container();
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 83,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 135,
                  color: Color.fromRGBO(23, 34, 24, 0.3),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        // .collection('users/${getxController.authData.value}/mescsages')
                        .collection('personal_connections')
                        .doc('${widget.teamModel.teamId}')
                        .collection('pinMessages')
                        .orderBy('createdOn', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                        // Center(
                        //   child: Container(
                        //     child: CircularProgressIndicator(),
                        //   ),
                        // );
                      }
                      if (snapshot.hasData) {
                        return Container(
                          height: MediaQuery.of(context).size.height - 200,
                          child: ListView.builder(
                            reverse: true,
                            itemBuilder: (ctx, index) {
                              print(snapshot.data.docs[index].data());

                              print('rayyanlovessaurab');

                              if (snapshot.data.docs[index]['type'] ==
                                  'textMessage') {
                                // if (snapshot.data.docs[index]['isGif'] ==
                                //     false) {

                                return GestureDetector(
                                  child: ListTile(
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
                                    // trailing: snapshot.data.docs[index]
                                    //             ['isEdited'] ==
                                    //         true
                                    //     ? Text('Edited')
                                    //     : Container(),
                                  ),
                                );
                              }

                              if (snapshot.data.docs[index]['type'] ==
                                  'editedMessage') {
                                // if (snapshot.data.docs[index]['isGif'] ==
                                //     false) {

                                return GestureDetector(
                                  child: ListTile(
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
                                    trailing: Text('Edited'),
                                  ),
                                );
                                //}

                              }

                              //////////////////////////////////////////////////////////////
                              ///getting the gif messages over here
                              if (snapshot.data.docs[index]['type'] ==
                                  'gifMessage') {
                                var link = snapshot.data.docs[index]['message']
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
                                );
                              }

                              return Container();
                            },
                            itemCount: snapshot.data.docs.length,
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text('UNPIN ALL MESSAGES'),
                  ),
                ),
                onTap: () {
                  AlertDialogWidget()..unPinAll(widget.teamModel);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
