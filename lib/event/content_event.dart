import 'package:flutter/cupertino.dart';

abstract class ContentEvent {
  const ContentEvent();
}

class LoadContentData extends ContentEvent {
  final String categoryId;

  const LoadContentData({@required this.categoryId});
}
