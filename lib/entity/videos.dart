class Videos {
  int id;
  String categoryId;
  String title;
  String image;
  String video;
  String video_link;
  String duration;
  String status;

  Videos(
      {this.id,
        this.categoryId,
        this.title,
        this.image,
        this.video,
        this.video_link,
        this.duration,
        this.status});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    image = json['image'];
    video = json['video'];
    video_link = json['video_link'];
    duration = json['duration'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['video'] = this.video;
    data['video_link'] = this.video_link;
    data['duration'] = this.duration;
    data['status'] = this.status;
    return data;
  }
}