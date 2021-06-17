import 'dart:math';

import 'package:flutter/material.dart';
import 'package:milanproject/entity/content.dart';

class DetailPage extends StatelessWidget {
  final Content lesson;

  DetailPage({Key key, this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Text(
          lesson.title,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 8,
          padding:
              EdgeInsets.only(top: 40.0, bottom: 0.0, right: 40.0, left: 40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.amber),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 50.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Text(
      lesson.desc,
      style: TextStyle(fontSize: 18.0),
    );
    final bottomContent = Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(25.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText],
        ),
      ),
    );

    int index = Random().nextInt(2) + 1;
    print('Lesson Inage:- ${lesson.image}');
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            if (lesson.image != null || lesson.image == '')
              Opacity(
                opacity: 0.4,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(lesson.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[topContent, bottomContent],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
