import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/sign_in_screen.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = "/landingscreen";
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  User? _user;
  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInScreen();
      // return const HomeScreen();
    }
    // return SignInScreen();
    return const HomeScreen();
  }
}
