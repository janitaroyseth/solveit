import 'package:flutter/material.dart';
import 'package:project/screens/sign_in_screen.dart';

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
      home: const SignInScreen(),
    );
  }
}
