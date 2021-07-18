import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretchat/model/group_model.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:get/get.dart';

class TeamName extends StatefulWidget {
  final List<UserEntity> teamList;

  TeamName(this.teamList);

  //const TeamName({ Key? key }) : super(key: key);

  @override
  _TeamNameState createState() => _TeamNameState();
}

class _TeamNameState extends State<TeamName> {
  final _teamNameController = TextEditingController();
  final getxController = Get.put(AuthController());
  bool isNameEmpty = true;

  groupNameExits() {
    _teamNameController.addListener(() {
      setState(() {
        if (_teamNameController.text.isEmpty) {
          isNameEmpty = true;
        } else {
          isNameEmpty = false;
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    groupNameExits();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.teamList.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('TeamDetails'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 40,
          child: Column(
            children: <Widget>[
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
                        controller: _teamNameController,
                        decoration:
                            InputDecoration(hintText: 'Enter group name'),
                      ),
                    ),
                    Container(
                      width: 50,
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 15,
                color: Color.fromRGBO(255, 0, 0, 0.5),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 175,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text('${widget.teamList.length} members'),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: ListView.builder(
                        itemCount: widget.teamList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: ClipOval(
                              child: Container(
                                height: 30,
                                width: 30,
                                child: Center(
                                  child: Text(
                                      '${widget.teamList[index].name.substring(0, 1)}'),
                                ),
                              ),
                            ),
                            title: Text(widget.teamList[index].name),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            _teamNameController.text.isNotEmpty ? Colors.amber : Colors.red,
        child: Icon(Icons.keyboard_arrow_right_outlined),
        onPressed: _teamNameController.text.isNotEmpty
            ? () async {
                //create the group in personal_connections
                final result = await FirebaseFirestore.instance
                    .collection('personal_connections')
                    .add({
                  'type': 'team',
                  'groupName': _teamNameController.text,
                  'createdBy': getxController.user.value.userId,
                  'createdOn': FieldValue.serverTimestamp(),
                });

                //add the users in the users collection in the group
                print(result.id);
                widget.teamList.forEach((element) {
                  FirebaseFirestore.instance
                      .collection('personal_connections')
                      .doc(result.id)
                      .collection('users')
                      .doc(element.userId)
                      .set({'username': element.name, 'role': 'member'});
                });

                //add the owner too in the user group
                FirebaseFirestore.instance
                    .collection('personal_connections')
                    .doc(result.id)
                    .collection('users')
                    .doc(getxController.user.value.userId)
                    .set({
                  'username': getxController.user.value.userName,
                  'role': 'owner'
                });

                //add this connection for all the users in the connection collection for the users
                widget.teamList.forEach((element) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(element.userId)
                      .collection('connections')
                      .doc(result.id)
                      .set({
                    'teamName': _teamNameController.text,
                    'teamId': result.id
                  });
                });

                //add the connection for the owner too
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(getxController.user.value.userId)
                    .collection('connections')
                    .doc(result.id)
                    .set({
                  'teamName': _teamNameController.text,
                  'teamId': result.id
                });
              }
            : null,
      ),
    );
  }
}
