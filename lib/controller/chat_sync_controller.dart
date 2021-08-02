import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secretchat/helper/sqlStorage.dart';

class ChatSyncController extends GetxController {
  //

  void syncFromServerPersonalConnectionList(
      List<QueryDocumentSnapshot> data, String connectionId) async {
    //TODO: CRUD OPS SQLITE
    await SqlStore.database(connectionId);
    print("syncFromServerPersonalConnectionList called");
    print('Connection Id $connectionId');
    data.reversed.forEach(
      (value) {
        print(value['message']);
        SqlStore.insert(connectionId, {
          "messageId": value.id,
          "messageText": value['message'],
        });
      },
    );
  }

  void checkIfDBWorked(String connectionId) async {
    print("checkIfDBWorked called");
    List<Map<String, dynamic>> data = await SqlStore.getData(connectionId);
    data.forEach((element) {
      print(element);
    });
  }
}
