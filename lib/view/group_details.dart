import 'package:flutter/material.dart';

class GroupDetailsPage extends StatefulWidget {
  final String groupID;

  const GroupDetailsPage({Key key, this.groupID}) : super(key: key);

  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          
        ),
      ),
    );
  }
}
