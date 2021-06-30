import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var authResultId = ''.obs;
  var authData = ''.obs;
  var userName = ''.obs;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void printer() {
    print(authData);
  }

  void reSignIn() async {
    var authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "rishabhmishra23599@gmail.com", password: "Mypher@99");
  }

  
}
