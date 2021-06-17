import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:milanproject/entity/questionsmodel.dart';
import 'package:milanproject/event/question_event.dart';
import 'package:milanproject/repository/mi_repository.dart';
import 'package:milanproject/state/question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  ///
  /// Section: Public variables
  ///
  final ProjectRepository projectRepository;

  QuestionBloc({@required this.projectRepository})
      : assert(projectRepository != null), super(QuestionDataState.loading('Fetching data'));

  @override
  get initialState => QuestionInitialState();

  @override
  Stream<QuestionState> mapEventToState(QuestionEvent event) async* {
    if (event is LoadQuestionData) {
      // Fetch the data
      yield QuestionDataState.loading('Fetching data');
      try {
        /// Get Photos List
        List<QuestionsModel> questionData =
            await projectRepository.getQuestionData();
        yield QuestionDataState.completed(questionData);
      } catch (e) {
        yield QuestionDataState.error(e.toString());
        print(e);
      }
    }
  }
}
