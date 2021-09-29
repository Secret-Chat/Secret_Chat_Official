import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/view/user%20views/aboutPage.dart';
import 'package:secretchat/view/user%20views/phoneNumber.dart';

class MyAccount extends StatefulWidget {
  //const MyAccount({ Key? key }) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final getxController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text('My Account'),
              ),
              Container(
                child: Text(
                  'User Settings',
                  style: TextStyle(
                    color: Color.fromRGBO(200, 200, 200, 0.8),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: ListTile(
                leading: SizedBox(
                  height: 60,
                  width: 60,
                  child: ClipOval(
                    child: Container(
                      color: Colors.blue[50],
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                ),
                title: Text(getxController.user.value.userName),
              ),
            ),
            Container(
              color: Colors.blue[100],
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  //SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ACCOUNT INFORMATION',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text('Username'),
                          ),
                          Container(
                            child: Text(getxController.user.value.userName,
                                style: TextStyle(color: Colors.black54)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text('Email'),
                          ),
                          Container(
                            child: Text(getxController.user.value.userEmail,
                                style: TextStyle(color: Colors.black54)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              'About',
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            child: Obx(
                              () => getxController.user.value.about != ''
                                  ? Text(
                                      getxController.user.value.about,
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  : Text(
                                      'Write a few words about yourself',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      print(getxController.user.value.phoneNumber);
                      Get.to(AboutPage());
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text('Phone Number'),
                          ),
                          Container(
                            child: Obx(
                              () => getxController.user.value.phoneNumber != ''
                                  ? Text(
                                      getxController.user.value.phoneNumber,
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  : Text(
                                      'Add a phone number',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      print(getxController.user.value.phoneNumber);
                      Get.to(PhoneNumber());
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
