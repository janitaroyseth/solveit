import 'package:flutter/material.dart';
import 'package:project/widgets/bottom_bar.dart';

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
      home: const BottomBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
