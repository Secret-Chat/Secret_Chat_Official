import 'package:flutter/material.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:secretchat/view/user%20views/myAccount.dart';

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
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  color: Colors.blue[200],
                  child: Center(
                    child: Text(
                      'My Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: () {
                  Get.to(MyAccount());
                },
              )
            ],
          ),
        ));
  }
}
