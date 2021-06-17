class Audios {
  int id;
  String categoryId;
  String title;
  String image;
  String audio;
  int duration;
  int status;

  Audios(
      {this.id,
        this.categoryId,
        this.title,
        this.image,
        this.audio,
        this.duration,
        this.status});

  Audios.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    image = json['image'];
    audio = json['audio'];
    duration = json['duration'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['audio'] = this.audio;
    data['duration'] = this.duration;
    data['status'] = this.status;
    return data;
  }
}