
abstract class VideoEvent {
  const VideoEvent();
}

class LoadVideoData extends VideoEvent {
  final String categoryId;
  const LoadVideoData(this.categoryId);
}
