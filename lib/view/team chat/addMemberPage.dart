import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/model/user_in_group.dart';

class AddMemberPage extends StatefulWidget {
  //const AddMemberPage({ Key? key }) : super(key: key);
  //get the group members list
  final TeamModel teamModel;

  const AddMemberPage({Key key, @required this.teamModel}) : super(key: key);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  List<UserEntity> usersAlreadyInGroupList = [];
  List<UserEntity> contactsToAdd = [
    // UserEntity(name: "Sasta Nashedi", userId: "69")
  ];

  //[get] the contacts list in the init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContactsList();
  }

  onTap(String id, String username) {
    // print(id);
    // print(username);

    // contactsToAdd.add((UserEntity(name: username, userId: id)));

    var contain = contactsToAdd.where((element) => element.userId == "$id");
    if (contain.isEmpty) {
      //new contact then add in the list
      setState(() {
        contactsToAdd.add(UserEntity(userId: id, name: username));
      });
    } else {
      //TODO: future implementation
      // print("bhakk purana contact hai ");
    }
  }

  bool ifContactIsAlreadyThereInGroup(
      {List<UserEntity> groupContactIds, String userIdFromFirebaseToCheck}) {
    var contain = usersAlreadyInGroupList
        .where((element) => element.userId == "$userIdFromFirebaseToCheck");
    if (contain.isEmpty) {
      //new contact then add in the list
      return false;
    } else {
      return true;
    }
  }

  void getContactsList() {
    print("getContactsList called");
    FirebaseFirestore.instance
        .collection('personal_connections')
        .doc('${widget.teamModel.teamId}')
        .collection('users')
        .get()
        .then((QuerySnapshot value) {
      value.docs.forEach((element) {
        print("doc snap: ${element.id}");
        usersAlreadyInGroupList
            .add(UserEntity(userId: element.id, name: element['username']));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Members'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 200,
        child: Column(
          children: [
            Wrap(children: [
              for (int i = 0; i < contactsToAdd.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Chip(
                      deleteIcon: Icon(
                        Icons.close,
                        color: Colors.purple,
                      ),
                      onDeleted: () {
                        //delete that frickin contact
                        setState(
                          () {
                            contactsToAdd.removeWhere((element) =>
                                element.userId == contactsToAdd[i].userId);
                          },
                        );
                      },
                      label: Text('${contactsToAdd[i].name}')),
                ),
            ]),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
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
                    return new ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        //TODO checking logic to scale

                        return new ListTile(
                            tileColor:
                                //Color.fromRGBO(255, 0, 0, 0.4) :
                                ifContactIsAlreadyThereInGroup(
                                        groupContactIds:
                                            usersAlreadyInGroupList,
                                        userIdFromFirebaseToCheck:
                                            snapshot.data.docs[index]['userId'])
                                    ? Colors.green
                                    : Colors.white,
                            title:
                                new Text(snapshot.data.docs[index]['username']),
                            subtitle:
                                new Text(snapshot.data.docs[index]['email']),
                            onTap: !ifContactIsAlreadyThereInGroup(
                                    groupContactIds: usersAlreadyInGroupList,
                                    userIdFromFirebaseToCheck:
                                        snapshot.data.docs[index]['userId'])
                                ? () async {
                                    onTap(snapshot.data.docs[index]['userId'],
                                        snapshot.data.docs[index]['username']);
                                  }
                                : null);
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        disabledElevation: 2,
        backgroundColor: contactsToAdd.isNotEmpty ? Colors.amber : Colors.grey,
        child: Icon(Icons.next_plan_rounded),
        onPressed: contactsToAdd.isNotEmpty
            ? () async {
                //go to next page and make a new team connection in firebase
                print('FAB Tapped');
                // Get.to(TeamName(contactsToAdd));
                contactsToAdd.forEach((element) {
                  print(element.toString());
                });
                //add these users in the personal connections group
                contactsToAdd.forEach((element) {
                  FirebaseFirestore.instance
                      .collection('personal_connections')
                      .doc(widget.teamModel.teamId)
                      .collection('users')
                      .doc(element.userId)
                      .set({'username': element.name, 'role': 'member'});
                });
                //add this connection for all the users in the connection collection for the individual users
                contactsToAdd.forEach((element) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(element.userId)
                      .collection('connections')
                      .doc(widget.teamModel.teamId)
                      .set({
                    'type': "team",
                    'teamName': widget.teamModel.teamName,
                    'teamId': widget.teamModel.teamId
                  });
                });
              }
            : null,
      ),
    );
  }
}
