import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secretchat/helper/sqlStorage.dart';

class ChatSyncController extends GetxController {
  //
  static const platform =
      MethodChannel('ourApp.manavAndrishabh.secretChat/networkCheck');
  var connectedToInternet = false.obs;

  void syncFromServerPersonalConnectionList(
      List<QueryDocumentSnapshot> data, String connectionId) async {
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

  void deleteTable(String connectionId) async {
    SqlStore.deleteTable(connectionId);
  }

  void checkInternetConnection() async {
    try {
      final bool result = await platform.invokeMethod('isNetworkAvailable');
      print('isConnectedToInternet $result');
      connectedToInternet.value = result;
    } on PlatformException catch (e) {
      print("Failed to call the channel ${e.message}");
    }
  }
}
