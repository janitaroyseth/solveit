import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/create_profile_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/input_field.dart';

class EditProfileScreen extends ConsumerWidget {
  static const String routeName = "/edit-profile";
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: AppBarButton(
          icon: PhosphorIcons.caretLeftLight,
          handler: () => Navigator.of(context).pop(),
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
      body: FutureBuilder(
        future: ref.watch(userProvider).getUser(
              ref.watch(authProvider).currentUser!.uid,
            ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data as User;
            return Column(
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
                          (image) {},
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
                    children: [
                      InputField(
                          label: "username", placeholderText: user.username),
                      const SizedBox(height: 8.0),
                      InputField(label: "bio", placeholderText: user.bio),
                    ],
                  ),
                ),
              ],
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
