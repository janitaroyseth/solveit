import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/tag_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/screens/edit_tag_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/buttons/app_bar_button.dart';
import 'package:project/widgets/inputs/search_bar.dart';
import 'package:project/widgets/items/tag_list_item.dart';

/// Screen/Scaffold for creating, updating and deleting tags from a project
/// and adding them to a task.
class TagsScreen extends ConsumerStatefulWidget {
  /// Named route for this screen.
  static const String routeName = "/tags";

  /// Creates an instance of [TagsScreen].
  const TagsScreen({super.key});

  @override
  ConsumerState<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends ConsumerState<TagsScreen> {
  /// The text editing controller for the search field
  final TextEditingController _searchController = TextEditingController();

  /// The project whose tags these belongs to.
  late Project _project;

  /// The task to add tag to.
  late Task _task;

  /// List of tags in the project.
  late List<Tag> _tags;

  /// The tags displayed when searching.
  final List<Tag> _items = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _project = ref.read(editProjectProvider)!;
    _task = ref.read(editTaskProvider)!;

    _tags = _project.tags;
    _items.clear();
    _items.addAll(_tags.where((element) => !_task.tags.contains(element)));
    super.didChangeDependencies();
    setState(() {});
  }

  /// Searching tags.
  void searchFunction(String query) {
    List<Tag> searchResults = [];

    for (Tag tag in _tags) {
      if (tag.text.toLowerCase().contains(query.toLowerCase())) {
        searchResults.add(tag);
      }
    }

    if (query.isNotEmpty) {
      _items.clear();
      _items.addAll(searchResults);
      setState(() {});
    } else {
      _items.clear();
      _items.addAll(_tags.where((element) => !_task.tags.contains(element)));
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

  /// Returns a list of tags which are connected to the current task.
  /// If no tags are connected on current task, the list is not visible.
  Visibility _selectedTagsList(BuildContext context) {
    return Visibility(
      visible: _task.tags.isNotEmpty,
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
                itemCount: _task.tags.length,
                itemBuilder: (context, index) => _tagListITem(
                  context,
                  _task.tags[index],
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
        itemCount: _items.length,
        itemBuilder: (context, index) => _tagListITem(
          context,
          _items[index],
          () {
            if (!_task.tags.contains(_items[index])) {
              _task.tags.add(_items[index]);
            }
            Navigator.of(context).pop();
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
      textEditingController: _searchController,
    );
  }

  /// Returns a button for adding new tags.
  AppBarButton _addNewTagButton(BuildContext context) {
    return AppBarButton(
      handler: () {
        Navigator.of(context).pushNamed(EditTagScreen.routeName,
            arguments: [null, _project]).then(
          (value) => setState(
            () {
              _items.clear();
              _items.addAll(ref
                  .read(editProjectProvider)!
                  .tags
                  .where((element) => !_task.tags.contains(element)));
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
                TagListItem.fromTag(tag),
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
              _project
            ]).then((value) => setState(() {
                      _items.clear();
                      _items.addAll(_project.tags
                          .where((element) => !_task.tags.contains(element)));
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
            _task.tags.remove(tag);
            ref
                .read(tagProvider)
                .deleteTag(
                  tag,
                  _project.projectId,
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
