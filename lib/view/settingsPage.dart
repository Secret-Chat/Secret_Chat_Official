import 'package:flutter/material.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  //const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final getxController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getxController.user.value.userEmail),
      ),
    );
  }
}
