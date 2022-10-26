import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/screens/project_overview_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';

/// Scaffold/Screen for creating profile after signing up.
class CreateProfileScreen extends StatelessWidget {
  static const routeName = "/create-profile";

  /// Creates an instance of create-profile-screen.
  const CreateProfileScreen({super.key});

  /// Returns the [Widget] containing the image uploading options.
  Widget imageOptionModal() {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 3,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () => print("taking picture with camera..."),
              child: Row(
                children: const <Widget>[
                  Icon(
                    PhosphorIcons.cameraLight,
                    size: 32,
                  ),
                  SizedBox(width: 8),
                  Text("take picture")
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            InkWell(
              onTap: () => print("uploading image from storage..."),
              child: Row(
                children: const <Widget>[
                  Icon(
                    PhosphorIcons.imageLight,
                    size: 32,
                  ),
                  SizedBox(width: 8),
                  Text("upload image")
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            InkWell(
              onTap: () => print("uploading image from url..."),
              child: Row(
                children: const <Widget>[
                  Icon(
                    PhosphorIcons.linkLight,
                    size: 32,
                  ),
                  SizedBox(width: 8),
                  Text("image url")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      body: Stack(
        children: <Widget>[
          Column(
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
                          Image.asset(
                            "assets/images/empty_profile_pic_large.png",
                            height: 200,
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
                              builder: (context) => imageOptionModal(),
                            ),
                            style: Themes.secondaryButtonStyle,
                            child: const Text("add profile picture"),
                          ),
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
        ],
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
