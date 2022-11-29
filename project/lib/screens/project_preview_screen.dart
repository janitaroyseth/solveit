import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/styles/curve_clipper.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/project_pop_up_menu.dart';
import 'package:project/widgets/user_list_item.dart';

/// Scaffold/screen displaying a preview of the project with
/// description and collaborators.
class ProjectPreviewScreen extends ConsumerWidget {
  static const routeName = "/project-preview";

  /// Creates an instance of [ProjectPreviewScreen].
  const ProjectPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Project project;
    return StreamBuilder<Project?>(
      stream: ref.watch(currentProjectProvider),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          project = snapshot.data!;
        } else {
          project = Project();
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: _backButton(context),
            actions: <Widget>[
              ProjectPopUpMenu(
                project: project,
                currentRouteName: "/project-preview",
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipPath(
                  clipper: CurveClipper(),
                  child: Container(
                    height: 370,
                    width: double.infinity,
                    color: const Color.fromRGBO(92, 0, 241, 1),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 40),
                        _projectImage(project),
                        _projectTitle(project),
                      ],
                    ),
                  ),
                ),
                _projectDescription(project),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _collaboratorsList(context, project),
                      const SizedBox(height: 24.0),
                      _projectLastUpdated(project),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// Displaying when the project was last updated.
  Column _projectLastUpdated(Project project) {
    return Column(
      children: [
        const Text(
          "last updated",
          style: TextStyle(
            //fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          project.lastUpdated != null && project.lastUpdated!.isNotEmpty
              ? Jiffy(project.lastUpdated)
                  .format("EEEE, MMMM do yyyy")
                  .toLowerCase()
              : "never updated",
        )
      ],
    );
  }

  /// Column containing list of collaborators.
  Column _collaboratorsList(BuildContext context, Project project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "collaborators",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        ...project.collaborators.map(
          (user) {
            return UserListItem(
              user: user,
              isOwner: project.owner == user.userId,
              handler: () => Navigator.of(context).pushNamed(
                ProfileScreen.routeName,
                arguments: {
                  "user": user.userId,
                  "projects": <Project>[],
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// The description of the project.
  Padding _projectDescription(Project project) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 16.0,
      ),
      child: Text(
        project.description,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// The title of the project.
  Text _projectTitle(Project project) {
    return Text(
      project.title.toLowerCase(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
      ),
    );
  }

  /// Image displaying the project avatar.
  Image _projectImage(Project project) {
    return Image.asset(
      project.imageUrl,
      height: 250,
    );
  }

  /// Button goign back to previous screen.
  AppBarButton _backButton(BuildContext context) {
    return AppBarButton(
      icon: PhosphorIcons.caretLeftLight,
      handler: () => Navigator.of(context).pop(),
      tooltip: "Go back",
      color: Colors.white,
    );
  }
}
