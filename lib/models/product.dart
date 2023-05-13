import 'package:exam_project_flutter/models/category.dart';

class Product {
  late int id;
  late String name;
  late int categoryId;
  late String image;
  late double price;
  late int currentQty;
  late String description;
  late Category category;
  late double tax = 16;
  int selectedQty = 0;

  Product.fromJson(Map<String, dynamic> json) {
    id = int.parse(json["id"].toString());
    name = json["name"];
    categoryId = int.parse(json["category_id"].toString());
    image = json["image"];
    price = double.parse(json["price"].toString());
    currentQty = int.parse(json["current_qty"].toString());
    description = json["description"];
    category = Category.fromJson(json["category"]);
  }

  double get finalPrice {
    return price * (1 + (tax / 100));
  }

  double get subTotal {
    return price * selectedQty;
  }

  double get taxAmount {
    return (price * (tax / 100)) * selectedQty;
  }

  double get total {
    return (price * (1 + (tax / 100))) * selectedQty;
  }

  double get total2 => price * selectedQty;

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": id,
        "qty": selectedQty,
        "price": price,
        "total": total,
      };
}
