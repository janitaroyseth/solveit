import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/screens/create_profile_screen.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/widgets/sign_in_button.dart';
import 'package:project/widgets/sign_up_button.dart';

import '../models/project.dart';
import '../data/example_data.dart';

///Represents the sign-in screen for the application
class SignInScreen extends StatelessWidget {
  static const routeName = "/signin";
  List<Project> projects = ExampleData.projects;
  // const SignInScreen({Key? key, required this.onSignIn}) : super(key: key);

  Future<void> _signInAnonymously() async {
    try {
      final userCredentials = await FirebaseAuth.instance.signInAnonymously();
      print(userCredentials.user?.uid);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/signInBackground.png"),
            fit: BoxFit.fill,
          ),
        ),
        //TODO: ADD BLUR
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 120, 40, 100),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "solve",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w100,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "It",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      )
                    ]),
                const SizedBox(height: 80.0),
                SignInButton(
                  icon: PhosphorIcons.googleLogo,
                  text: "Continue with Google",
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routeName,
                        arguments: projects);
                  },
                ),
                const SizedBox(height: 15.0),
                SignInButton(
                  icon: PhosphorIcons.facebookLogo,
                  text: "Continue with Facebook",
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(CreateProfileScreen.routeName),
                ),
                const SizedBox(height: 15.0),
                SignInButton(
                  icon: PhosphorIcons.appleLogo,
                  text: "Continue with Apple",
                  onPressed: () {},
                ),
                const SizedBox(height: 25.0),
                const Text(
                  "or",
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0),
                SignUpButton(
                  text: "Sign up with email",
                  onPressed: () {},
                ),
                const SizedBox(height: 25.0),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("have an account? "),
                  TextButton(
                    style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                        //TODO: Check why foregroundColor makes error.
                        //foregroundColor: Colors.black,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Comfortaa",
                          color: Colors.black,
                        )),
                    onPressed: _signInAnonymously,
                    //TODO: Remove anonymously login from here.
                    child: const Text("log in anonymously"),
                  ),
                  //Text("log in", style: TextStyle(fontWeight: FontWeight.bold))
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
