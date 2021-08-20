import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:secretchat/model/poll_model.dart';

class PollController extends GetxController {
  var pollOptions = [].obs;
  var pollQuestion = "".obs;
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
      {required String teamId,
      required String sentBy,
      required String messageText,
      required String type,
      required bool isDeleted}) async {
    print('''
    CHeck data: 
    teamId: $teamId,
    sentBy: $sentBy,
    questionText: $pollQuestion,
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
        'question': pollQuestion.value,
        'isDeleted': false
        //'isImage': false,
      },
    ).then((value) {
      pollOptions.forEach((element) {
        print('ohmygodmygod');
        // if (element({'pollText' == null})) {
        //   print('yeah');
        // }
        print(element.pollText);
        if (element.pollText != null) {
          FirebaseFirestore.instance
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
    required String teamId,
    required String userPollingId,
    required String userNameofPoller,
    required String pollOptionId,
    required String messageId,
  }) async {
    //check if user has already polled
    FirebaseFirestore.instance
        .collection('personal_connections')
        .doc('$teamId')
        .collection('messages')
        .doc(messageId)
        .collection('usersPolled')
        .where('userId', isEqualTo: userPollingId)
        .get()
        .then((value) {
      print("check length${value.docs.length}");
      //if length is zero then the user has not polled yet then let him proceed otherwise don't
      if (value.docs.length == 0) {
        //add the user to polled list
        FirebaseFirestore.instance
            // .collection(
            //     'personal_connections')  //${getxController.authData}/messages')
            .collection('personal_connections')
            .doc('$teamId')
            .collection('messages')
            .doc(messageId)
            .collection('usersPolled')
            .doc(userPollingId)
            .set({"userId": userPollingId});
        // //poll in the specific option
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
      } else {
        print("Kitna poll karega");
      }
    });
  }

  Stream<QuerySnapshot> usersWhoPolled(
      {required String teamId, required String messageId}) {
    return FirebaseFirestore.instance
        .collection('personal_connections')
        .doc('$teamId')
        .collection('messages')
        .doc(messageId)
        .collection('usersPolled')
        .snapshots();
  }

  Stream<QuerySnapshot> usersWhoPolledOnSpecificOption(
      {required String teamId,
      required String messageId,
      required String pollId}) {
    return FirebaseFirestore.instance
        .collection('personal_connections')
        .doc('$teamId')
        .collection('messages')
        .doc(messageId)
        .collection('pollOptions')
        .doc(pollId)
        .collection('userPolled')
        .snapshots();
  }

  void revertPollOptions(
      {required String teamId,
      required String messageId,
      required String pollId,
      required String userId}) {
    //remove that user from that specific option
    FirebaseFirestore.instance
        .collection('personal_connections')
        .doc('$teamId')
        .collection('messages')
        .doc(messageId)
        .collection('pollOptions')
        .doc(pollId)
        .collection('usersPolled')
        .doc(userId)
        .delete();

    //remove from the complete list of userPolled
    FirebaseFirestore.instance
        .collection('personal_connections')
        .doc('$teamId')
        .collection('messages')
        .doc(messageId)
        .collection('usersPolled')
        .doc(userId)
        .delete();
  }
}
