import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatSyncController extends GetxController {
  //

  void syncFromServerPersonalConnectionList(
      {List<QueryDocumentSnapshot> data}) {

        //TODO: CRUD OPS SQLITE
    print("sync server called");
    data.forEach((value) {
      print('val ${value["email"]}');
    });
  }
}
