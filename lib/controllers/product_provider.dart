import 'package:exam_project_flutter/models/address.dart';
import 'package:exam_project_flutter/models/product.dart';
import 'package:flutter/material.dart';

class ProductProvier with ChangeNotifier {
  List<Product> selectedProducts = [];
  double total = 0;
  double taxAmount = 0;
  double subTotal = 0;
  Address? address;
  final keyForm = GlobalKey<FormState>();
  int paymentMethod = 1;

  addToCart(Product product) {
    selectedProducts.add(product);
    generateTotal();
    notifyListeners();
  }

  updateAddress(Address newAddress) {
    address = newAddress;
  }

  updatePaymentMethod(int newId) {
    paymentMethod = newId;
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
    subTotal = 0;
    taxAmount = 0;
    for (Product product in selectedProducts) {
      subTotal += product.subTotal;
      taxAmount += product.taxAmount;
      total += product.total;
    }
  }
}
