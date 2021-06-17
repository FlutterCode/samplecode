import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:milanproject/entity/data.dart';
import 'package:milanproject/event/photos_event.dart';
import 'package:milanproject/repository/mi_repository.dart';
import 'package:milanproject/state/photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  ///
  /// Section: Public variables
  ///
  final ProjectRepository projectRepository;

  PhotosBloc({@required this.projectRepository})
      : assert(projectRepository != null), super(PhotosDataState.loading('Fetching data'));

  @override
  get initialState => PhotosInitialState();

  @override
  Stream<PhotosState> mapEventToState(PhotosEvent event) async* {
    if (event is LoadPhotosData) {
      // Fetch the data
      yield PhotosDataState.loading('Fetching data');
      try {
        /// Get Photos List
        List<Photos> photosData = await projectRepository.getPhotos();
        yield PhotosDataState.completed(photosData);
      } catch (e) {
        yield PhotosDataState.error(e.toString());
        print(e);
      }
    }
  }
}
