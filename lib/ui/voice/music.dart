import 'dart:async';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:milanproject/style/appColors.dart';
import 'package:milanproject/ui/voice/saavn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:ext_storage/ext_storage.dart';

String status = 'hidden';
AudioPlayer audioPlayer;
PlayerState playerState;

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class AudioApp extends StatefulWidget {
  @override
  AudioAppState createState() => AudioAppState();
}

@override
class AudioAppState extends State<AudioApp> {
  Duration duration;
  Duration position;

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;
  bool loading = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    super.dispose();
  }

  void initAudioPlayer() {
    if (audioPlayer == null) {
      audioPlayer = AudioPlayer();
    }
    setState(() {
      if (checker == "Haa") {
        stop();
        play();
      }
      if (checker == "Nahi") {
        if (playerState == PlayerState.playing) {
          play();
        } else {
          // Using (Hack) Play() here Else UI glitch is being caused, Will try to find better solution.
          play();
          pause();
        }
      }
    });

    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => {if (mounted) setState(() => position = p)});

    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        {
          if (mounted) setState(() => duration = audioPlayer.duration);
        }
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        if (mounted)
          setState(() {
            position = duration;
          });
      }
    }, onError: (msg) {
      if (mounted)
        setState(() {
          playerState = PlayerState.stopped;
          duration = Duration(seconds: 0);
          position = Duration(seconds: 0);
        });
    });
  }

  Future play() async {
    await audioPlayer.play(kUrl);
    //MediaNotification.showNotification(title: title, author: artist, artUri: image, isPlaying: true);
    if (mounted)
      setState(() {
        playerState = PlayerState.playing;
      });
  }

  Future pause() async {
    await audioPlayer.pause();
    //   MediaNotification.showNotification(title: title, author: artist, artUri: image, isPlaying: false);
    setState(() {
      playerState = PlayerState.paused;
    });
  }

  Future stop() async {
    await audioPlayer.stop();
    if (mounted)
      setState(() {
        playerState = PlayerState.stopped;
        position = Duration();
      });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    if (mounted)
      setState(() {
        isMuted = muted;
      });
  }

  void onComplete() {
    if (mounted) setState(() => playerState = PlayerState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff384850),
            Color(0xff263238),
            Color(0xff263238),
            //Color(0xff61e88a),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.amber,
          elevation: 0,
          //backgroundColor: Color(0xff384850),
          centerTitle: true,
          title: GradientText(
            "Now Playing",
            shaderRect: Rect.fromLTWH(13.0, 0.0, 100.0, 50.0),
            gradient: LinearGradient(colors: [
              Color(0xff4db6ac),
              Color(0xff61e88a),
            ]),
            style: TextStyle(
              color: accent,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 32,
                color: accent,
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 35.0, bottom: 35),
                        child: Column(
                          children: <Widget>[
                            GradientText(
                              title,
                              shaderRect: Rect.fromLTWH(13.0, 0.0, 100.0, 50.0),
                              gradient: LinearGradient(colors: [
                                Color(0xff4db6ac),
                                Color(0xff61e88a),
                              ]),
                              textScaleFactor: 2.5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                artist,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: accentLight,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: _buildPlayer(),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: loading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white.withOpacity(0.4),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.amber),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer() => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (duration != null)
              // Slider(
              //     activeColor: accent,
              //     inactiveColor: Colors.green[50],
              //     value: position?.inMilliseconds?.toDouble() ?? 0.0,
              //     onChanged: (double value) {
              //       audioPlayer.seek((value / 1000).roundToDouble());
              //     },
              //     min: 0.0,
              //     max: duration.inMilliseconds.toDouble()),
              SizedBox(height: 10),
            if (position != null) _buildProgressView(),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AudioPlayerButton(
                    icon: MdiIcons.repeat,
                    onPressed: () {
                      stop();
                      play();
                    }),
                AudioPlayerButton(
                  icon: MdiIcons.skipPrevious,
                  onPressed: () {
                    if (currentIndex != 0) {
                      stop();
                      setState(() {
                        getSongDetails(currentIndex - 1);
                      });
                      play();
                    }
                  },
                ),
                AudioPlayerButton(
                  iconSize: 45,
                  icon: isPlaying ? MdiIcons.pause : MdiIcons.play,
                  onPressed: isPlaying ? pause : play,
                ),
                AudioPlayerButton(
                  icon: MdiIcons.skipNext,
                  onPressed: () {
                    if (searchedList.length != currentIndex + 1) {
                      stop();
                      setState(() {
                        getSongDetails(currentIndex + 1);
                      });
                      play();
                    }
                  },
                ),
                AudioPlayerButton(
                    icon: MdiIcons.download, onPressed: downloadAudio),
              ],
            ),
          ],
        ),
      );

  Future downloadAudio() async {
    if (await Permission.storage.request().isGranted) {
      String path = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      print(path);

      try {
        setState(() => loading = true);

        Response response = await Dio().get(
          kUrl,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }),
        );
        print(response.headers);
        File file = File(path);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        Toast.show('Donwload Success', context);
        await raf.close();
        setState(() => loading = false);
      } catch (e) {
        setState(() => loading = false);
        Toast.show('Donwload Failed', context);
        print(e);
      }
    } else {
      await Permission.storage.request();
    }
  }

  Widget _buildProgressView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            position != null
                ? "${positionText ?? ''} ".replaceFirst("0:0", "0")
                : duration != null
                    ? durationText
                    : '',
            style: TextStyle(fontSize: 18.0, color: Colors.green[50]),
          ),
          Spacer(),
          Text(
            position != null
                ? "${durationText ?? ''}".replaceAll("0:", "")
                : duration != null
                    ? durationText
                    : '',
            style: TextStyle(fontSize: 18.0, color: Colors.green[50]),
          )
        ],
      ),
    );
  }
}

class AudioPlayerButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Function onPressed;

  AudioPlayerButton({this.icon, this.iconSize = 25, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xff4db6ac), Color(0xff61e88a)],
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        iconSize: iconSize,
        icon: Icon(icon),
        color: Color(0xff263238),
      ),
    );
  }
}
