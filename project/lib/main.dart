import 'package:flutter/material.dart';
import 'package:project/sign_in/sign_in_page.dart';
import 'package:project/widgets/custom_elevated_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "solveIt",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Comfortaa",
      ),
      home: SignInPage(),
    );
  }
}





