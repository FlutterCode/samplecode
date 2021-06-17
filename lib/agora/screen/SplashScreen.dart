import 'dart:async';
import 'package:flutter/material.dart';
import 'package:milanproject/main.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var image = Image.asset('assets/images/lightlogo.png');

  @override
  void initState() {
    super.initState();
    startTime();
    takePermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image.image, context);
  }

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    width: double.maxFinite,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Center(
                        child: image,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void takePermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.mediaLibrary,
      Permission.microphone,
    ].request();
    print(statuses);
  }
}
