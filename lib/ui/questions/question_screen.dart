import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milanproject/bloc/question_bloc.dart';
import 'package:milanproject/common/enums.dart';
import 'package:milanproject/event/question_event.dart';
import 'package:milanproject/repository/mi_repository.dart';
import 'package:milanproject/state/question_state.dart';
import 'package:milanproject/ui/questions/quiz.dart';
import 'package:milanproject/ui/questions/result.dart';
import 'package:milanproject/widgets/generic_loader.dart';
import 'package:toast/toast.dart';

class Questions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuestionsState();
  }
}

class _QuestionsState extends State<Questions> {
  var _questionIndex = 0;
  var _totalScore = 0;
  QuestionBloc _questionBloc;
  ProjectRepository _projectRepository;

  @override
  void initState() {
    super.initState();
    _projectRepository = ProjectRepository();
    _questionBloc = QuestionBloc(projectRepository: _projectRepository)
      ..add(LoadQuestionData());
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestions(String answer, String selectedAbswer) {
    if (answer == selectedAbswer) {
      _totalScore++;
    } else {
      Toast.show('Right answer : $answer', context, duration: 2);
    }

    Future.delayed(Duration(seconds: 1), () {
      setState(() => _questionIndex = _questionIndex + 1);
      print('_questionIndex: $_questionIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: Text('Quiz App')),
      body: BlocBuilder<QuestionBloc, QuestionState>(
        bloc: _questionBloc,
        builder: (context, state) {
          if (state is QuestionDataState) {
            switch (state.status) {
              case Status.LOADING:
                return Loading(loadingMessage: state.message);
                break;
              case Status.COMPLETED:
                return _questionIndex < state.data.length
                    ? Quiz(
                        questions: state.data,
                        answerQuestions: _answerQuestions,
                        questionIndex: _questionIndex,
                      )
                    : Result(_totalScore, _resetQuiz);
                break;
              case Status.ERROR:
                return Center(child: Text('Error'));
                break;
            }
          }
          return Container();
        },
      ),
    );
  }
}