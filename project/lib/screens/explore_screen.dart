import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/project.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/settings_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/screens/project_preview_screen.dart';
import 'package:project/widgets/general/loading_spinner.dart';
import 'package:project/widgets/items/project_card.dart';
import 'package:project/widgets/inputs/search_bar.dart';
import 'package:project/widgets/items/user_list_item.dart';

/// Screen/Scaffold for searching users and projects.
class ExploreScreen extends ConsumerStatefulWidget {
  /// Named route for this screen.
  static const routeName = "/explore";

  /// Creates an instance of [ExploreScreen].
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _appBarBackground(ref),
          title: _searchBar(),
          bottom: _exploreTabBar(),
        ),
        body: _exploreTabView(),
      ),
    );
  }

  /// Returns a searchbar customized for explore screen.
  SearchBar _searchBar() {
    return SearchBar(
      placeholderText: "search users and projects",
      searchFunction: (String query) {
        setState(() {});
      },
      textEditingController: searchController,
    );
  }

  /// Returns the tab view for explore tab bar.
  TabBarView _exploreTabView() {
    return TabBarView(
      children: [
        _ExploreUsersView(searchController.text),
        _ExploreProjectsView(searchController.text),
      ],
    );
  }

  /// Tab bar displaying the options for explore screen.
  TabBar _exploreTabBar() {
    return const TabBar(
      tabs: <Tab>[
        Tab(text: "users"),
        Tab(text: "projects"),
      ],
    );
  }

  /// Returns the appropriate background color depending on the theme mode.
  Color _appBarBackground(WidgetRef ref) {
    return ref.watch(darkModeProvider)
        ? const Color.fromRGBO(21, 21, 21, 1)
        : Colors.transparent;
  }
}

/// View for exploring projects.
class _ExploreProjectsView extends ConsumerStatefulWidget {
  /// The query to search for.
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
      builder: (context, ref, child) => StreamBuilder<List<Project?>>(
        stream: ref.watch(projectProvider).searchProjects(widget.query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Project?> projects = snapshot.data!;

            return _projectsList(projects);
          }
          if (snapshot.hasError) print(snapshot.error);
          return const LoadingSpinner();
        },
      ),
    );
  }

  /// Returns grid view of the given list [projects].
  Widget _projectsList(List<Project?> projects) {
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
        itemBuilder: (context, index) =>
            _projectCard(projects[index]!, context),
      ),
    );
  }

  /// Returns project card of the given [projects].
  ProjectCard _projectCard(Project project, BuildContext context) {
    return ProjectCard(
      project: project,
      handler: () async => {
        ref.read(currentProjectProvider.notifier).setProject(
            ref.watch(projectProvider).getProject(project.projectId)),
        Navigator.of(context).pushNamed(
          ProjectPreviewScreen.routeName,
          arguments: project,
        ),
      },
    );
  }
}

/// View for exploring users.
class _ExploreUsersView extends ConsumerStatefulWidget {
  /// The query to search for.
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
      builder: (context, ref, child) => StreamBuilder<List<User?>>(
        stream: ref.watch(userProvider).searchUsers(widget.query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<User?> users = snapshot.data!;

            return userList(users);
          }
          if (snapshot.hasError) print(snapshot.error);
          return const LoadingSpinner();
        },
      ),
    );
  }

  /// Returns a list view of the given list [users].
  Padding userList(List<User?> users) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.6, horizontal: 8.0),
          child: _userListItem(users[index]!, context),
        ),
      ),
    );
  }

  /// Returns a [UserListItem] for the given [user].
  UserListItem _userListItem(User user, BuildContext context) {
    return UserListItem(
      user: user,
      handler: () {
        Navigator.of(context).pushNamed(
          ProfileScreen.routeName,
          arguments: user.userId,
        );
      },
    );
  }
}
