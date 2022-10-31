import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/screens/create_project_screen.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/project_card.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/models/project.dart';

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
        centerTitle: true,
        title: const Text("solveit", textAlign: TextAlign.center),
        actions: [
          // TODO: Add action to button.
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
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: _buildProjectList(projects),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProjectList(List<Project> projects) {
    List<Widget> projectCards = [];
    for (Project project in projects) {
      projectCards.add(ProjectCard(project: project));
    }
    return projectCards;
  }
}
