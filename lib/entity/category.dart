class Category {
  final String name;
  final String url;

  Category(this.name, this.url);

  Category.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
      };
}
