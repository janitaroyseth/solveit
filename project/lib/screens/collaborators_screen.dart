import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/widgets/user_list_item.dart';

enum CollaboratorsSearchType {
  collaborators,
  assignees,
}

class CollaboratorsScreen extends ConsumerStatefulWidget {
  static const routeName = "/collaborators";
  final CollaboratorsSearchType searchType;

  const CollaboratorsScreen({
    super.key,
    this.searchType = CollaboratorsSearchType.collaborators,
  });

  @override
  ConsumerState<CollaboratorsScreen> createState() =>
      _CollaboratorsScreenState();
}

class _CollaboratorsScreenState extends ConsumerState<CollaboratorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final List<User?> collaborators =
        ModalRoute.of(context)!.settings.arguments as List<User?>;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchType == CollaboratorsSearchType.collaborators
            ? "add collaborator"
            : "add assignee"),
      ),
      body: Column(
        children: <Widget>[
          SearchBar(
            placeholderText: "search for ${widget.searchType.name}",
            searchFunction: (String query) {
              setState(() {});
            },
            textEditingController: _searchController,
          ),
          StreamBuilder<List<User?>>(
            stream: ref.watch(userProvider).searchUsers(_searchController.text),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                for (User? user in collaborators) {
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
                            collaborators.add(user);
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
