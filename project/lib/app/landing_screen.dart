import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/project_overview_screen.dart';
import 'package:project/screens/sign_in_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  User? _user;
  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const SignInScreen();
    }
    return const ProjectOverviewScreen();
  }
}
