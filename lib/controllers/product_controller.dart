import 'package:exam_project_flutter/controllers/api_helper.dart';
import 'package:exam_project_flutter/models/product.dart';

class ProductController {
  Future<List<Product>> getAll() async {
    try {
      List<Product> products = [];
      var response = await ApiHelper().getRequest("/api/products");

      response.forEach((v) {
        products.add(Product.fromJson(v));
      });

      return products;
    } catch (ex) {
      rethrow;
    }
  }
}
