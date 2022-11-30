import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/project_preview_screen.dart';
import 'package:project/widgets/loading_spinner.dart';
import 'package:project/widgets/project_card.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/widgets/user_list_item.dart';

/// Screen/Scaffold for searching users and projects.
class ExploreScreen extends StatefulWidget {
  /// Named route for this screen.
  static const routeName = "/explore";

  /// Creates an instance of [ExploreScreen].
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: SearchBar(
            placeholderText: "search users and projects",
            searchFunction: (String query) {
              setState(() {});
            },
            textEditingController: searchController,
          ),
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(text: "users"),
              Tab(text: "projects"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ExploreProjectsView(searchController.text),
            _ExploreUsersView(searchController.text),
          ],
        ),
      ),
    );
  }
}

class _ExploreUsersView extends ConsumerStatefulWidget {
  final String query;

  /// Creates an instance of [_ExploreUsersView],
  const _ExploreUsersView(this.query);

  @override
  ConsumerState<_ExploreUsersView> createState() => _ExploreUsersViewState();
}

class _ExploreUsersViewState extends ConsumerState<_ExploreUsersView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => StreamBuilder<List<Project?>>(
        stream: ref.watch(projectProvider).searchProjects(widget.query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Project?> projects = snapshot.data!;

            return Padding(
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
                  project: projects[index]!,
                  handler: () async => {
                    ref.read(currentProjectProvider.notifier).setProject(ref
                        .watch(projectProvider)
                        .getProject(projects[index]!.projectId)),
                    Navigator.of(context).pushNamed(
                        ProjectPreviewScreen.routeName,
                        arguments: projects[index]!.projectId),
                  },
                ),
              ),
            );
          }
          if (snapshot.hasError) print(snapshot.error);
          return const LoadingSpinner();
        },
      ),
    );
  }
}

class _ExploreProjectsView extends ConsumerStatefulWidget {
  final String query;

  /// Creates an instance of [_ExploreProjectsView],
  const _ExploreProjectsView(this.query);

  @override
  ConsumerState<_ExploreProjectsView> createState() =>
      _ExploreProjectsViewState();
}

class _ExploreProjectsViewState extends ConsumerState<_ExploreProjectsView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => StreamBuilder<List<User?>>(
        stream: ref.watch(userProvider).searchUsers(widget.query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User?> users = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.6, horizontal: 8.0),
                  child: UserListItem(user: users[index]!, handler: () {}),
                ),
              ),
            );
          }
          if (snapshot.hasError) print(snapshot.error);
          return const LoadingSpinner();
        },
      ),
    );
  }
}
