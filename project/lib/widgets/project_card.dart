import 'package:flutter/material.dart';
import 'package:project/models/project.dart';

/// Represents a project as a card used on project screen.
class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 150,
          height: 75,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/tasks', arguments: project);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Text(project.title, textAlign: TextAlign.left),
                  ],
                ),
                const Text(
                  "Laboris non cillum consectetur reprehenderit quis labore nisi elit.",
                  style: TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
