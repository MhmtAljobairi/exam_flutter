class Category {
  int id;
  String name;
  Category(this.id, this.name);

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(int.parse(json["id"].toString()), json["name"]);
  }
}
