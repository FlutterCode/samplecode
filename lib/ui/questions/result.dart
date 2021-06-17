import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final Function resetHandlar;

  Result(this.resultScore, this.resetHandlar);

  String get resultPhrase {
    String resultText;
    if (resultScore <= 20) {
      resultText = 'You are Good! Result Score:$resultScore';
    } else if (resultScore <= 30) {
      resultText = 'You are Good! Result Score:$resultScore';
    } else if (resultScore <= 40) {
      resultText = 'You are Great! Result Score:$resultScore';
    } else {
      resultText = 'You are awasome! Result Score:$resultScore';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff1c252a),
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                resultPhrase,
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            FlatButton(
              child: Text(
                'Restart Quiz!',
                style: TextStyle(fontSize: 16.0),
              ),
              textColor: Colors.blue,
              onPressed: resetHandlar,
            )
          ],
        ),
      ),
    );
  }
}
