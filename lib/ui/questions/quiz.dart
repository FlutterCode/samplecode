import 'package:flutter/material.dart';
import 'package:milanproject/entity/questionsmodel.dart';
import 'package:milanproject/ui/questions/answer.dart';

import './question.dart';

class Quiz extends StatelessWidget {
  final List<QuestionsModel> questions;
  final int questionIndex;
  final Function answerQuestions;

  Quiz(
      {@required this.questions,
      @required this.answerQuestions,
      @required this.questionIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff1c252a),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Question(questions[questionIndex].question),
            ),
            Answer(
              selectHandler: () => answerQuestions(
                questions[questionIndex].answer,
                questions[questionIndex].option1,
              ),
              answerText: questions[questionIndex].option1,
            ),
            Answer(
              selectHandler: () => answerQuestions(
                questions[questionIndex].answer,
                questions[questionIndex].option2,
              ),
              answerText: questions[questionIndex].option2,
            ),
            Answer(
              selectHandler: () => answerQuestions(
                questions[questionIndex].answer,
                questions[questionIndex].option3,
              ),
              answerText: questions[questionIndex].option3,
            ),
            Answer(
              selectHandler: () => answerQuestions(
                questions[questionIndex].answer,
                questions[questionIndex].option4,
              ),
              answerText: questions[questionIndex].option4,
            )
          ],
        ),
      ),
    );
  }
}
