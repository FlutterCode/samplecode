import 'package:flutter/cupertino.dart';

import 'api_state.dart';

abstract class QuestionState {}

@immutable
class QuestionDataState extends ApiState with QuestionState {
  QuestionDataState.loading(message) : super.loading(message);

  QuestionDataState.completed(data) : super.completed(data);

  QuestionDataState.error(message) : super.error(message);
}

class QuestionInitialState with QuestionState {}
