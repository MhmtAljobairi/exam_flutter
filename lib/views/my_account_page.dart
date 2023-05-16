import 'package:email_validator/email_validator.dart';
import 'package:exam_project_flutter/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyAccountPage extends StatelessWidget {
  MyAccountPage({super.key});

  final _controllerUsername = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
      ),
      body: FutureBuilder(
        future: UserController().getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _controllerUsername.text = snapshot.data!.username;
            _controllerEmail.text = snapshot.data!.email;
            return Container(
              padding: EdgeInsets.all(8.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controllerUsername,
                        validator: (value) {
                          if (value == null || value.length < 2) {
                            return "The username is required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.account_circle_rounded),
                            label: Text("Username")),
                      ),
                      TextFormField(
                        controller: _controllerEmail,
                        validator: (value) {
                          if (!EmailValidator.validate(value!)) {
                            return "The email must be correct";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.email),
                            label: Text("Email")),
                      ),
                      TextFormField(
                        controller: _controllerPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          if (value.length < 7) {
                            return "The password must be strong";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.password),
                            label: Text("Password")),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              _handleSubmitAction();
                            },
                            child: Text("Submit")),
                      )
                    ],
                  )),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("There are some certian of errors"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _handleSubmitAction() {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: "Loading");
      UserController()
          .update(
              email: _controllerEmail.text,
              password: _controllerPassword.text,
              username: _controllerUsername.text)
          .then((value) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Done");
      }).catchError((ex) {
        EasyLoading.dismiss();
        EasyLoading.showError(ex.toString());
      });
    }
  }
}
