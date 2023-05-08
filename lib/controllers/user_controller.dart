import 'package:exam_project_flutter/controllers/api_helper.dart';
import 'package:exam_project_flutter/models/login.dart';

class UserController {
  Future<Login> login(String email, String password) async {
    try {
      var result = await ApiHelper().postRequest("/api/users/login", {
        "email": email,
        "password": password,
      });
      return Login.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }
}
