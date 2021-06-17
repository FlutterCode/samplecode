class Content {
  int id;
  String categoryId;
  String name;
  String title;
  String desc;
  String details;
  String status;
  String image;

  Content({
    this.id,
    this.categoryId,
    this.name,
    this.title,
    this.desc,
    this.details,
    this.status,
    this.image,
  });

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    title = json['title'];
    desc = json['desc'];
    details = json['details'];
    status = json['status'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['details'] = this.details;
    data['status'] = this.status;
    data['image'] = this.image;
    return data;
  }
}
