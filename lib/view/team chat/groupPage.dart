import 'package:flutter/material.dart';
import 'package:secretchat/model/team_model.dart';
import 'package:secretchat/view/team%20chat/adminLounge.dart';
import 'package:secretchat/view/team%20chat/group_chat_page.dart';

class GroupPage extends StatelessWidget {
  final TeamModel teamModel;

  GroupPage({this.teamModel});
  final PageController controller = PageController(initialPage: 0);
  //const GroupPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      scrollDirection: Axis.horizontal,
      controller: controller,
      children: <Widget>[
        GroupChatScreen(
          teamModel: teamModel,
        ),
        AdminLounge(
          teamModel: teamModel,
        )
      ],
    );
  }
}
