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
              SizedBox(height: MediaQuery.of(context).size.height / 8),
              appTitle(),
              const SizedBox(height: 60),
              const _SignInForm(),
            ],
          ),
        ),
      ),
    );
  }

  FittedBox appTitle() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            "solve",
            style: TextStyle(
              fontSize: 40,
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            "it",
            style: TextStyle(
              fontSize: 40,
              color: Themes.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
  bool signupMode = false;
  late AuthService auth;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          signupMode ? "sign up" : "login",
          style: const TextStyle(
            fontSize: 20,
            color: Themes.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        const InputField(
          label: "email",
          placeholderText: "email@example.com",
          keyboardAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
        ),
        if (signupMode)
          Column(
            children: <Widget>[
              inputFieldPadding(),
              const InputField(
                label: "name",
                placeholderText: "john doe",
                isPassword: true,
                keyboardAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        inputFieldPadding(),
        const InputField(
          label: "password",
          placeholderText: "password",
          isPassword: true,
          keyboardAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
        ),
        if (signupMode)
          Column(
            children: <Widget>[
              inputFieldPadding(),
              const InputField(
                label: "confirm password",
                placeholderText: "confirm password",
                isPassword: true,
                keyboardAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        const SizedBox(height: 24),
        signinButton(context),
        const SizedBox(height: 48),
        signupMode
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
            facebookLoginButton(),
            googleLoginButton(),
            appleLoginButton(context),
          ],
        ),
        const SizedBox(height: 20),
        changeFormModeButton(),
      ],
    );
  }

  SizedBox inputFieldPadding() => const SizedBox(height: 6);

  ElevatedButton signinButton(BuildContext context) {
    return ElevatedButton(
      onPressed: signupMode
          ? () => Navigator.of(context).pushNamed(CreateProfileScreen.routeName)
          : () => Navigator.of(context).popAndPushNamed(
                HomeScreen.routeName,
                arguments: {
                  "user": user,
                  "projects": projects,
                },
              ),
      style: Themes.primaryElevatedButtonStyle,
      child: Text(signupMode ? "sign up" : "sign in"),
    );
  }

  ElevatedButton facebookLoginButton() {
    return ElevatedButton(
      onPressed: _signInAnonymously,
      style: Themes.circularButtonStyle,
      child: const Icon(
        PhosphorIcons.facebookLogo,
        size: 36,
      ),
    );
  }

  ElevatedButton googleLoginButton() {
    return ElevatedButton(
      onPressed: _signInWithGoogle,
      style: Themes.circularButtonStyle,
      child: const Icon(
        PhosphorIcons.googleLogo,
        size: 36,
      ),
    );
  }

  ElevatedButton appleLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: signupMode
          ? () => Navigator.of(context).pushNamed(CreateProfileScreen.routeName)
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
    );
  }

  FittedBox changeFormModeButton() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: signupMode
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("already have an account?"),
                TextButton(
                  style: Themes.textButtonStyle,
                  child: const Text("sign in here >"),
                  onPressed: () => setState(() => signupMode = false),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("don't have an account?"),
                TextButton(
                  style: Themes.textButtonStyle,
                  child: const Text("sign up here >"),
                  onPressed: () => setState(() => signupMode = true),
                ),
              ],
            ),
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
