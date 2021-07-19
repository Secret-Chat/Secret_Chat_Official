import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secretchat/model/user_in_group.dart';
import 'package:secretchat/view/team%20chat/teamName.dart';

class MakeGroup extends StatefulWidget {
  //const MakeGroup({ Key? key }) : super(key: key);

  @override
  _MakeGroupState createState() => _MakeGroupState();
}

class _MakeGroupState extends State<MakeGroup> {
  List<UserEntity> contactsToAdd = [
    // UserEntity(name: "Sasta Nashedi", userId: "69")
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Group'),
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
                stream: FirebaseFirestore.instance
                    .collection('users')

                    //.where('email')
                    .snapshots(),
                // .collection('users/${getxController.authData.value}/mescsages')

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

                  return new ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return new ListTile(
                        tileColor:
                            //Color.fromRGBO(255, 0, 0, 0.4) :
                            Colors.white,
                        title: new Text(snapshot.data.docs[index]['username']),
                        subtitle: new Text(snapshot.data.docs[index]['email']),
                        onTap: () async {
                          onTap(snapshot.data.docs[index]['userId'],
                              snapshot.data.docs[index]['username']);
                        },
                      );
                    },
                  );
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
            ? () {
                //go to next page and make a new team connection in firebase
                print('FAB Tapped');
                Get.to(TeamName(contactsToAdd));
              }
            : null,
      ),
    );
  }
}
