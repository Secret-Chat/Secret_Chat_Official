import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:secretchat/view/webViewPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NoteChatPersonalWidget extends StatelessWidget {
  final text;

  NoteChatPersonalWidget(this.text);

  // showYouBottomSheet(String linkurl) {
  //   return Get.bottomSheet(
  //     SingleChildScrollView(
  //       child: Container(
  //         height: 300,
  //         color: Colors.white,
  //         width: MediaQuery.of(context).size.width,
  //         child: Column(
  //           children: [
  //             Container(
  //               height: 50,
  //               color: Color.fromRGBO(20, 20, 20, 1),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: <Widget>[
  //                   GestureDetector(
  //                     child: Container(
  //                       padding: EdgeInsets.all(5),
  //                       child: Icon(
  //                         Icons.close,
  //                         color: Colors.blue,
  //                       ),
  //                     ),
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                   ),
  //                   GestureDetector(
  //                     child: Container(
  //                       padding: EdgeInsets.all(5),
  //                       child: Text(
  //                         'Open YouTube',
  //                         style: TextStyle(color: Colors.blue),
  //                       ),
  //                     ),
  //                     onTap: () async {
  //                       await launch(linkurl);
  //                     },
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               height: 250,
  //               child: YoutubePlayer(
  //                 controller: YoutubePlayerController(
  //                   initialVideoId: '$videoId',
  //                   flags: YoutubePlayerFlags(
  //                     mute: false,
  //                     autoPlay: true,
  //                     isLive: false,
  //                   ),
  //                 ),
  //                 showVideoProgressIndicator: true,
  //                 progressIndicatorColor: Colors.white54,
  //                 //videoProgressIndicatorColor: Colors.amber,
  //                 progressColors: ProgressBarColors(
  //                   playedColor: Colors.white,
  //                   handleColor: Colors.white54,
  //                 ),
  //                 onReady: () {
  //                   _controller.addListener(() {});
  //                 },
  //                 // onReady: () {
  //                 //   _controller.addListener();
  //                 // },
  //                 // onReady () {
  //                 //     _controller.addListener(listener);
  //                 // },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.only(right: 10, left: 10, top: 2, bottom: 2),
        //color: Color.fromRGBO(10, 10, 255, 0.3),
        alignment: Alignment.bottomRight,
        child: Container(
          padding: EdgeInsets.only(right: 11, bottom: 7, left: 12, top: 9),
          decoration: BoxDecoration(
            color: Color.fromRGBO(200, 30, 50, 0.3),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          //width: 20,
          constraints: BoxConstraints(
            minWidth: 10,
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Linkify(
                onOpen: (link) async {
                  print("Linkify link = ${link.url}");
                  var linkurl = "https://${link.url}";
                  print(link.url);
                  // if (await canLaunch(link.text)) {
                  // await launch(
                  //     "https://www.google.com/");
                  if (link.url.contains("youtu")) {
                    // setState(() {
                    //   videoId = YoutubePlayer
                    //       .convertUrlToId(
                    //           "${link.url}");
                    //   print(videoId);
                    // });

                    // return showYouBottomSheet(
                    //     link.url);
                    // return YoutubeBottomSheet()
                    //   ..showYouBottomSheet(
                    //       videoId,
                    //       link.url,
                    //       context,
                    //       _controller);
                  }
                  Get.to(WebViewPage(link.url));

                  // } else {
                  //   print(link.text);
                  //   print('no problem');
                  // }
                },
                text: "$text",
                style: TextStyle(color: Colors.black45),
                linkStyle: TextStyle(color: Colors.blue),
                options: LinkifyOptions(humanize: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
