class Photos {
  int id;
  String categoryId;
  String title;
  String image;
  String status;

  Photos({this.id, this.categoryId, this.title, this.image, this.status});

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}