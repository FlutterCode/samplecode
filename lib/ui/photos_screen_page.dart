import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:milanproject/bloc/photos_bloc.dart';
import 'package:milanproject/common/enums.dart';
import 'package:milanproject/entity/data.dart';
import 'package:milanproject/event/photos_event.dart';
import 'package:milanproject/repository/mi_repository.dart';
import 'package:milanproject/state/photos_state.dart';
import 'package:milanproject/widgets/generic_loader.dart';
import 'package:toast/toast.dart';

class PhotosScreen extends StatefulWidget {
  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  PhotosBloc _photosBloc;
  ProjectRepository _projectRepository;

  @override
  void initState() {
    super.initState();
    _projectRepository = ProjectRepository();
    _photosBloc = PhotosBloc(projectRepository: _projectRepository)
      ..add(LoadPhotosData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        title: Text("Photos"),
      ),
      body: BlocBuilder<PhotosBloc, PhotosState>(
        bloc: _photosBloc,
        builder: (context, state) {
          if (state is PhotosDataState) {
            switch (state.status) {
              case Status.LOADING:
                return Loading(loadingMessage: state.message);
                break;
              case Status.COMPLETED:
                return PhotosList(state.data);
                break;
              case Status.ERROR:
                return Container(
                  child: Text("Errroror"),
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

class PhotosList extends StatelessWidget {
  final List<Photos> photos;

  PhotosList(this.photos);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Card(
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(80),
              minScale: 0.5,
              maxScale: 4,
              child: FadeInImage.assetNetwork(
                height: 150,
                placeholder: 'assets/images/lightlogo.png',
                image: photos[index].image,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PhotoView(photos[index].image)));
          },
        );
      },
    );
  }
}

class PhotoView extends StatefulWidget {
  final String imageUrl;
  const PhotoView(this.imageUrl);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  //
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded),
            color: Colors.white,
            onPressed: _downloadImage,
          ),
          SizedBox(width: 10)
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(80),
              minScale: 0.5,
              maxScale: 4,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/lightlogo.png',
                image: widget.imageUrl,
              ),
            ),
          ),
          Visibility(
            visible: loading,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white.withOpacity(0.4),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.amber),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _downloadImage() async {
    try {
      try {
        setState(() => loading = true);
        await ImageDownloader.downloadImage(widget.imageUrl);
      } finally {
        setState(() => loading = false);
        Toast.show('Download Success', context);
      }
    } on PlatformException catch (error) {
      setState(() => loading = false);
      Toast.show('Download Failed $error', context);
    }
  }
}
