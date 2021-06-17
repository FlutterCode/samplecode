import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milanproject/bloc/video_bloc.dart';
import 'package:milanproject/common/enums.dart';
import 'package:milanproject/entity/videos.dart';
import 'package:milanproject/event/video_event.dart';
import 'package:milanproject/repository/mi_repository.dart';
import 'package:milanproject/state/video_state.dart';
import 'package:milanproject/ui/video/videoplayer_screen.dart';
import 'package:milanproject/widgets/generic_loader.dart';

class VideoScreen extends StatefulWidget {
  final String title;
  final String category;

  VideoScreen({@required this.title, @required this.category});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoBloc _videoBloc;
  ProjectRepository _projectRepository;

  @override
  void initState() {
    super.initState();
    _projectRepository = ProjectRepository();
    _videoBloc = VideoBloc(projectRepository: _projectRepository)
      ..add(LoadVideoData(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        title: Text(widget.title),
      ),
      body: BlocBuilder<VideoBloc, VideoState>(
        bloc: _videoBloc,
        builder: (context, state) {
          if (state is VideoDataState) {
            switch (state.status) {
              case Status.LOADING:
                return Loading(loadingMessage: state.message);
                break;
              case Status.COMPLETED:
                return VideoList(state.data);
                break;
              case Status.ERROR:
                return Container(
                  child: Text('Error'),
                );
                break;
            }
          }
          return Container();
        },
      ),
    );
  }
}

class VideoList extends StatelessWidget {
  final List<Videos> videos;

  VideoList(this.videos);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: videos.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VideoPlayerScreen(videoUrl: videos[index].video_link)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // add this
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: FadeInImage.assetNetwork(
                        height: 150,
                        placeholder: 'assets/images/lightlogo.png',
                        image: videos[index].image),
                  ),
                  ListTile(
                    title: Text(videos[index].title),
                    subtitle: Text(videos[index].title),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
