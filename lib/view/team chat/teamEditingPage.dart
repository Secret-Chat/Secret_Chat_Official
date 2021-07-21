import 'package:flutter/material.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/view/team%20chat/teamName.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamEditingPage extends StatefulWidget {
  final TeamModel teamModel;
  final teamName;
  final teamDescription;

  TeamEditingPage({this.teamModel, this.teamName, this.teamDescription});
  //const TeamEditingPage({ Key? key }) : super(key: key);

  @override
  _TeamEditingPageState createState() => _TeamEditingPageState();
}

class _TeamEditingPageState extends State<TeamEditingPage> {
  var _titleController = TextEditingController();
  var _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.teamName;
    _descriptionController.text = widget.teamDescription;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        actions: [
          Container(
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('personal_connections')
                    .doc(widget.teamModel.teamId)
                    .update({
                  'teamName': _titleController.text,
                  'description': _descriptionController.text,
                });

                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 40,
        child: Column(
          children: <Widget>[
            Container(
              height: 70,
              color: Color.fromRGBO(255, 0, 0, 0.4),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50,
                    child: ClipOval(
                      child: Icon(Icons.camera),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
              color: Color.fromRGBO(255, 0, 0, 0.5),
            ),
            Container(
              height: 50,
              color: Color.fromRGBO(0, 75, 255, 0.4),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
              child: TextField(
                controller: _descriptionController,
                textAlign: TextAlign.justify,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: _descriptionController.text.isEmpty
                      ? 'Description(Not Mandatory Like VIT)'
                      : '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
