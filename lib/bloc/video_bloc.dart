import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:milanproject/entity/videos.dart';
import 'package:milanproject/event/video_event.dart';
import 'package:milanproject/repository/mi_repository.dart';
import 'package:milanproject/state/video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  ///
  /// Section: Public variables
  ///
  final ProjectRepository projectRepository;

  VideoBloc({@required this.projectRepository})
      : assert(projectRepository != null), super(VideoDataState.loading('Fetching data'));

  @override
  get initialState => VideooInitialState();

  @override
  Stream<VideoState> mapEventToState(VideoEvent event) async* {
    if (event is LoadVideoData) {
      // Fetch the data
      yield VideoDataState.loading('Fetching data');
      try {
        /// Get Photos List
        List<Videos> videoData =
            await projectRepository.getVideos(event.categoryId);
        yield VideoDataState.completed(videoData);
      } catch (e) {
        yield VideoDataState.error(e.toString());
        print(e);
      }
    }
  }
}
