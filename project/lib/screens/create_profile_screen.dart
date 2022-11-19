import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/example_data.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/widgets/image_picker_modal.dart';

/// Scaffold/Screen for creating profile after signing up.
class CreateProfileScreen extends ConsumerWidget {
  static const routeName = "/create-profile";

  /// Creates an instance of create-profile-screen.
  const CreateProfileScreen({super.key});

  Future<User?> getNewUser(String userId, WidgetRef ref) async {
    ref.watch(userProvider).getUser(userId);
  }

  void updateNewUser(
      WidgetRef ref, String userId, String email, String username, String bio) {
    User user =
        User(userId: userId, username: username, email: email, bio: bio);
    ref.read(userProvider).updateUser(userId, user);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String userId = ModalRoute.of(context)!.settings.arguments as String;
    User? user;
    // User? user = ref.watch(userProvider).getUser(userId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Themes.primaryColor,
        elevation: 0,
        leading: AppBarButton(
          handler: () => Navigator.of(context).pop(),
          icon: PhosphorIcons.caretLeftLight,
          tooltip: "Go back to sign in page",
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: ref.watch(userProvider).getUser(userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    user = snapshot.data as User?;
                  }
                  return ClipPath(
                    clipper: CurveClipper(),
                    child: Container(
                      height: 400,
                      color: const Color.fromRGBO(92, 0, 241, 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              appTitle(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: Themes.fontFamily,
                                    ),
                                    children: <InlineSpan>[
                                      const TextSpan(text: "hi "),
                                      TextSpan(
                                        text: "${user!.username}, ",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(
                                        text:
                                            "here you can set up your profile",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const _PickProfilePicture(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                minLines: 4,
                maxLines: 10,
                decoration: InputDecoration(
                  label: Text("bio"),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Themes.primaryColor,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateNewUser(ref, userId, user!.email, user!.username, user!.bio);
          //Navigator.of(context).pop();
          Navigator.of(context).popAndPushNamed(
            HomeScreen.routeName,
            arguments: {
              "user": ExampleData.user1,
              "projects": ExampleData.projects
            },
          );
        },
        child: const Icon(
          PhosphorIcons.arrowRight,
          color: Colors.white,
        ),
      ),
    );
  }

  Row appTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Text(
          "solve",
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          "it",
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Displaying the profile picture chosen by the user and a button for
/// changing profile picture.
class _PickProfilePicture extends StatefulWidget {
  /// Creates in instance of [_PickProfilePicture] that displays the
  /// profile picture chosen and a button for changing profile picture.
  const _PickProfilePicture();

  @override
  State<_PickProfilePicture> createState() => _PickProfilePictureState();
}

class _PickProfilePictureState extends State<_PickProfilePicture> {
  /// Profile picture chosen, if none chosen is null.
  File? image;

  /// Sets the picked image to the profile picture image.
  void imageHandler(File pickedImage) {
    setState(() {
      image = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        image == null
            ? Image.asset(
                "assets/images/profile_placeholder.png",
                height: 200,
              )
            : CircleAvatar(
                radius: 100,
                backgroundImage: FileImage(image!),
              ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            context: context,
            builder: (context) => ImagePickerModal(
              handler: imageHandler,
              buildContext: context,
            ),
          ),
          style: Themes.secondaryElevatedButtonStyle,
          child: const Text("add profile picture"),
        ),
      ],
    );
  }
}
