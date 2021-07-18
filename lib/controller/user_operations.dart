import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';

class UserOperations extends GetxController {
  // Rx<bool> userExists = false.obs;

  Future<void> addContact(
      DocumentSnapshot document, AuthController getxController) async {
    // print(document);
    print("addContact function called");
    final docId = await FirebaseFirestore.instance
        .collection("personal_connections")
        .add({
      "type": 'personal',
      "userOne": {
        "email": getxController.user.value.userEmail,
        "userId": getxController.user.value.userId
      },
      "userTwo": {
        "email": document.data()['email'],
        "userName": document.data()['username'],
        "userId": document.data()['userId']
      }
    });
    print("Doc iD ${docId.id}");
    print("taped");

    // add for the self user
    FirebaseFirestore.instance
        .collection("users")
        .doc(getxController.authData.value)
        .collection("connections")
        .doc(docId.id)
        .set({
      "email": document.data()['email'],
      "userId": document.data()['userId'],
      "userName": document.data()['username'],
      // "connectionID": docId.id
    });

    // add for the other user
    FirebaseFirestore.instance
        .collection("users")
        .doc(document.data()['userId'])
        .collection("connections")
        .doc(docId.id)
        .set({
      "email": getxController.user.value.userEmail,
      "userId": getxController.user.value.userId,
      "userName": getxController.user.value.userName
      // "connectionID": docId.id
    });
  }

  Future<bool> ifUserExist({
    DocumentSnapshot document,
    AuthController getxController,
  }) async {
    // bool userExists = false; //initially the user won't exist
    print("docid ${document.id}");
    print("emailof other : ${document.data()['email']}");
    print("userExists function called ${getxController.authData.value}");
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(getxController.authData.value)
        .collection("connections")
        .where('email', isEqualTo: document.data()['email'])
        .get();
    //doc length zero - so user doc not exist
    print("len ${result.docs.length}");
    // if len 0 - no connection
    //if len not 0 means connection
    return result.docs.length == 0 ? false : true;
  }
}


/*
userExists.value = true;
      value.docs.forEach((element) {
        print("sense hai :? ${element.id}");

*/