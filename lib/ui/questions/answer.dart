import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function selectHandler;
  final String answerText;

  Answer({this.selectHandler, this.answerText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(5),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: RaisedButton(
              color: Colors.grey[600],
              textColor: Colors.white,
              child: Text(answerText),
              onPressed: selectHandler,
            ),
          ),
        ),
      ),
    );
  }
}
