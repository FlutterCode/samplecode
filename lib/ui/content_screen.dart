import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milanproject/bloc/content_bloc.dart';
import 'package:milanproject/common/enums.dart';
import 'package:milanproject/entity/content.dart';
import 'package:milanproject/event/content_event.dart';
import 'package:milanproject/repository/mi_repository.dart';
import 'package:milanproject/state/content_state.dart';
import 'package:milanproject/ui/details_screen.dart';
import 'package:milanproject/ui/widget/colored_card.dart';
import 'package:milanproject/widgets/generic_loader.dart';

class ContentScreen extends StatefulWidget {
  String title;
  String category;

  ContentScreen({@required this.title, @required this.category});

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  ContentBloc _contentBloc;
  ProjectRepository _projectRepository;

  @override
  void initState() {
    super.initState();
    _projectRepository = ProjectRepository();
    _contentBloc = ContentBloc(projectRepository: _projectRepository)
      ..add(LoadContentData(categoryId: widget.category));
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
      body: BlocBuilder<ContentBloc, ContentState>(
        bloc: _contentBloc,
        builder: (context, state) {
          if (state is ContentDataState) {
            switch (state.status) {
              case Status.LOADING:
                return Loading(loadingMessage: state.message);
                break;
              case Status.COMPLETED:
                return GranthList(state.data);
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

class GranthList extends StatelessWidget {
  final List<Content> contents;

  GranthList(this.contents);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contents.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(lesson: contents[index])),
            )
          },
          child: Container(
            margin: EdgeInsets.only(top: 5.0),
            child: ColoredCard(
              cardHeight: 50,
              borderRadius: 5,
              showFooter: false,
              showHeader: false,
              bodyGradient: LinearGradient(
                colors: [
                  Colors.grey[300].withOpacity(1),
                  Colors.grey[300],
                  Colors.grey[300],
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0, 0.2, 1],
              ),
              bodyContent: Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contents[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: "Manrope",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
