import 'package:exam_project_flutter/views/home_page.dart';
import 'package:exam_project_flutter/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkLogin();
  }

  _checkLogin() async {
    Future.delayed(const Duration(milliseconds: 2000), () async {
      bool exists = await FlutterSecureStorage().containsKey(key: "token");

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => exists ? HomePage() : LoginPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: FlutterLogo()),
    );
  }
}
