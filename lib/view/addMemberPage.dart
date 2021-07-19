import 'package:flutter/material.dart';

class AddMemberPage extends StatefulWidget {
  //const AddMemberPage({ Key? key }) : super(key: key);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member'),
      ),
    );
  }
}
