import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:solveit/widgets/appbar_button.dart';
import 'package:solveit/widgets/project_card.dart';
import 'package:solveit/widgets/search_bar.dart';

/// Screen/Scaffold for the overview of projects the user have access to.
class ProjectOverviewScreen extends StatelessWidget {
  static const routeName = "/project-overview";

  const ProjectOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("solveit", textAlign: TextAlign.center),
        actions: [
          // TODO: Add action to button.
          AppBarButton(
              handler: () {},
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
              filterModal: const SizedBox(),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: const [
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                    ProjectCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
