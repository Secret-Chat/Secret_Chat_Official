import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/model/user.dart';
//import 'package:flutter_otp/flutter_otp.dart';

class PhoneNumber extends StatefulWidget {
  //const PhoneNumber({ Key? key }) : super(key: key);

  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final _phoneNumberController = TextEditingController();
  final getxController = Get.put(AuthController());
  //FlutterOtp otp = FlutterOtp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.blue[200],
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.blue,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  'Enter a Phone Number',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Center(
                child: Text(
                  'You will recieve a text message with a verification code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text('+91'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 50,
                    padding: EdgeInsets.only(left: 30),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                          counter: Offstage(),
                          hintText: 'Phone Number',
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Add Phone Number',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              onTap: () async {
                // otp.generateOtp(1000, 9999);

                // otp.sendOtp(_phoneNumberController.text, 'Your otp is:  ', 1000,
                //     9999, '+91');
                //FirebaseFirestore.instance.collection('users', )

                // getxController.user.value = UserModel(
                //   phoneNumber: '+91 ${_phoneNumberController.text}',
                // );

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(getxController.user.value.userId)
                    .update({
                  'phoneNumber': '+91 ${_phoneNumberController.text}',
                });

                //   ).then((value) {
                //     getxController.user.value = UserModel(
                //   userEmail: value['email'],
                //   userId: value['userId'],
                //   userName: value['username'],
                // );
                //   })

                getxController.user.value.phoneNumber =
                    '+91 ${_phoneNumberController.text}';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Container(
                      child: Text('Your phone number has been added'),
                    ),
                  ),
                );

                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
