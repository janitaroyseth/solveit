import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/example_data.dart';
import 'package:project/models/project.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/project_preview_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/styles/theme.dart';
import 'package:project/screens/user_settings_screen.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/modal_list_item.dart';

import '../widgets/project_card.dart';

/// Screen/Scaffold for the profile of the user.
class ProfileScreen extends ConsumerWidget {
  static const routeName = "/user";
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Project> projects = ExampleData.projects;
    final Future<User?> user = ref
        .watch(userProvider)
        .getUser(ref.watch(authProvider).currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Themes.primaryColor,
        title: appBarTitle(),
        actions: [profileMenuButton(context, ref)],
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
                child: FutureBuilder<User?>(
                  future: user,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width / 6,
                            backgroundImage:
                                NetworkImage(snapshot.data!.imageUrl!),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data!.username,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4.0),
                                Flexible(
                                  child: Text(
                                    snapshot.data!.bio,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
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
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
          _ProfileProjectList(projects: projects),
        ],
      ),
    );
  }

  AppBarButton profileMenuButton(BuildContext context, WidgetRef ref) {
    return AppBarButton(
      handler: () => showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (context) => Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
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
                const SizedBox(height: 4.0),
                ModalListItem(
                  icon: PhosphorIcons.userCircleGearLight,
                  label: "edit profile",
                  handler: () {},
                ),
                ModalListItem(
                  icon: PhosphorIcons.gearSixLight,
                  label: "settings",
                  handler: () {
                    Navigator.of(context).pushNamed(
                      UserSettingsScreen.routeName,
                    );
                  },
                ),
                ModalListItem(
                  icon: PhosphorIcons.signOutLight,
                  label: "log out",
                  handler: () {
                    Navigator.of(context).pop();
                    _logout(ref);
                  },
                ),
                ModalListItem(
                  handler: () => showDialog(
                    context: context,
                    builder: (context) => const AboutDialog(
                      applicationLegalese:
                          "Copyright © 2022 NTNU, IDATA2503 Group 3 - Espen, Sakarias and Janita",
                      applicationVersion: "version 0.0.1",
                      applicationName: "solveit",
                    ),
                  ),
                  icon: PhosphorIcons.infoLight,
                  label: "app info",
                ),
              ],
            ),
          ),
        ),
      ),
      tooltip: "Settings",
      icon: PhosphorIcons.list,
      color: Colors.white,
    );
  }

  Row appBarTitle() {
    return Row(
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
    );
  }

  /// Logging the user out.
  void _logout(WidgetRef ref) {
    final auth = ref.read(authProvider);
    auth.signOut();
  }
}

class _ProfileProjectList extends StatefulWidget {
  final List<Project> projects;

  const _ProfileProjectList({super.key, required this.projects});

  @override
  State<_ProfileProjectList> createState() => _ProfileProjectListState();
}

class _ProfileProjectListState extends State<_ProfileProjectList> {
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
                        style: Themes.softPrimaryElevatedButtonStyle,
                        child: Text(projects),
                      )
                    : TextButton(
                        style: Themes.textButtonStyle,
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
                        style: Themes.softPrimaryElevatedButtonStyle,
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
