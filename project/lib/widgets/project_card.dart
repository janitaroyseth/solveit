import 'package:flutter/material.dart';
import 'package:project/screens/project_preview_screen.dart';
import 'package:project/static_data/example_data.dart';

/// Represents a project as a card used on project screen.
class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        ProjectPreviewScreen.routeName,
        arguments: ExampleData.projects[0],
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 150,
            height: 75,
            child: Column(
              children: [
                Row(
                  children: const [
                    Text("Title", textAlign: TextAlign.left),
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
