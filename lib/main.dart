import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'pages/login_page.dart';
import 'pages/regis_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(42, 117, 188, 1),
        accentColor: Color.fromRGBO(42, 117, 188, 1),
        backgroundColor: Color.fromRGBO(28, 27, 27, 1),
      ),
      home: RegisPage(),
    );
  }
}
