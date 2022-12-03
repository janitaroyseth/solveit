import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/user_images_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/modals/image_picker_modal.dart';
import 'package:project/widgets/general/loading_spinner.dart';

/// Scaffold/Screen for creating profile after signing up.
class CreateProfileScreen extends ConsumerWidget {
  /// Named route for this screen.
  static const routeName = "/create-profile";

  /// Creates an instance of create-profile-screen.
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// The text editing controller for the bio field
    TextEditingController bioController = TextEditingController();

    /// The user id of the user to create profile for.
    String userId = ModalRoute.of(context)!.settings.arguments as String;

    /// The image to upload for the profile picture.
    File? image;

    /// Sets the given picked image to the image.
    void imagePicker(File? pickedImage) {
      image = pickedImage;
    }

    /// Updates the new user's info.
    Future<void> updateNewUser(
      WidgetRef ref,
      String userId,
    ) async {
      User? user = await ref.watch(userProvider).getUser(userId).first;

      if (user != null) {
        user.bio = bioController.text;

        if (image != null) {
          user.imageUrl =
              await ref.read(userImageProvider).addUserImage(userId, image!);
          //await ref.read(userProvider).addProfilePictre(userId, image!);
        }

        return ref.read(userProvider).updateUser(userId, user);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Themes.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<User?>(
              stream: ref.watch(userProvider).getUser(userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User user = snapshot.data!;
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
                              _welcomeText(user),
                              const SizedBox(height: 16),
                              PickProfilePicture(
                                imagePicker,
                                label: "Add profile picture",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const LoadingSpinner();
              },
            ),
            _bioInputField(bioController),
          ],
        ),
      ),
      floatingActionButton:
          _continueButton(updateNewUser, ref, userId, context),
    );
  }

  /// Displays text welcoming the user by their name.
  Padding _welcomeText(User user) {
    return Padding(
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
              text: "${user.username}, ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
              text: "here you can set up your profile",
            ),
          ],
        ),
      ),
    );
  }

  /// Text form field for adding a bio to the profile
  Padding _bioInputField(TextEditingController bioController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        minLines: 4,
        maxLines: 10,
        controller: bioController,
        decoration: const InputDecoration(
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
    );
  }

  /// Continues to home screen after user has set up profile.
  FloatingActionButton _continueButton(
      Future<void> Function(WidgetRef ref, String userId) updateNewUser,
      WidgetRef ref,
      String userId,
      BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          updateNewUser(ref, userId).then((value) {
            Navigator.of(context).pop();
          });
        });
      },
      child: const Icon(
        PhosphorIcons.arrowRight,
        color: Colors.white,
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
class PickProfilePicture extends StatefulWidget {
  /// Creates in instance of [PickProfilePicture] that displays the
  /// profile picture chosen and a button for changing profile picture.
  const PickProfilePicture(this.imageHandler,
      {super.key, required this.label, this.imageUrl});

  final void Function(File? image) imageHandler;
  final String label;
  final String? imageUrl;

  @override
  State<PickProfilePicture> createState() => _PickProfilePictureState();
}

class _PickProfilePictureState extends State<PickProfilePicture> {
  /// Profile picture chosen, if none chosen is null.
  File? image;

  /// Sets the picked image to the profile picture image.
  void imageHandler(File pickedImage) {
    if (mounted) {
      setState(() {
        image = pickedImage;
        widget.imageHandler(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (widget.imageUrl != null)
          CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage(widget.imageUrl!),
          )
        else if (image == null)
          Image.asset(
            "assets/images/profile_placeholder.png",
            height: 200,
          )
        else
          CircleAvatar(
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
            builder: (dialogContext) => ImagePickerModal(
              handler: imageHandler,
              buildContext: context,
            ),
          ),
          style: Themes.secondaryElevatedButtonStyle,
          child: Text(widget.label.toLowerCase()),
        ),
      ],
    );
  }
}
