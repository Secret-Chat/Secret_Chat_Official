import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/view/mainPage.dart';
import 'package:secretchat/view/team%20chat/teamName.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';

class TeamEditingPage extends StatefulWidget {
  final TeamModel teamModel;
  var teamName;
  var teamDescription;

  TeamEditingPage({this.teamModel, this.teamName, this.teamDescription});
  //const TeamEditingPage({ Key? key }) : super(key: key);

  @override
  _TeamEditingPageState createState() => _TeamEditingPageState();
}

class _TeamEditingPageState extends State<TeamEditingPage> {
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();
  final getxController = Get.put(AuthController());
  File pickingImage;
  File pickingGallery;
  bool pickImageTrue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // titleChange();
    // descriptionChange();
  }

  // void titleChange() {
  //   _titleController.addListener(() {
  //     if (_titleController.text != widget.teamName) {
  //       _titleController.text = _titleController.text;
  //     }
  //   });
  // }

  // void descriptionChange() {
  //   _descriptionController.addListener(() {
  //     if (_descriptionController.text != widget.teamDescription) {
  //       _descriptionController.text = _descriptionController.text;
  //     }
  //   });
  // }

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
                                  .child(widget.teamModel.teamId)
                                  .child(getxController.user.value.userId +
                                      '.jpg');

                              await ref.putFile(pickingImage);

                              final url = await ref.getDownloadURL();

                              await FirebaseFirestore.instance
                                  // .collection(
                                  //     'personal_connections')  //${getxController.authData}/messages')
                                  .collection('personal_connections')
                                  .doc('${widget.teamModel.teamId}')
                                  .update({'groupIcon': url});

                              FirebaseFirestore.instance
                                  .collection('personal_connections')
                                  .doc('${widget.teamModel.teamId}')
                                  .collection('users')
                                  //.where('status', isEqualTo: 'alive')
                                  .get()
                                  .then((QuerySnapshot value) async {
                                value.docs.forEach((element) async {
                                  print("doc snap: ${element.id}");
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(element.id)
                                      .collection('connections')
                                      .doc(widget.teamModel.teamId)
                                      .update({
                                    'groupIcon': url,
                                  });
                                });
                              });

                              pickImageTrue = true;

                              Get.offAll(MainPage());
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
                                  .child(widget.teamModel.teamId)
                                  .child(getxController.user.value.userId +
                                      '.jpg');

                              await ref.putFile(pickingGallery);

                              final url = await ref.getDownloadURL();

                              await FirebaseFirestore.instance
                                  // .collection(
                                  //     'personal_connections')  //${getxController.authData}/messages')
                                  .collection('personal_connections')
                                  .doc('${widget.teamModel.teamId}')
                                  .update({'groupIcon': url});

                              FirebaseFirestore.instance
                                  .collection('personal_connections')
                                  .doc('${widget.teamModel.teamId}')
                                  .collection('users')
                                  //.where('status', isEqualTo: 'alive')
                                  .get()
                                  .then((QuerySnapshot value) async {
                                value.docs.forEach((element) async {
                                  print("doc snap: ${element.id}");
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(element.id)
                                      .collection('connections')
                                      .doc(widget.teamModel.teamId)
                                      .update({
                                    'groupIcon': url,
                                  });
                                });
                              });

                              pickImageTrue = true;

                              Get.offAll(MainPage());
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

  showPhotoBottomSheet() {
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

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.teamName;
    _descriptionController.text = widget.teamDescription;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: [
          Container(
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('personal_connections')
                    .doc(widget.teamModel.teamId)
                    .update({
                  'teamName': _titleController.text,
                  'description': _descriptionController.text,
                });

                if (pickImageTrue) {
                  setState(() {
                    pickImageTrue = false;
                  });
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.of(context).pop();
                  });

                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.of(context).pop();
                  });

                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.of(context).pop();
                  });
                }

                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 40,
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              child: Stack(
                children: [
                  Container(
                    color: Colors.black54,
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            // .collection('users/${getxController.authData.value}/mescsages')
                            .collection('personal_connections')
                            .doc('${widget.teamModel.teamId}')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data['groupIcon'] != '') {
                              return Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(
                                  snapshot.data['groupIcon'],
                                  fit: BoxFit.fitWidth,
                                ),
                              );
                            }
                            return Container(
                              height: 150,
                              child: Center(
                                child: Text('No group icon'),
                              ),
                            );
                          }
                          return Container();
                        }),
                  ),
                  Container(
                    height: 150,
                    //alignment: AlignmentGeometry.lerp(2, 3, 6),

                    padding: EdgeInsets.only(top: 110, left: 20),
                    child: GestureDetector(
                      child: Text(
                        'change the group icon',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        showPhotoBottomSheet();
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 70,
              color: Color.fromRGBO(255, 0, 0, 0.4),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    child: ClipOval(
                      child: Icon(Icons.camera),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(),
                      onChanged: (value) => {
                        widget.teamName = value,
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
              color: Color.fromRGBO(255, 0, 0, 0.5),
            ),
            Container(
              height: 50,
              color: Color.fromRGBO(0, 75, 255, 0.4),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
              child: TextField(
                controller: _descriptionController,
                onChanged: (value) => {
                  widget.teamDescription = value,
                },
                textAlign: TextAlign.justify,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: _descriptionController.text.isEmpty
                      ? 'Description(Not Mandatory Like VIT)'
                      : '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
