import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/user_images_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/create_profile_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';

/// Screen/Scaffold for updating a users profile page.
class EditProfileScreen extends ConsumerWidget {
  /// Named route for this screen.
  static const String routeName = "/edit-profile";

  /// Creates an instance of [EditProfileScreen].
  const EditProfileScreen({super.key});

  /// Adds the given [image] to the given [user] with the given [userId] and persits
  /// the image for the user.
  void saveUserImage(image, WidgetRef ref, String userId, User user) {
    ref.read(userImageProvider).updateUserImage(userId, image!).then((value) {
      user.imageUrl = value;
      return ref.read(userProvider).updateUser(userId, user);
    });
  }

  /// Updates the [username] of the given [user] with the given [userId] to the
  /// given [username].
  void saveUsername(String userId, WidgetRef ref, User user, String username) {
    user.username = username;
    ref.read(userProvider).updateUser(userId, user);
  }

  /// Updates the [bio] of the given [user] with the given [userId] to the
  /// given [bio].
  void saveBio(String userId, WidgetRef ref, User user, String bio) {
    user.bio = bio;
    ref.read(userProvider).updateUser(userId, user);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userId = ref.watch(authProvider).currentUser!.uid;

    /// Opens the [_EditFieldScreen] for updating
    /// the username.
    void updateUsername(User user) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _EditFieldSceen(
            label: "name",
            value: user.username,
            onSave: (newValue) => saveUsername(userId, ref, user, newValue),
          ),
        ),
      );
    }

    /// Opens the [_EditFieldScreen] for updating
    /// the bio.
    void updateBio(User user) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _EditFieldSceen(
            label: "bio",
            value: user.bio,
            onSave: (newValue) => saveBio(userId, ref, user, newValue),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: AppBarButton(
          icon: PhosphorIcons.caretLeftLight,
          handler: () {
            Navigator.of(context).pop();
          },
          tooltip: "Go back",
          color: Colors.white,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Themes.primaryColor,
        title: Text(
          "edit profile",
          style: Theme.of(context)
              .appBarTheme
              .titleTextStyle!
              .copyWith(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: ref.watch(userProvider).getUser(userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data as User;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  updateProfilePictureSection(ref, userId, user),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          decoration: Themes.inputDecoration(
                              ref, "username", user.username),
                          readOnly: true,
                          onTap: () => updateUsername(user),
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          readOnly: true,
                          minLines: 1,
                          maxLines: 4,
                          decoration:
                              Themes.inputDecoration(ref, "bio", user.bio),
                          onTap: () => updateBio(user),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ClipPath updateProfilePictureSection(
      WidgetRef ref, String userId, User user) {
    return ClipPath(
      clipper: CurveClipper(),
      child: Container(
        height: 300,
        color: Themes.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PickProfilePicture(
              (image) => saveUserImage(image, ref, userId, user),
              imageUrl: user.imageUrl,
              label: "edit profile picture",
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen/Scaffold for updating fields used for editing profile.
class _EditFieldSceen extends StatefulWidget {
  /// Creates an instance of [_EditFieldScreen].
  const _EditFieldSceen({
    required this.label,
    required this.value,
    required this.onSave,
  });

  /// The [String] label for the field to edit.
  final String label;

  /// The [String] value to already exist for the field.
  final String value;

  /// Function to call when saving the field.
  final Function onSave;

  @override
  State<_EditFieldSceen> createState() => _EditFieldSceenState();
}

class _EditFieldSceenState extends State<_EditFieldSceen> {
  final TextEditingController _fieldController = TextEditingController();

  @override
  void initState() {
    _fieldController.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
        leading: AppBarButton(
          icon: PhosphorIcons.xLight,
          handler: () {
            Navigator.of(context).pop();
          },
          tooltip: "Cancel",
        ),
        actions: [
          AppBarButton(
            handler: () {
              widget.onSave(_fieldController.text);
              Navigator.of(context).pop();
            },
            tooltip: "Save",
            icon: PhosphorIcons.checkLight,
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _fieldController,
            minLines: 1,
            maxLines: 4,
            maxLength: 200,
            style: Themes.textTheme(ref).bodyMedium,
            decoration: Themes.inputDecoration(ref, widget.label, widget.value),
          ),
        ),
      ),
    );
  }
}
