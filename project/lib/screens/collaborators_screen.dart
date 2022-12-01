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
  /// Textediting controller for the search field.
  final TextEditingController _searchController = TextEditingController();

  /// List of collaborators or assignees to add the selected user to.
  late List<String?> users;

  /// The searchtype for the screen, whether to browse all users or just
  /// users in a project.
  late CollaboratorsSearchType? searchType;

  /// The project id of the project to add collaborators too.
  late String? projectId;

  /// Filters through the listt of all users and only leaves users that is
  /// not already currently in a collaborator or assignee list.
  List<User?> _filterCollaborators(List<User?>? allUsers) {
    return allUsers!
        .where((element) => !users.contains(element!.userId))
        .toList();
  }

  /// Returns list of collaborators in a project, removes users which are assigned
  /// to the current task.
  Stream<List<User>> _getCollaborators() {
    return ref
        .watch(projectProvider)
        .getProject(projectId!)
        .first
        .then((value) {
      List<User> collaborators = [];

      for (var userId in value!.collaborators) {
        ref.watch(userProvider).getUser(userId).first.then((user) {
          collaborators.add(user!);
        });
      }
      return collaborators;
    }).asStream();
  }

  /// Returns the appropriate [Stream<List<User>>] depending on the
  /// [searchType].
  Stream<List<User?>> _getStream() {
    return searchType == CollaboratorsSearchType.collaborators
        ? ref.watch(userProvider).searchUsers(_searchController.text)
        : _getCollaborators();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    users = (ModalRoute.of(context)!.settings.arguments as List)[0]
        as List<String?>;
    searchType = (ModalRoute.of(context)!.settings.arguments as List)[1] ??
        CollaboratorsSearchType.collaborators;
    projectId = (ModalRoute.of(context)!.settings.arguments as List)[2];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(searchType),
        leading: _backButton(context),
      ),
      body: Column(
        children: <Widget>[
          _searchBar(searchType),
          _usersList(searchType, _getStream, users)
        ],
      ),
    );
  }

  StreamBuilder<List<User?>> _usersList(
    CollaboratorsSearchType? searchType,
    Stream<List<User?>> Function() getStream,
    List<String?> users,
  ) {
    return StreamBuilder<List<User?>>(
      stream: getStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<User?> collaborators = _filterCollaborators(snapshot.data);

          return Expanded(
            child: ListView.builder(
              itemCount: collaborators.length,
              itemBuilder: (context, index) {
                User user = collaborators[index]!;
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
      User user, List<String?> users, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: UserListItem(
        user: user,
        handler: () {
          users.add(user.userId);
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
