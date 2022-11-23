import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/screens/edit_project_screen.dart';
import 'package:project/screens/task_overview_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/project_card.dart';
import 'package:project/widgets/search_bar.dart';

import '../models/project.dart';

/// Screen/Scaffold for the overview of projects the user have access to.
class ProjectOverviewScreen extends ConsumerStatefulWidget {
  static const routeName = "/project-overview";

  const ProjectOverviewScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ProjectOverviewScreenState();
}

class ProjectOverviewScreenState extends ConsumerState<ProjectOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
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
                color: Themes.primaryColor.shade50,
              ),
            )
          ],
        ),
        actions: const [CreateProjectButton()],
      ),
      body: StreamBuilder(
          stream: ref
              .watch(projectProvider)
              .getProjectsByUserId(ref.watch(authProvider).currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              print("Projects: $data");
              List<Project> projects = data as List<Project>;
              return Padding(
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 120,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: projects.length,
                          itemBuilder: (context, index) => ProjectCard(
                              project: projects[index],
                              handler: () async => {
                                    ref
                                        .read(currentProjectProvider.notifier)
                                        .setProject((await ref
                                            .read(projectProvider)
                                            .getProject(
                                                projects[index].projectId))!),
                                    Navigator.of(context).pushNamed(
                                        TaskOverviewScreen.routeName,
                                        arguments: projects[index].projectId),
                                  }),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class CreateProjectButton extends StatefulWidget {
  const CreateProjectButton({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateProjectButton> createState() => _CreateProjectButtonState();
}

class _CreateProjectButtonState extends State<CreateProjectButton> {
  @override
  Widget build(BuildContext context) {
    return AppBarButton(
      handler: () {
        Navigator.of(context).pushNamed(EditProjectScreen.routeName);
        setState(() {});
      },
      tooltip: "Add new project",
      icon: PhosphorIcons.plus,
    );
  }
}
