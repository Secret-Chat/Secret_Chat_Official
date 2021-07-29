import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeBottomSheet {
  // final String videoId;
  // final String linkurl;

  //  YoutubeBottomSheet(this.videoId, this.linkurl);
//   //const YoutubeBottomSheet({ Key? key }) : super(key: key);

//   @override
//   _YoutubeBottomSheetState createState() => _YoutubeBottomSheetState();
// }

// class _YoutubeBottomSheetState extends State<YoutubeBottomSheet> {
  // @override
  // Widget build(BuildContext context) {
  showYouBottomSheet(String videoId, String linkurl, BuildContext context,
      YoutubePlayerController controller) {
    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          height: 300,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 50,
                color: Color.fromRGBO(20, 20, 20, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.close,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'Open YouTube',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      onTap: () async {
                        await launch(linkurl);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 250,
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: 'videoId',
                    flags: YoutubePlayerFlags(
                      mute: false,
                      autoPlay: true,
                      isLive: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.white54,
                  //videoProgressIndicatorColor: Colors.amber,
                  progressColors: ProgressBarColors(
                    playedColor: Colors.white,
                    handleColor: Colors.white54,
                  ),
                  onReady: () {
                    controller.addListener(() {});
                  },
                  // onReady: () {
                  //   _controller.addListener();
                  // },
                  // onReady () {
                  //     _controller.addListener(listener);
                  // },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
