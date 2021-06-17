import 'package:flutter/cupertino.dart';

import 'api_state.dart';

abstract class VideoState {}

@immutable
class VideoDataState extends ApiState with VideoState {
  VideoDataState.loading(message) : super.loading(message);

  VideoDataState.completed(data) : super.completed(data);

  VideoDataState.error(message) : super.error(message);
}

class VideooInitialState with VideoState {}
