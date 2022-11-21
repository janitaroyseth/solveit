import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/example_data.dart';
import 'package:project/models/project.dart';
import 'package:project/models/user.dart' as app;
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/create_profile_screen.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/styles/theme.dart';

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
        Text(
          "solve",
          style: Theme.of(context).textTheme.displayLarge,
        ),
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
  final formKey = GlobalKey<FormState>();

  String email = "";
  String name = "";
  String password = "";

  void submitEmailRequest() {
    bool? isValid = formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid != null && isValid && signupForm) {
      formKey.currentState?.save();

      /// Send registration request.
    } else if (isValid != null && isValid) {
      formKey.currentState?.save();

      /// Send login request.
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            signupForm ? "sign up" : "login",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          emailField(),
          nameField(),
          verticalPadding(),
          passwordField(),
          confirmPasswordField(),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: submitEmailRequest,
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
      ),
    );
  }

  SizedBox verticalPadding() => const SizedBox(height: 6);

  Visibility confirmPasswordField() {
    return Visibility(
      visible: signupForm,
      child: Column(
        children: <Widget>[
          verticalPadding(),
          TextFormField(
            key: const ValueKey("confirm_password"),
            decoration: Themes.inputDecoration(
              ref,
              "confirm password",
              "confirm password",
            ),
            validator: (value) {
              if (password == value) {
                return null;
              }
              return "Does not match password";
            },
            onChanged: (value) {
              password = value;
            },
            onSaved: (newValue) {
              name = newValue ?? "";
            },
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  TextFormField passwordField() {
    return TextFormField(
      key: const ValueKey("password"),
      decoration: Themes.inputDecoration(ref, "password", "password"),
      obscureText: true,
      validator: (value) {
        if (RegExp(r"^(?=.*\d).{7,20}$").hasMatch(
          value ?? "",
        )) {
          return null;
        }
        return "7 characters and a number";
      },
      onChanged: (value) {
        password = value;
      },
      onSaved: (newValue) {
        name = newValue ?? "";
      },
      textInputAction: signupForm ? TextInputAction.next : TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
    );
  }

  Visibility nameField() {
    return Visibility(
      visible: signupForm,
      child: Column(
        children: <Widget>[
          verticalPadding(),
          TextFormField(
            key: const ValueKey("name"),
            validator: (value) {
              if (value!.length >= 3) {
                return null;
              }
              return "name needs to be atleast 3 characters";
            },
            decoration: Themes.inputDecoration(
              ref,
              "name",
              "john doe",
            ),
            onSaved: (newValue) {
              name = newValue ?? "";
            },
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }

  TextFormField emailField() {
    return TextFormField(
      key: const ValueKey("email"),
      validator: (value) {
        if (RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value!)) {
          return null;
        }
        return "email is not in a valid format";
      },
      decoration: Themes.inputDecoration(
        ref,
        "email",
        "email@example.com",
      ),
      onSaved: (newValue) {
        email = newValue ?? "";
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
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
    auth.signInWithGoogle().then((value) {
      if (value != null &&
          value.user != null &&
          value.additionalUserInfo!.isNewUser) {
        String userId = value.user!.uid;
        ref.read(userProvider).addUser(
              userId: userId,
              username: value.user!.displayName!,
              email: value.user!.email!,
            );
        Navigator.of(context).pushNamed(
          CreateProfileScreen.routeName,
          arguments: userId,
        );
      }
    });
  }
}
