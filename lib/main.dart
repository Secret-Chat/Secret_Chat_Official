import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/view/authPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secretchat/view/mainPage.dart';
import 'controller/auth_controller.dart';
import 'model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final getxController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User> userSnapshot) {
          if (userSnapshot.hasData) {
            //return ChatPage();

            getxController.user.value = UserModel(
                userEmail: userSnapshot.data.email,
                userId: userSnapshot.data.uid);
            getxController.authData.value = userSnapshot.data.uid;
            print("Check: ${getxController.authData.value}");
            return MainPage();
          }
          return AuthPage();
        },
      ),
    );
  }
}
