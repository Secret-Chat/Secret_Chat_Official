import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secretchat/model/poll_model.dart';

class PollController extends GetxController {
  var pollOptions = [].obs;
  Rx<int> pollIndexCounter = 1.obs;

  void printAllOptions() {
    pollOptions.forEach((element) {
      print(element.toString());
    });
  }

  bool get isThePoleEmpty {
    print("isThePoleEmpty called ${pollOptions.isEmpty}");
    return pollOptions.isEmpty;
  }

  int get numOfOptions {
    return pollOptions.length;
  }

  void clearAllOptions() {
    pollOptions.clear();
  }

  Future<void> sendAllOptionsToFirebase(
      {String teamId,
      String sentBy,
      String questionText,
      String messageText,
      String type,
      bool isDeleted}) async {
    print('''
    CHeck data: 
    teamId: $teamId,
    sentBy: $sentBy,
    questionText: $questionText,
    messageText: $messageText''');
    FirebaseFirestore.instance
        // .collection(
        //     'personal_connections')  //${getxController.authData}/messages')
        .collection('personal_connections')
        .doc('$teamId')
        .collection('messages')
        .add(
      {
        'message': messageText,
        'sentBy': sentBy,
        'createdOn': FieldValue.serverTimestamp(),
        'type': 'pollMessage',
        'question': questionText,
      },
    ).then((value) {
      pollOptions.forEach((element) {
        print('ohmygodmygod');
        // if (element({'pollText' == null})) {
        //   print('yeah');
        // }
        print(element.pollText);
        if (element.pollText != null) {
          return FirebaseFirestore.instance
              // .collection(
              //     'personal_connections')  //${getxController.authData}/messages')
              .collection('personal_connections')
              .doc('$teamId')
              .collection('messages')
              .doc(value.id)
              .collection('pollOptions')
              .add(element.toMap());
        }
      });
    });
  }

  Future<void> sendPollAnswer({
    String teamId,
    String userPollingId,
    String userNameofPoller,
    String pollOptionId,
    String messageId,
  }) async {
    FirebaseFirestore.instance
        // .collection(
        //     'personal_connections')  //${getxController.authData}/messages')
        .collection('personal_connections')
        .doc('$teamId')
        .collection('messages')
        .doc(messageId)
        .collection('pollOptions')
        .doc(pollOptionId)
        .collection('usersPolled')
        .doc(userPollingId)
        .set({'username': userNameofPoller, 'userId': userPollingId});
  }
}
