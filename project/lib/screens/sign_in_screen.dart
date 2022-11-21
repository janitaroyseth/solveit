import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/example_data.dart';
import 'package:project/models/project.dart';
import 'package:project/models/user.dart' as app;
import 'package:project/providers/auth_provider.dart';
import 'package:project/screens/create_profile_screen.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/input_field.dart';

/// Screen/Scaffold for signing in and signing up .
class SignInScreen extends StatelessWidget {
  /// Creates an instance of [SignInScreen].
  SignInScreen({super.key});

  /// Named route for this screen.
  static const routeName = "/signin";

  final List<Project> projects = ExampleData.projects;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 70.0, 32.0, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                  height: Platform.isIOS
                      ? MediaQuery.of(context).size.height / 8
                      : MediaQuery.of(context).size.height / 16),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: _logo(context),
              ),
              const SizedBox(height: 60),
              const _SignInForm(),
            ],
          ),
        ),
      ),
    );
  }

  Row _logo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("solve", style: Theme.of(context).textTheme.displayLarge),
        Text(
          "it",
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Themes.primaryColor.shade50,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

/// Sign in and sign up form.
class _SignInForm extends ConsumerStatefulWidget {
  /// Creates an instance of [SignInForm].
  const _SignInForm();

  @override
  ConsumerState<_SignInForm> createState() => __SignInFormState();
}

class __SignInFormState extends ConsumerState<_SignInForm> {
  List<Project> projects = ExampleData.projects;
  app.User user = ExampleData.user2;
  bool signupForm = false;
  late AuthService auth;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          signupForm ? "sign up" : "login",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 16),
        const InputField(
          label: "email",
          placeholderText: "email@example.com",
          keyboardAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
        ),
        signupForm
            ? Column(
                children: const <Widget>[
                  SizedBox(height: 6),
                  InputField(
                    label: "name",
                    placeholderText: "john doe",
                    isPassword: true,
                    keyboardAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              )
            : const SizedBox(),
        const SizedBox(height: 6),
        const InputField(
          label: "password",
          placeholderText: "password",
          isPassword: true,
          keyboardAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
        ),
        signupForm
            ? Column(
                children: const <Widget>[
                  SizedBox(height: 6),
                  InputField(
                    label: "confirm password",
                    placeholderText: "confirm password",
                    isPassword: true,
                    keyboardAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              )
            : const SizedBox(),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: signupForm
              ? () =>
                  Navigator.of(context).pushNamed(CreateProfileScreen.routeName)
              : () => Navigator.of(context).popAndPushNamed(
                    HomeScreen.routeName,
                    arguments: {
                      "user": user,
                      "projects": projects,
                    },
                  ),
          style: Themes.primaryElevatedButtonStyle,
          child: Text(signupForm ? "sign up" : "sign in"),
        ),
        const SizedBox(height: 48),
        signupForm
            ? const Text(
                "or sign up with",
                textAlign: TextAlign.center,
              )
            : const Text(
                "or sign in with",
                textAlign: TextAlign.center,
              ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: _signInAnonymously,
              style: Themes.circularButtonStyle,
              child: const Icon(
                PhosphorIcons.facebookLogo,
                size: 36,
              ),
            ),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              style: Themes.circularButtonStyle,
              child: const Icon(
                PhosphorIcons.googleLogo,
                size: 36,
              ),
            ),
            ElevatedButton(
              onPressed: signupForm
                  ? () => Navigator.of(context)
                      .pushNamed(CreateProfileScreen.routeName)
                  : () => Navigator.of(context).popAndPushNamed(
                        HomeScreen.routeName,
                        arguments: {
                          "user": user,
                          "projects": projects,
                        },
                      ),
              style: Themes.circularButtonStyle,
              child: const Icon(
                PhosphorIcons.appleLogo,
                size: 36,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: signupForm
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("already have an account?"),
                    TextButton(
                      style: Themes.textButtonStyle(ref).copyWith(
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(
                            fontSize: 14,
                            fontFamily: Themes.fontFamily,
                          ),
                        ),
                      ),
                      child: const Text("sign in here >"),
                      onPressed: () => setState(() => signupForm = false),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("don't have an account?"),
                    TextButton(
                      style: Themes.textButtonStyle(ref).copyWith(
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(
                            fontSize: 14,
                            fontFamily: Themes.fontFamily,
                          ),
                        ),
                      ),
                      child: const Text("sign up here >"),
                      onPressed: () => setState(() => signupForm = true),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  /// Signing the user in anonymously.
  Future<void> _signInAnonymously() async {
    final auth = ref.read(authProvider);
    auth.signInAnonymously();
  }

  /// Signing the user in with Google.
  Future<void> _signInWithGoogle() async {
    final auth = ref.read(authProvider);
    auth.signInWithGoogle();
  }
}
