import 'package:flutter/cupertino.dart';

import 'api_state.dart';

abstract class PhotosState {}

@immutable
class PhotosDataState extends ApiState with PhotosState {
  PhotosDataState.loading(message) : super.loading(message);

  PhotosDataState.completed(data) : super.completed(data);

  PhotosDataState.error(message) : super.error(message);
}

class PhotosInitialState with PhotosState {}
