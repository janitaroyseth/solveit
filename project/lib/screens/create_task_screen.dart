import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/widgets/tag_widget.dart';

import '../data/example_data.dart';
import '../models/project.dart';
import '../models/tag.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../styles/theme.dart';
import '../widgets/appbar_button.dart';
import '../widgets/search_bar.dart';
import '../widgets/user_list_item.dart';

class CreateTaskScreen extends StatelessWidget {
  static const routeName = "/new-task";
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Project project = ModalRoute.of(context)!.settings.arguments as Project;
    Task task = Task();
    return Scaffold(
      appBar: AppBar(
        title: const Text("create task"),
        centerTitle: false,
        elevation: 0,
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () => Navigator.of(context).pop(),
          tooltip: "Go back",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.black,
        ),
        backgroundColor: Themes.themeData.appBarTheme.backgroundColor,
        foregroundColor: Themes.themeData.appBarTheme.foregroundColor,
        actions: [
          AppBarButton(
            handler: () {
              project.tasks.add(task);
              Navigator.of(context).pop();
            },
            tooltip: "Save task",
            icon: PhosphorIcons.floppyDiskLight,
            color: Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20), child: _TaskScreenBody(task)),
      ),
    );
  }
}

class _TaskScreenBody extends StatefulWidget {
  Task task;
  _TaskScreenBody(this.task);
  @override
  State<StatefulWidget> createState() => _TaskScreenBodyState();
}

class _TaskScreenBodyState extends State<_TaskScreenBody> {
  _TaskScreenBodyState();
  final Task task = Task(tags: [], assigned: [], deadline: null);
  final _formKey = GlobalKey<FormState>();
  bool isTagPickerShown = false;
  List<Tag> allTags = ExampleData.tags;
  List<User> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _createTaskNameSection(),
          const SizedBox(
            height: 20,
          ),
          _createTagsSection(),
          const SizedBox(
            height: 20,
          ),
          _createDeadlineSection(),
          const SizedBox(
            height: 20,
          ),
          _createAssignedSection(),
          const SizedBox(
            height: 20,
          ),
          _createDescriptionSection(),
        ],
      ),
    );
  }

  Widget _createTaskNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "task",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          onFieldSubmitted: (String value) {
            task.title = value;
          },
          style: const TextStyle(fontSize: 12),
          decoration: const InputDecoration.collapsed(
            hintText: 'concise description of the task at hand...',
          ),
        ),
      ],
    );
  }

  Widget _createTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "tags",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        _createTagsList(),
        _createAddTagList(),
      ],
    );
  }

  Widget _createTagsList() {
    List<Widget> tagWidgets = [];
    for (Tag tag in task.tags) {
      tagWidgets.add(
        InkWell(
          onTap: () => {
            setState(() {
              task.tags.remove(tag);
            })
          },
          borderRadius: BorderRadius.circular(50),
          child: TagWidget.fromTag(tag),
        ),
      );
    }

    tagWidgets.add(
      InkWell(
        onTap: () {
          setState(() {
            isTagPickerShown = !isTagPickerShown;
          });
        },
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 3.5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0x80000000), width: 0.5),
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: const Text(
              "add +",
              style: TextStyle(
                color: Color(0x80000000),
                fontSize: 12,
              ),
            ),
          ),
        ),
        // child: const TagWidget(
        //     size: TagSize.large, color: Color(0xffffffff), tagText: "add +"),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: tagWidgets,
    );
  }

  Widget _createAddTagList() {
    if (!isTagPickerShown) {
      return Container();
    } else {
      List<Widget> tagWidgets = [];
      for (Tag tag in allTags) {
        if (!task.tags.contains(tag)) {
          tagWidgets.add(Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(50),
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  task.tags.add(tag);
                });
              },
              borderRadius: BorderRadius.circular(50),
              child: TagWidget.fromTag(tag),
            ),
          ));
        }
      }
      // CREATION OF NEW TAGS IMPLEMENTED LATER.
      // tagWidgets.add(
      //   Material(
      //     elevation: 5,
      //     borderRadius: BorderRadius.circular(500),
      //     color: Colors.transparent,
      //     child: InkWell(
      //       onTap: () {
      //         // TODO: add new tag.
      //       },
      //       borderRadius: BorderRadius.circular(50),
      //       child: const TagWidget(
      //           size: TagSize.large,
      //           color: Color(0xffffffff),
      //           tagText: "new +"),
      //     ),
      //   ),
      // );
      return Row(
        children: [
          Flexible(
            child: Wrap(
                spacing: 2.0,
                runSpacing: 4.0,
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                children: tagWidgets),
          ),
        ],
      );
    }
  }

  Widget _createDeadlineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "deadline",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        TextButton(
          style: Themes.datePickerButtonStyle,
          child: Text(task.deadline ?? "click to pick a date..."),
          onPressed: () => _getDate(),
        ),
      ],
    );
  }

  void _getDate() async {
    String deadline = task.deadline ?? "";
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate:
            task.deadline != null ? DateTime.parse(deadline) : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 730)));
    if (null == pickedDate) return;

    setState(() {
      task.deadline = pickedDate.toString().substring(0, 10);
    });
  }

  Widget _createAssignedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "assigned",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        _createAssignedList(context),
      ],
    );
  }

  Widget _createAssignedList(BuildContext context) {
    return Column(
      children: [
        ...task.assigned
            .map(
              (e) => UserListItem(
                handler: () => {setState(() => task.assigned.remove(e))},
                user: e,
                size: UserListItemSize.small,
              ),
            )
            .toList(),
        TextButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => Dialog(
              child: SizedBox(
                width: double.infinity - 20,
                height: 350,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SearchBar(
                        placeholderText: "search for collaborators...",
                        searchFunction: () {},
                        textEditingController: TextEditingController(),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 0.0,
                        ),
                        child: ListView(
                          children: [
                            UserListItem(
                              handler: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(ExampleData.user1),
                              user: ExampleData.user1,
                            ),
                            UserListItem(
                              handler: () =>
                                  Navigator.of(context, rootNavigator: true)
                                      .pop(ExampleData.user2),
                              user: ExampleData.user2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).then((value) => setState((() {
                task.assigned.add(value);
              }))),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 15,
                backgroundColor: Themes.primaryColor.shade100,
                backgroundImage: const AssetImage(
                    "assets/images/empty_profile_pic_large.png"),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "add collaborator...",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Themes.textColor,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _createDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "description",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          maxLines: 8,
          style: const TextStyle(fontSize: 12),
          decoration: const InputDecoration.collapsed(
            hintText: 'detailed description of the task at hand...',
          ),
        ),
      ],
    );
  }
}
