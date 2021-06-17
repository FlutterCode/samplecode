import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:milanproject/agora/firebaseDB/api_helper.dart';
import 'package:milanproject/agora/firebaseDB/auth.dart';
import 'package:milanproject/agora/models/global.dart';
import 'package:milanproject/agora/models/live.dart';
import 'package:milanproject/agora/models/post.dart';
import 'package:milanproject/agora/screen/agora/host.dart';
import 'package:milanproject/agora/screen/agora/join.dart';
import 'package:milanproject/agora/screen/loginScreen.dart';
import 'package:milanproject/entity/category.dart';
import 'package:milanproject/ui/aboutus_screen.dart';
import 'package:milanproject/ui/content_screen.dart';
import 'package:milanproject/ui/dictionary_screen.dart';
import 'package:milanproject/ui/generalinfoi_screen.dart';
import 'package:milanproject/ui/kirtan/kirtan_screen.dart';
import 'package:milanproject/ui/photos_screen_page.dart';
import 'package:milanproject/ui/questions/question_screen.dart';
import 'package:milanproject/ui/video/video_screen.dart';
import 'package:milanproject/ui/voice/audio_screen.dart';
import 'package:milanproject/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseReference = Firestore.instance;
  List<Live> list = [];
  bool ready = false;
  Live liveUser;
  var name;
  var image =
      'https://nichemodels.co/wp-content/uploads/2019/03/user-dummy-pic.png';
  var username;
  var postUsername;
  List<Category> _listItem = List();

  @override
  Widget build(BuildContext context) {
    return getMain();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.amber,
      statusBarColor: Colors.transparent,
    ));
    _listItem = getCategoryList();
    loadSharedPref();
    list = [];
    liveUser = Live(username: username, me: true, image: image);
    setState(() {
      list.add(liveUser);
    });
    dbChangeListen();
    /*var date = DateTime.now();
    var newDate = '${DateFormat("dd-MM-yyyy hh:mm:ss").format(date)}';
    */
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> loadSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      username = prefs.getString('username') ?? '';
      image = prefs.getString('image') ??
          'https://nichemodels.co/wp-content/uploads/2019/03/user-dummy-pic.png';
    });
  }

  void dbChangeListen() {
    databaseReference
        .collection('liveuser')
        .orderBy("time", descending: true)
        .snapshots()
        .listen((result) {
      // Listens to update in appointment collection

      setState(() {
        list = [];
        liveUser = Live(username: username, me: true, image: image);
        list.add(liveUser);
      });
      result.documents.forEach((result) {
        setState(() {
          list.add(Live(
              username: result.data['name'],
              image: result.data['image'],
              channelId: result.data['channel'],
              me: false));
        });
      });
    });
  }

  Widget getMain() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        titleSpacing: -10,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'PushtiRas',
            style: TextStyle(fontFamily: 'Billabong', fontSize: 28),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.public, color: Colors.white),
            onPressed: () async {
              String _url = 'http://pushtiras.co.in/eula';
              await canLaunch(_url)
                  ? await launch(_url)
                  : throw 'Could not launch $_url';
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () async {
              logout();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()));
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              child: getStories(),
            ),
            Divider(height: 0),
            Expanded(
                child: GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: _listItem
                  .map((item) => Card(
                        color: Colors.amber,
                        elevation: 0,
                        child: GestureDetector(
                          onTap: () {
                            switch (item.name) {
                              case "Videos":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoScreen(
                                            category: "2",
                                            title: "Videos",
                                          )),
                                );
                                break;
                              case "Utsav":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoScreen(
                                            category: "5",
                                            title: "Utsav",
                                          )),
                                );
                                break;
                              case "Photos":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhotosScreen()),
                                );
                                break;
                              case "Audio":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Musify()),
                                );
                                break;
                              case "Kirtan":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Kirtan()),
                                );
                                break;
                              case "General Info":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GeneralInfoscreen()),
                                );
                                break;
                              case "About Us":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutUsScreen()),
                                );
                                break;
                              case "Granth":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                            title: "Granth",
                                            category: "1",
                                          )),
                                );
                                break;
                              case "Varta Prasang":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                            title: "Varta Prasang",
                                            category: "7",
                                          )),
                                );
                                break;
                              case "Bethakji":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                            title: "Bethakji",
                                            category: "8",
                                          )),
                                );
                                break;
                              case "Haveli":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                            title: "Haveli",
                                            category: "9",
                                          )),
                                );
                                break;
                              case "Recipes":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                            title: "Recipes",
                                            category: "10",
                                          )),
                                );
                                break;
                              case "Tippani":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                            title: "Tippani",
                                            category: "11",
                                          )),
                                );
                                break;
                              case "Shringar Vastra":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                            title: "Shringar Vastra",
                                            category: "12",
                                          )),
                                );
                                break;
                              case "Quiz":
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Questions()));
                                break;
                              case "Satsang News":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                            title: "Satsang News",
                                            category: "13",
                                          )),
                                );
                                break;
                              case "Dictionary":
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DictionaryScreen(),
                                    ));
                                break;
                              case "General Info":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GeneralInfoscreen()),
                                );
                                break;
                              case "Seva Pranali":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ContentScreen(
                                            title: "Seva Pranali",
                                            category: "16",
                                          )),
                                );
                                break;
                              case "About Us":
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutUsScreen()),
                                );
                                break;
                            }
                          },
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 50.0,
                                      width: 40.0,
                                      child: Image(
                                        image: AssetImage(item.url),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        item.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            )),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget getStories() {
    return ListView(
        scrollDirection: Axis.horizontal, children: getUserStories());
  }

  List<Widget> getUserStories() {
    List<Widget> stories = [];
    for (Live users in list) {
      stories.add(getStory(users));
    }
    return stories;
  }

  Widget getStory(Live users) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Column(
        children: <Widget>[
          Container(
            height: 70,
            width: 70,
            child: GestureDetector(
              onTap: () async {
                FirebaseUser user = await FirebaseAuth.instance.currentUser();
                // print(user.uid);
                if (user != null) {
                  if (users.me == true) {
                    // Host function
                    print('njvnjfvjfnvjnf  --- > ${user.uid.toString()}');

                    var res = await Auth.checkUserVolunteer(user.uid);
                    print('njvnjfvjfnvjnf  --- > ${res.toString()}');

                    if (res is bool) {
                      if (res) {
                        onCreate(username: users.username, image: users.image);
                      } else {
                        alertMsgDialog('You are not Volunteer');
                      }
                    } else {
                      alertMsgDialog(res);
                    }
                  } else {
                    // Join function
                    onJoin(
                      channelName: users.username,
                      channelId: users.channelId,
                      username: username,
                      hostImage: users.image,
                      userImage: image,
                    );
                  }
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()));
                }
              },
              child: Stack(
                alignment: Alignment(0, 0),
                children: <Widget>[
                  !users.me
                      ? Container(
                          height: 60,
                          width: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.indigo,
                                  Colors.blue,
                                  Colors.cyan
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                  Container(
                    height: 55.5,
                    width: 55.5,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl: users.image,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 52.0,
                      height: 52.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  users.me
                      ? Container(
                          height: 55,
                          width: 55,
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 13.5,
                              color: Colors.white,
                            ),
                          ))
                      : Container(
                          height: 70,
                          width: 70,
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                height: 17,
                                width: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: LinearGradient(
                                      colors: [Colors.black, Colors.black],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: LinearGradient(
                                      colors: [
                                        Colors.indigo,
                                        Colors.blueAccent
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    'LIVE',
                                    style: TextStyle(
                                      fontSize: 7,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
          SizedBox(height: 3),
          Text(users.username ?? '', style: textStyle)
        ],
      ),
    );
  }

  Widget getPost(BuildContext context, Post post, int index) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 30,
                    width: 30,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(post.userPic),
                    ),
                  ),
                  Text(
                    post.user,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            setState(() {});
          },
          child: Container(
            constraints: BoxConstraints(maxHeight: 280),
            decoration: BoxDecoration(
                color: Colors.black, image: DecorationImage(image: post.image)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                post.isLiked
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: Icon(
                              Icons.favorite,
                              size: 30,
                              color: Colors.lightBlue,
                            )),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: Icon(
                              Icons.favorite_border,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Icon(
                    FontAwesomeIcons.comment,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Icon(
                    FontAwesomeIcons.paperPlane,
                    size: 23,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment(0, 0),
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.bookmark,
                  size: 28,
                  color: Colors.white,
                ),
                IconButton(
                  icon: Icon(Icons.bookmark),
                  color: post.isSaved ? Colors.white : Colors.black,
                  onPressed: () {
                    setState(() {});
                  },
                )
              ],
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15, right: 10),
              child: Text(
                post.user,
                style: textStyleBold,
              ),
            ),
            Text(
              post.description,
              style: textStyle,
            )
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    ));
  }

  Future<void> onJoin(
      {channelName, channelId, username, hostImage, userImage}) async {
    // update input validation
    if (channelName.isNotEmpty) {
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinPage(
            channelName: channelName,
            channelId: channelId,
            username: username,
            hostImage: hostImage,
            userImage: userImage,
          ),
        ),
      );
    }
  }

  Future<void> onCreate({username, image}) async {
    // await for camera and mic permissions before pushing video page
    var date = DateTime.now();
    var currentTime = '${DateFormat("dd-MM-yyyy hh:mm:ss").format(date)}';
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: username,
          time: currentTime,
          image: image,
        ),
      ),
    );
  }

  void alertMsgDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[800],
              ),
              height: 190,
              child: Column(
                children: [
                  Container(
                    height: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            'Alert',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 25, top: 15),
                          child: Text(
                            message,
                            style: TextStyle(color: Colors.white60),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 0,
                    height: 0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.lightBlue[400]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
