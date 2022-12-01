import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';
import 'package:project/providers/tag_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/screens/edit_tag_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/widgets/tag_widget.dart';

/// Screen/Scaffold for creating, updating and deleting tags from a project
/// and adding them to a task.
class TagsScreen extends ConsumerStatefulWidget {
  static const String routeName = "/tags";
  const TagsScreen({super.key});

  @override
  ConsumerState<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends ConsumerState<TagsScreen> {
  TextEditingController searchController = TextEditingController();
  late Project project;
  late Task task;
  late List<Tag> tags;
  List<Tag> items = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    project = (ModalRoute.of(context)!.settings.arguments as List)[0]!;
    task = (ModalRoute.of(context)!.settings.arguments as List)[1]!;

    tags = project.tags;
    items.clear();
    items.addAll(tags.where((element) => !task.tags.contains(element)));
    super.didChangeDependencies();
    setState(() {});
  }

  void searchFunction(String query) {
    List<Tag> searchResults = [];

    for (Tag tag in tags) {
      if (tag.text.toLowerCase().contains(query.toLowerCase())) {
        searchResults.add(tag);
      }
    }

    if (query.isNotEmpty) {
      items.clear();
      items.addAll(searchResults);
      setState(() {});
    } else {
      items.clear();
      items.addAll(tags.where((element) => !task.tags.contains(element)));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("tags"),
        leading: _backButton(context),
        actions: [_addNewTagButton(context)],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _searchBar(),
          _unselectedTagsList(),
          _selectedTagsList(context),
        ],
      ),
    );
  }

  /// Returns a list of tags which are connected to the curren task.
  /// If no tags are connected on current task, the list is not visible.
  Visibility _selectedTagsList(BuildContext context) {
    return Visibility(
      visible: task.tags.isNotEmpty,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "tags on current task",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: task.tags.length,
                itemBuilder: (context, index) => _tagListITem(
                  context,
                  task.tags[index],
                  null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns a list of tags which are not connected to the current task.
  Expanded _unselectedTagsList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) => _tagListITem(
          context,
          items[index],
          () {
            if (!task.tags.contains(items[index])) {
              task.tags.add(items[index]);
            }
            ref.read(taskProvider).saveTask(task.projectId, task).then(
                  (value) => Navigator.of(context).pop(),
                );
          },
        ),
      ),
    );
  }

  /// Returns the searchbar customized for tagsscreen.
  SearchBar _searchBar() {
    return SearchBar(
      placeholderText: "Search for tags",
      searchFunction: searchFunction,
      textEditingController: searchController,
    );
  }

  /// Returns a button for adding new tags.
  AppBarButton _addNewTagButton(BuildContext context) {
    return AppBarButton(
      handler: () {
        Navigator.of(context).pushNamed(EditTagScreen.routeName,
            arguments: [null, project]).then(
          (value) => setState(
            () {
              items.clear();
              items.addAll(project.tags
                  .where((element) => !task.tags.contains(element)));
            },
          ),
        );
      },
      tooltip: "Add a new tag",
      icon: PhosphorIcons.plusLight,
    );
  }

  /// Navigates back to previous screen.
  AppBarButton _backButton(BuildContext context) {
    return AppBarButton(
      handler: () => Navigator.of(context).pop(),
      icon: PhosphorIcons.caretLeftLight,
      tooltip: "Go back",
    );
  }

  /// Returns an Widget displaying a [Tag] in a list item.
  Widget _tagListITem(
      BuildContext context, Tag tag, void Function()? tapTagHandler) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 4.0, 0.0),
      child: Column(
        children: [
          InkWell(
            onTap: tapTagHandler,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TagWidget.fromTag(tag),
                _tagPopUpButton(context, tag),
              ],
            ),
          ),
          Divider(
            height: 0.5,
            color: Colors.black.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  /// Button for options on what to do with the given [tag].
  PopupMenuButton _tagPopUpButton(BuildContext context, Tag tag) {
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 1:
            Navigator.of(context)
                .pushNamed(EditTagScreen.routeName, arguments: [
              tag,
              project
            ]).then((value) => setState(() {
                      items.clear();
                      items.addAll(project.tags
                          .where((element) => !task.tags.contains(element)));
                    }));
            break;
          case 2:
            Future.delayed(const Duration(seconds: 0)).then(
              (value) => showDialog(
                context: context,
                builder: (context) => _deleteTagDialog(tag, context),
              ),
            );
            break;
          default:
        }
      },
      icon: Icon(
        PhosphorIcons.dotsThreeVerticalBold,
        color: Themes.textColor(ref),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          height: 40,
          value: 1,
          child: Text("edit tag"),
        ),
        PopupMenuItem(
          height: 40,
          value: 2,
          child: Text(
            "delete tag",
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
        ),
      ],
    );
  }

  /// AlertDialog for confirming if a tag is to be deleted or not.
  AlertDialog _deleteTagDialog(Tag tag, BuildContext context) {
    return AlertDialog(
      title: const Text("deleting tag"),
      content: Text(
        "Are you sure you want to delete the tag \"${tag.text}\"",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "no",
            style: TextStyle(
              color: Themes.textColor(ref),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            task.tags.remove(tag);
            ref
                .read(tagProvider)
                .deleteTag(
                  tag,
                  project.projectId,
                )
                .then((value) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          },
          child: Text(
            "yes",
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
        ),
      ],
    );
  }
}
