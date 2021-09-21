import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/view/authPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretchat/view/mainPage.dart';
import 'controller/auth_controller.dart';
import 'model/user.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final getxController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        highlightColor: Color.fromRGBO(100, 100, 100, 0.4),
      ),
      home: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User> userSnapshot) {
          if (userSnapshot.hasData) {
            //return ChatPage();
            // getxController.user.value = UserModel(
            //     userEmail: userSnapshot.data.email,
            //     userId: userSnapshot.data.uid);
            getxController.authData.value = userSnapshot.data.uid;
            FirebaseFirestore.instance
                .collection("users")
                .doc(userSnapshot.data.uid)
                .get()
                .then((value) {
              getxController.user.value = UserModel(
                userEmail: value['email'],
                userId: value['userId'],
                userName: value['username'],
                name: value['name'],
                about: value['about'],
                phoneNumber: value['phoneNumber'],
              );
            });
            print("Check: ${getxController.authData.value}");
            return MainPage();
          }
          return AuthPage();
        },
      ),
      navigatorKey: navigatorKey,
    );
  }
}
