import 'package:email_validator/email_validator.dart';
import 'package:exam_project_flutter/controllers/user_controller.dart';
import 'package:exam_project_flutter/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  _handleSignInAction(BuildContext context) {
    final storage = FlutterSecureStorage();
    EasyLoading.show(status: "Loading");
    UserController()
        .login(_controllerEmail.text, _controllerPassword.text)
        .then((value) async {
      EasyLoading.dismiss();
      await FlutterSecureStorage()
          .write(key: "token", value: "${value.type} ${value.token}");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }).catchError((ex) {
      EasyLoading.dismiss();
      EasyLoading.showError(ex.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Form(
            key: _keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterLogo(
                  size: 100,
                ),
                TextFormField(
                  controller: _controllerEmail,
                  validator: (text) {
                    if (!EmailValidator.validate(text!)) {
                      return "Please add correct email address";
                    }
                  },
                ),
                TextFormField(
                  controller: _controllerPassword,
                  validator: (text) {
                    if (text!.length < 8) {
                      return "Please add a valid passowrd";
                    }
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      _handleSignInAction(context);
                    },
                    child: Text("Sign in"))
              ],
            )),
      ),
    );
  }
}
