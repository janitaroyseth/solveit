import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/screens/project_overview_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/image_picker_modal.dart';

/// Scaffold/Screen for creating profile after signing up.
class CreateProfileScreen extends StatelessWidget {
  static const routeName = "/create-profile";

  /// Creates an instance of create-profile-screen.
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(92, 0, 241, 1),
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
            ClipPath(
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
                        Row(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: Themes.fontFamily,
                              ),
                              children: <InlineSpan>[
                                TextSpan(text: "hi "),
                                TextSpan(
                                  text: "Jane, ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "here you can set up your profile",
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
            ),
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
        onPressed: () => Navigator.of(context)
            .pushReplacementNamed(ProjectOverviewScreen.routeName),
        child: const Icon(
          PhosphorIcons.arrowRight,
          color: Colors.white,
        ),
      ),
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
                "assets/images/empty_profile_pic_large.png",
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
            builder: (context) => ImagePickerModal(handler: imageHandler),
          ),
          style: Themes.secondaryButtonStyle,
          child: const Text("add profile picture"),
        ),
      ],
    );
  }
}
