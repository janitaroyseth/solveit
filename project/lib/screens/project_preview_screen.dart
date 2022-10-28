import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import 'package:project/static_data/example_data.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/user_list_item.dart';

/// Scaffold/screen displaying a preview of the project with
/// description and collaborators.
class ProjectPreviewScreen extends StatelessWidget {
  static const routeName = "/project-preview";

  /// Creates an instance of [ProjectPreviewScreen].
  const ProjectPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Project project = ModalRoute.of(context)!.settings.arguments as Project;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: AppBarButton(
          icon: PhosphorIcons.caretLeftLight,
          handler: () {},
          tooltip: "Go back",
          color: Colors.white,
        ),
        actions: <Widget>[
          _ProjectPopUpMenu(project: project),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: CurveClipper(),
              child: Container(
                height: 420,
                width: double.infinity,
                color: const Color.fromRGBO(92, 0, 241, 1),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 60),
                    Image.asset(
                      project.imageUrl,
                      height: 270,
                    ),
                    Text(
                      project.title.toLowerCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 16.0,
              ),
              child: Text(
                project.description,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    "collaborators",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  UserListItem(
                    handler: () => Navigator.of(context)
                        .pushNamed(ProfileScreen.routeName),
                    name: "Jane Cooper",
                    imageUrl: "assets/images/jane_cooper.png",
                    isOwner: true,
                  ),
                  UserListItem(
                    handler: () => Navigator.of(context)
                        .pushNamed(ProfileScreen.routeName),
                    name: "Leslie Alexander",
                    imageUrl: "assets/images/leslie_alexander.png",
                  ),
                  UserListItem(
                    handler: () => Navigator.of(context)
                        .pushNamed(ProfileScreen.routeName),
                    name: "Guy Hawkins",
                    imageUrl: "assets/images/guy_hawkins.png",
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  const Text(
                    "collaborators",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    project.lastUpdated != null &&
                            project.lastUpdated!.isNotEmpty
                        ? Jiffy("31/10/2022", "dd/MM/yyyy")
                            .format("EEEE, MMMM do yyyy")
                            .toLowerCase()
                        : "never updated",
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ProjectPopUpMenu extends StatefulWidget {
  final Project project;
  const _ProjectPopUpMenu({required this.project});

  @override
  State<_ProjectPopUpMenu> createState() => __ProjectPopUpMenuState();
}

class __ProjectPopUpMenuState extends State<_ProjectPopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        PhosphorIcons.dotsThreeVertical,
        color: Colors.white,
        size: 34,
      ),
      tooltip: "Menu for project",
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          height: 48,
          child: Text("edit project"),
        ),
        PopupMenuItem(
          value: 1,
          height: 48,
          onTap: () {
            Future.delayed(
              const Duration(seconds: 0),
              () => Navigator.of(context).pushReplacementNamed(
                TaskOverviewScreen.routeName,
                arguments: widget.project,
              ),
            );
          },
          child: const Text("go to tasks"),
        ),
        PopupMenuItem(
          value: 2,
          height: 48,
          onTap: () {
            Future.delayed(
              const Duration(seconds: 0),
              () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    "deleting project",
                  ),
                  content: Text(
                    "Are you sure you want to delete the project \"${widget.project.title.toLowerCase()}\"",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: const Text("no"),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "yes",
                        style: TextStyle(
                          color: Colors.red.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Text(
            "delete projext",
            style: TextStyle(color: Colors.red.shade900),
          ),
        ),
      ],
    );
  }
}
