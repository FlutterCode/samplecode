import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:milanproject/entity/content.dart';
import 'package:milanproject/event/content_event.dart';
import 'package:milanproject/repository/mi_repository.dart';
import 'package:milanproject/state/content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  ///
  /// Section: Public variables
  ///
  final ProjectRepository projectRepository;

  ContentBloc({@required this.projectRepository})
      : assert(projectRepository != null), super(ContentDataState.loading('Fetching data'));

  @override
  get initialState => ContentInitialState();

  @override
  Stream<ContentState> mapEventToState(ContentEvent event) async* {
    if (event is LoadContentData) {
      // Fetch the data
      yield ContentDataState.loading('Fetching data');
      try {
        /// Get Photos List
        List<Content> contentData =
            await projectRepository.getContent(event.categoryId);
        yield ContentDataState.completed(contentData);
      } catch (e) {
        yield ContentDataState.error(e.toString());
        print(e);
      }
    }
  }
}
