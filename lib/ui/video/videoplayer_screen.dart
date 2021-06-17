import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  VideoPlayerScreen({@required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  TargetPlatform platform;
  YoutubePlayerController youtubePlayerController;
  int selectedIndex;
  bool isPlaying = false, isEndPlaying = false;
  List<Color> listItemColor = [];

  @override
  void initState() {
    super.initState();
    //  String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: widget.videoUrl,
      flags: YoutubePlayerFlags(autoPlay: true, mute: true),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    print('Youtube Link:- ${widget.videoUrl}');
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: youtubePlayerController,
      showVideoProgressIndicator: true,
      onReady: () {
        youtubePlayerController.play();
      },
      progressColors: ProgressBarColors(
        playedColor: Colors.amber,
        backgroundColor: Colors.white30,
        bufferedColor: Colors.white,
        handleColor: Colors.amber,
      ),
      progressIndicatorColor: Colors.amber,
      bufferIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.amber)),
      onEnded: (data) {
        print(data);
      },
    );
  }
}
