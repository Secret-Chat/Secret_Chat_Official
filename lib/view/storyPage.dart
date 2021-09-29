import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secretchat/controller/auth_controller.dart';
import 'package:secretchat/view/story%20status/camera_main.dart';

class StoryPage extends StatefulWidget {
  //const StoryPage({ Key? key }) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final getxController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              leading: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: Color.fromRGBO(175, 103, 235, 0.3),
                ),
                child: Center(
                  child: Text(
                    '${getxController.user.value.userName.toString().substring(0, 1).capitalize}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              title: Text('My Story'),
              subtitle: Text('Tap to add a story'),
              onTap: () {
                Get.to(() => CameraMain());
              },
            ),
          ),
        ],
      ),
    );
  }
}
