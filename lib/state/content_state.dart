import 'package:flutter/cupertino.dart';

import 'api_state.dart';

abstract class ContentState {}

@immutable
class ContentDataState extends ApiState with ContentState {
  ContentDataState.loading(message) : super.loading(message);

  ContentDataState.completed(data) : super.completed(data);

  ContentDataState.error(message) : super.error(message);
}

class ContentInitialState with ContentState {}
