import 'dart:io';

import 'package:exam_project_flutter/controllers/api_helper.dart';
import 'package:exam_project_flutter/models/login.dart';
import 'package:exam_project_flutter/models/user.dart';

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

  Future<User> update(
      {required String email,
      required String password,
      required String username}) async {
    try {
      var result = await ApiHelper().putRequest("/api/users", {
        "email": email,
        "password": password,
        "username": username,
      });
      return User.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUser() async {
    try {
      var result = await ApiHelper().getRequest("/api/users");
      return User.fromJson(result);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImage(File file) async {
    try {
      var result = await ApiHelper().uploadImage(file, "/api/storage");
      print(result);
      return result["path"];
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }
}
