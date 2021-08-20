import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var emailFound = false.obs;
  Future<void> searchEmailId({String? email}) async {
    var result = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      print(value.docs.first['email']);
      emailFound.value = true;
    });

    var result2 = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (result2.isBlank!) {
      print("fuck");
    }
    print(result2.docs.first['email']);

    print(emailFound);
  }

  void connectWithUser() {}
}
