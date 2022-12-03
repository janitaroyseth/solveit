import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/styles/theme.dart';

/// Represents a project as a card.
class ProjectCard extends StatelessWidget {
  /// The project to display in a card.
  final Project project;

  /// Function called when tapping the card.
  final VoidCallback handler;

  /// Creates an instance of [ProjectCard].
  const ProjectCard({super.key, required this.project, required this.handler});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Themes.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 150,
          height: 75,
          child: InkWell(
            onTap: handler,
            child: Stack(
              children: <Widget>[
                _projectImage(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _projectTitle(),
                    const SizedBox(
                      height: 2.0,
                    ),
                    project.isPublic ? _publicLabel() : privateLabel(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns a [Text] widget displaying the title.
  Text _projectTitle() {
    return Text(
      project.title.toLowerCase(),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }

  /// Returns a "label" displaying that the project is private.
  Row privateLabel() {
    return Row(
      children: const <Widget>[
        Icon(
          PhosphorIcons.lockSimpleThin,
          color: Colors.white,
          size: 15,
        ),
        SizedBox(
          width: 2.0,
        ),
        Text(
          "private",
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  /// Returns a "label" displaying that the project is public.
  Row _publicLabel() {
    return Row(
      children: const <Widget>[
        Icon(
          PhosphorIcons.usersThin,
          color: Colors.white,
          size: 16,
        ),
        SizedBox(
          width: 2.0,
        ),
        Text(
          "public",
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  /// Returns the image of the project.
  Column _projectImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Image.asset(
          project.imageUrl,
          height: 67,
          alignment: Alignment.topRight,
        ),
      ],
    );
  }
}
