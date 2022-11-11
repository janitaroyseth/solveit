import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/screens/create_project_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/project_card.dart';
import 'package:project/widgets/search_bar.dart';

/// Screen/Scaffold for the overview of projects the user have access to.
class ProjectOverviewScreen extends StatelessWidget {
  static const routeName = "/project-overview";

  const ProjectOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Project> projects =
        ModalRoute.of(context)!.settings.arguments as List<Project>;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
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
                color: Themes.primaryColor,
              ),
            )
          ],
        ),
        actions: [
          AppBarButton(
              handler: () => Navigator.of(context)
                  .pushNamed(CreateProjectScreen.routeName),
              tooltip: "Add new project",
              icon: PhosphorIcons.plus)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            SearchBar(
              placeholderText: "search for project",
              searchFunction: () {},
              textEditingController: TextEditingController(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 120,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: projects.length,
                  itemBuilder: (context, index) => ProjectCard(
                    project: projects[index],
                    handler: () => Navigator.of(context).pushNamed(
                        TaskOverviewScreen.routeName,
                        arguments: projects[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
