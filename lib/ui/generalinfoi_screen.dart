import 'package:flutter/material.dart';

class GeneralInfoscreen extends StatefulWidget {
  @override
  _GeneralInfoscreenState createState() => _GeneralInfoscreenState();
}

class _GeneralInfoscreenState extends State<GeneralInfoscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        title: Text("General Info"),
      ),
      body: Container(
        child: Center(
          child: Text('General Info',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.amber)),
        ),
      ),
    );
  }
}
