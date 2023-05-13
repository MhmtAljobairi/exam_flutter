import 'package:exam_project_flutter/controllers/api_helper.dart';
import 'package:exam_project_flutter/models/order.dart';

class OrderController {
  Future<dynamic> create(Order order) async {
    try {
      var result = await ApiHelper().postDio("/api/orders", order.toJson());
      print(result);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
