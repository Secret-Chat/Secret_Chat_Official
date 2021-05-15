import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var emailFound = false.obs;
  Future<void> searchEmailId({String email}) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        print(value.docs.first['email']);
        emailFound.value = true;
      });
    } catch (err) {
      print(err);
    }
    print(emailFound);
  }
}
