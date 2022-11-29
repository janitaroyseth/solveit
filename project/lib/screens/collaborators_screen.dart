import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/loading_spinner.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/widgets/user_list_item.dart';

enum CollaboratorsSearchType {
  collaborators,
  assignees,
}

/// Screen/Scaffold for picking a collaborator or a assignee.
class CollaboratorsScreen extends ConsumerStatefulWidget {
  /// Named route for this screen.
  static const routeName = "/collaborators";

  /// Creates an instance of [CollaboratorScreen].
  const CollaboratorsScreen({super.key});

  @override
  ConsumerState<CollaboratorsScreen> createState() =>
      _CollaboratorsScreenState();
}

class _CollaboratorsScreenState extends ConsumerState<CollaboratorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// List of collaborators or assigneed to add the selected user to.
    final List<User?> users =
        (ModalRoute.of(context)!.settings.arguments as List)[0] as List<User?>;

    /// The searchtype for the screen, whether to browse all users or just
    /// users in a project.
    final CollaboratorsSearchType? searchType =
        (ModalRoute.of(context)!.settings.arguments as List)[1] ??
            CollaboratorsSearchType.collaborators;

    /// The project id of the project to add collaborators too.
    final String projectId =
        (ModalRoute.of(context)!.settings.arguments as List)[2];

    /// Gets list of collaborators in a project, used for when
    /// picking an assignee as options should only be a collaborator.
    Stream<List<User>> getCollaborators() {
      return ref
          .watch(projectProvider)
          .getProject(projectId)
          .first
          .then((value) => value!.collaborators)
          .asStream();
    }

    /// Returns the appropriate [Stream<List<User>>] depending on the
    /// [searchType].
    Stream<List<User?>> getStream() {
      return searchType == CollaboratorsSearchType.collaborators
          ? ref.watch(userProvider).searchUsers(_searchController.text)
          : getCollaborators();
    }

    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(searchType),
        leading: _backButton(context),
      ),
      body: Column(
        children: <Widget>[
          _searchBar(searchType),
          _usersList(searchType, getStream, users)
        ],
      ),
    );
  }

  StreamBuilder<List<User?>> _usersList(
    CollaboratorsSearchType? searchType,
    Stream<List<User?>> Function() getStream,
    List<User?> users,
  ) {
    return StreamBuilder<List<User?>>(
      stream: getStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (User? user in users) {
            if (snapshot.data!.contains(user)) {
              snapshot.data!.remove(user);
            }
          }

          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                User user = snapshot.data![index]!;
                return _collaboratorsListItem(user, users, context);
              },
            ),
          );
        }
        return const LoadingSpinner();
      },
    );
  }

  /// List item for displaying user in collaborators list.
  Padding _collaboratorsListItem(
      User user, List<User?> users, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        0.0,
        16.0,
        0.0,
      ),
      child: UserListItem(
        user: user,
        handler: () {
          users.add(user);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  /// Searchbar customized for this screen.
  SearchBar _searchBar(CollaboratorsSearchType? searchType) {
    return SearchBar(
      placeholderText: "search for ${searchType!.name}",
      searchFunction: (String query) {
        setState(() {});
      },
      textEditingController: _searchController,
    );
  }

  /// Navigates to previous screen.
  AppBarButton _backButton(BuildContext context) {
    return AppBarButton(
      handler: () => Navigator.of(context).pop(),
      icon: PhosphorIcons.caretLeftLight,
      tooltip: "Go back",
    );
  }

  /// The title of the screen depending on the [searchType].
  Text _appBarTitle(CollaboratorsSearchType? searchType) {
    return Text(
      searchType == CollaboratorsSearchType.collaborators
          ? "add collaborator"
          : "add assignee",
    );
  }
}
