import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/sign_in/sign_in_button.dart';
import 'package:project/sign_in/sign_up_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/signInBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _buildContent(),
      ),
    );
  }
}

Widget _buildContent() {
  const fontFamily = "Comfortaa";
  const fontWeight = FontWeight.w600;
  const fontSize = 18.0;
  const logoHeight = 25.0;

  return Padding(
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
          const Text(
            "solveIt",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 80.0),
          SignInButton(
            icon: PhosphorIcons.googleLogo,
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            fontSize: fontSize,
            assetName: 'assets/images/google-logo.png',
            logoHeight: logoHeight,
            text: "Continue with Google",
            color: Colors.white,
            onPressed: () {},
            textColor: Colors.black, //does nothing
          ),
          const SizedBox(height: 15.0),
          SignInButton(
            icon: PhosphorIcons.facebookLogo,
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            fontSize: fontSize,
            assetName: 'assets/images/facebook-logo.png',
            logoHeight: logoHeight,
            text: "Continue with Facebook",
            color: Colors.white,
            textColor: Colors.black,
            onPressed: () {},
          ),
          const SizedBox(height: 15.0),
          SignInButton(
            icon: PhosphorIcons.appleLogo,
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            fontSize: fontSize,
            assetName: 'assets/images/apple-logo.png',
            logoHeight: logoHeight,
            text: "Continue with Apple",
            color: Colors.white,
            textColor: Colors.black,
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
            fontFamily: fontFamily,
            fontWeight: FontWeight.w300,
            fontSize: 16,
            onPressed: () {},
            color: const Color.fromRGBO(36, 149, 165, 1.0),
            padding: 50,
          ),

          // SocialSignInButton(
          //   fontFamily: fontFamily,
          //   fontWeight: fontWeight,
          //   fontSize: fontSize,
          //   assetName: 'assets/images/facebook-logo.png',
          //   logoHeight: logoHeight,
          //   text: "Sign up with email",
          //   color: Colors.white,
          //   textColor: Colors.black,
          //   onPressed: () {},
          // ),

          const SizedBox(height: 25.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Text("have an account? "),
            Text("log in", style: TextStyle(fontWeight: FontWeight.bold))
          ]),
        ],
      ),
    ),
  );
}
