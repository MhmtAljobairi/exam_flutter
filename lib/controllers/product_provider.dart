import 'package:exam_project_flutter/models/product.dart';
import 'package:flutter/material.dart';

class ProductProvier with ChangeNotifier {
  List<Product> selectedProducts = [];
  double total = 0;

  addToCart(Product product) {
    selectedProducts.add(product);
    generateTotal();
    notifyListeners();
  }

  removeProduct(int index) {
    selectedProducts.removeAt(index);
    generateTotal();
    notifyListeners();
  }

  updateQty(Product product, int newQty) {
    product.selectedQty = newQty;
    print("newQty" + newQty.toString());
    generateTotal();
    notifyListeners();
  }

  generateTotal() {
    total = 0;
    for (Product product in selectedProducts) {
      total += product.selectedQty * product.price;
    }
  }
}
