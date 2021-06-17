import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:milanproject/ui/voice/music.dart';
import 'package:milanproject/ui/voice/saavn.dart';

import 'appColors.dart';

class Musify extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<Musify> {
  TextEditingController searchBar = TextEditingController();
  bool fetchingSongs = false;
  //final path= Directory("storage/emulated/0/PushtiRas");
  String path;




  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff1c252a),
      statusBarColor: Colors.white,
    ));

    search();
  }


  search() async {
//    String searchQuery = searchBar.text;
    //  if (searchQuery.isEmpty) return;
    fetchingSongs = true;
    await fetchSongsList("3");
    fetchingSongs = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white, Colors.white],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.amber, elevation: 0, title: Text('Audios')),
        // resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        //backgroundColor: Color(0xff384850),
        bottomNavigationBar: Container(
          height: 75,
          //color: Color(0xff1c252a),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18), topRight: Radius.circular(18)),
              color: Color(0xff1c252a)),
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 2),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AudioApp()),
                );
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: IconButton(
                      icon: Icon(
                        MdiIcons.appleKeyboardControl,
                        size: 22,
                      ),
                      onPressed: null,
                      disabledColor: accent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0.0, top: 7, bottom: 7, right: 15),
                    //child: Image.network("https://sgdccdnems06.cdnsrv.jio.com/c.saavncdn.com/830/Music-To-Be-Murdered-By-English-2020-20200117040807-500x500.jpg"),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(
                            color: accent,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          artist,
                          style: TextStyle(color: accentLight, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: playerState == PlayerState.playing
                        ? Icon(MdiIcons.pause)
                        : Icon(MdiIcons.playOutline),
                    color: accent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        if (playerState == PlayerState.playing) {
                          audioPlayer.pause();
                          playerState = PlayerState.paused;
                        } else if (playerState == PlayerState.paused) {
                          audioPlayer.play(kUrl);
                          playerState = PlayerState.playing;
                        }
                      });
                    },
                    iconSize: 45,
                  )
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10, bottom: 0.0)),
              TextField(
                onSubmitted: (String value) {
                  search();
                },
                controller: searchBar,
                style: TextStyle(
                  fontSize: 16,
                  color: accent,
                ),
                cursorColor: Colors.green[50],
                decoration: InputDecoration(
                  fillColor: Color(0xff263238),
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xff263238),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    borderSide: BorderSide(color: accent),
                  ),
                  suffixIcon: IconButton(
                    icon: fetchingSongs
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(accent)),
                            ),
                          )
                        : Icon(
                            Icons.search,
                            color: accent,
                          ),
                    color: accent,
                    onPressed: () {
                      search();
                    },
                  ),
                  border: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: TextStyle(
                    color: accent,
                  ),
                  contentPadding: const EdgeInsets.only(
                    left: 18,
                    right: 20,
                    top: 14,
                    bottom: 14,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: searchedList.length,
                itemBuilder: (ctxt, index) {
                 // print('audio --- > ${searchedList[index]['audio']}');
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Card(
                      color: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            getSongDetails(index);
                            print('Song Id : $index');
                          });
                        },
                        onLongPress: () {
                          //  topSongs();
                        },
                        splashColor: accent,
                        hoverColor: accent,
                        focusColor: accent,
                        highlightColor: accent,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  MdiIcons.musicNoteOutline,
                                  size: 30,
                                  color: accent,
                                ),
                              ),
                              title: Text(
                                (searchedList[index]['title'])
                                    .toString()
                                    .split("(")[0]
                                    .replaceAll("&quot;", "\"")
                                    .replaceAll("&amp;", "&"),
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                searchedList[index]['title'],
                                style: TextStyle(color: Colors.black),
                              ),
                              trailing: IconButton(
                                  color: accent,
                                  icon: Icon(MdiIcons.downloadOutline),
                                  onPressed: () async {
                                    // final directory = await getApplicationDocumentsDirectory();
                                    // print('$directory');

                               String  path  = await ExtStorage.getExternalStoragePublicDirectory(
                                  ExtStorage.DIRECTORY_DOWNLOADS);

                              await FlutterDownloader.enqueue(
                              url: searchedList[index]['audio'],
                                savedDir: directory.path,
                                showNotification: true, // show download progress in status bar (for Android)
                                openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                              );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getTopSong(String image, String title, String subtitle, String id) {
    return InkWell(
      onTap: () => getSongDetails(int.parse(id)),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.17,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(image),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            title
                .split("(")[0]
                .replaceAll("&amp;", "&")
                .replaceAll("&#039;", "'")
                .replaceAll("&quot;", "\""),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
