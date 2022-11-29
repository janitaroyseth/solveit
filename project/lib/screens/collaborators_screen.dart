import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/user_provider.dart';
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
    final List<User?> users =
        (ModalRoute.of(context)!.settings.arguments as List)[0] as List<User?>;
    final CollaboratorsSearchType? searchType =
        (ModalRoute.of(context)!.settings.arguments as List)[1] ??
            CollaboratorsSearchType.collaborators;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(searchType == CollaboratorsSearchType.collaborators
            ? "add collaborator"
            : "add assignee"),
      ),
      body: Column(
        children: <Widget>[
          SearchBar(
            placeholderText: "search for ${searchType!.name}",
            searchFunction: (String query) {
              setState(() {});
            },
            textEditingController: _searchController,
          ),
          StreamBuilder<List<User?>>(
            stream: searchType == CollaboratorsSearchType.collaborators
                ? ref.watch(userProvider).searchUsers(_searchController.text)
                : getCollaborators(),
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
                    },
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }
}
