import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';

class AboutPage extends StatefulWidget {
  //const PhoneNumber({ Key? key }) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _aboutController = TextEditingController();
  final getxController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    if (getxController.user.value.about != '') {
      _aboutController.text = getxController.user.value.about;
    }
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
                  'About',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Center(
                child: Text(
                  'A few words about yourself which would be visible to everyone',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //Container(
            // child: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            //     Container(
            //       height: 50,
            //       padding: EdgeInsets.all(15),
            //       decoration: BoxDecoration(
            //         color: Colors.blue[900],
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(10),
            //         ),
            //       ),
            //       child: Text('+91'),
            //     ),

            Container(
              width: MediaQuery.of(context).size.width * 1,
              //height: 50,
              padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: _aboutController,
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                maxLength: 50,
                style: TextStyle(color: Colors.blue),
                decoration: InputDecoration(
                    //counter: Offstage(),
                    hintText: 'I am a barbie girl',
                    border: InputBorder.none),
                onChanged: (value) => {
                  getxController.user.value.about = value,
                },
              ),
            ),
            //],
            //),
            //),
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
                    getxController.user.value.about == ''
                        ? 'Add About Me'
                        : 'Update About Me',
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
                  'about': '${_aboutController.text}',
                });

                //   ).then((value) {
                //     getxController.user.value = UserModel(
                //   userEmail: value['email'],
                //   userId: value['userId'],
                //   userName: value['username'],
                // );
                //   })

                getxController.user.value.about = '${_aboutController.text}';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Container(
                      child: Text('Your about me has been registered'),
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
