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

class EditProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = "/edit-profile";
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState {
  void saveUserImage(image, String userId, User user) {
    ref.read(userImageProvider).updateUserImage(userId, image!).then((value) {
      user.imageUrl = value;
      return ref.read(userProvider).updateUser(userId, user);
    }); /*.then(
      (value) => setState(() {}),
    );*/
  }

  void saveUsername(String userId, User user, String username) {
    user.username = username;
    ref.read(userProvider).updateUser(userId, user);
    //.then((value) => setState(() {}));
  }

  void saveBio(String userId, User user, String bio) {
    user.bio = bio;
    ref.read(userProvider).updateUser(userId, user);
    //.then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final String userId = ref.watch(authProvider).currentUser!.uid;
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
        title: const Text(
          "edit profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
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
                  ClipPath(
                    clipper: CurveClipper(),
                    child: Container(
                      height: 300,
                      color: Themes.primaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          PickProfilePicture(
                            (image) => saveUserImage(image, userId, user),
                            imageUrl: user.imageUrl,
                            label: "edit profile picture",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          decoration: Themes.textFieldStyle(
                            "username",
                            user.username,
                          ),
                          readOnly: true,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => _EditFieldSceen(
                                  label: "name",
                                  value: user.username,
                                  onSave: (newValue) =>
                                      saveUsername(userId, user, newValue),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8.0),
                        TextField(
                          readOnly: true,
                          decoration: Themes.textFieldStyle(
                            "bio",
                            user.bio,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => _EditFieldSceen(
                                  label: "bio",
                                  value: user.bio,
                                  onSave: (newValue) =>
                                      saveBio(userId, user, newValue),
                                ),
                              ),
                            );
                          },
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
}

class _EditFieldSceen extends StatefulWidget {
  _EditFieldSceen({
    required this.label,
    required this.value,
    required this.onSave,
  });
  final String label;
  final String value;
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: _fieldController,
          decoration:
              Themes.textFieldStyle(widget.label, widget.value).copyWith(),
        ),
      ),
    );
  }
}
