import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/screens/project_preview_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';

import '../widgets/project_card.dart';

/// Screen/Scaffold for the profile of the user.
class ProfileScreen extends StatelessWidget {
  static const routeName = "/user";
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Project> projects =
        ModalRoute.of(context)!.settings.arguments as List<Project>;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Themes.primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              "solve",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              "it",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            )
          ],
        ),
        actions: [
          // TODO: Add action to button.
          AppBarButton(
            handler: () => showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              context: context,
              builder: (context) => const SizedBox(
                height: 400,
              ),
            ),
            tooltip: "Settings",
            icon: PhosphorIcons.list,
            color: Colors.white,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              color: Themes.primaryColor,
              height: 220,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  bottom: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 6,
                      backgroundImage: const AssetImage(
                        "assets/images/jane_cooper.png",
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "Jane Cooper",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4.0),
                          const Flexible(
                            child: Text(
                              "Hard working student ready for that 8-16 grind!",
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                overflow: TextOverflow.clip,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 36.0),
                          Row(
                            children: const <Widget>[
                              Text(
                                "3 ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "projects",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "3 ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "friends",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "3 ",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "stars",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ProfileTab(projects: projects),
        ],
      ),
    );
  }
}

class ProfileTab extends StatefulWidget {
  final List<Project> projects;

  const ProfileTab({super.key, required this.projects});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String projects = "projects";
  String starred = "starred";
  late String isSelected;
  @override
  void initState() {
    isSelected = projects;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: <Widget>[
                isSelected == projects
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isSelected = projects;
                          });
                        },
                        style: Themes.tertiaryElevatedButtonStyle,
                        child: Text(projects),
                      )
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            isSelected = projects;
                          });
                        },
                        child: Text(projects),
                      ),
                const SizedBox(width: 4.0),
                isSelected == starred
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isSelected = starred;
                          });
                        },
                        style: Themes.tertiaryElevatedButtonStyle,
                        child: Text(starred),
                      )
                    : TextButton(
                        style: Themes.textButtonStyle,
                        onPressed: () {
                          setState(() {
                            isSelected = starred;
                          });
                        },
                        child: Text(starred),
                      ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 120,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: widget.projects.length,
                itemBuilder: (context, index) => ProjectCard(
                    project: widget.projects[index],
                    handler: () => Navigator.of(context).pushNamed(
                        ProjectPreviewScreen.routeName,
                        arguments: widget.projects[index])),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
