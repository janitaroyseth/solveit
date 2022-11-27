import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/task_provider.dart';
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

enum _EditTaskMode {
  create,
  edit,
}

class ConfigureTaskScreen extends ConsumerWidget {
  static const routeName = "/configure-task";
  const ConfigureTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Task? existingTask =
        (ModalRoute.of(context)?.settings.arguments as Task?);

    final _EditTaskMode mode =
        existingTask == null ? _EditTaskMode.create : _EditTaskMode.edit;

    Task task = existingTask ?? Task();

    void saveTask() {
      //task.tags = [];
      ref.read(taskProvider).saveTask(task);

      Navigator.of(context).pop();
    }

    return StreamBuilder<Project?>(
      stream: ref.watch(currentProjectProvider),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Project project = snapshot.data!;
          task.projectId = project.projectId;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                mode == _EditTaskMode.create ? "create task" : "edit task",
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: AppBarButton(
                handler: () => Navigator.of(context).pop(),
                tooltip: "Go back",
                icon: PhosphorIcons.caretLeftLight,
                color: Colors.black,
              ),
              actions: [
                AppBarButton(
                  handler: saveTask,
                  tooltip: "Save task",
                  icon: PhosphorIcons.floppyDiskLight,
                  color: Colors.black,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _TaskScreenBody(task)),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _TaskScreenBody extends StatefulWidget {
  final Task task;
  const _TaskScreenBody(this.task);
  @override
  State<StatefulWidget> createState() => _TaskScreenBodyState();
}

class _TaskScreenBodyState extends State<_TaskScreenBody> {
  late Task task;
  final _formKey = GlobalKey<FormState>();
  bool isTagPickerShown = false;
  List<Tag> allTags = ExampleData.tags;
  List<User> selectedUsers = [];

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    task = widget.task;
    titleController.text = task.title;
    descriptionController.text = task.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _createTaskTitleSection(ref),
            _verticalPadding(),
            _createTagsSection(),
            _verticalPadding(),
            _createDeadlineSection(ref),
            _verticalPadding(),
            _createAssignedSection(ref),
            _verticalPadding(),
            _createDescriptionSection(ref),
          ],
        ),
      ),
    );
  }

  Widget _verticalPadding() => const SizedBox(height: 20);

  Widget _createTaskTitleSection(ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
            controller: titleController,
            onChanged: (String value) {
              task.title = value;
            },
            style: Theme.of(context).textTheme.bodySmall,
            decoration: Themes.inputDecoration(
                ref, "task", "concise description of the task at hand...")),
      ],
    );
  }

  Widget _createTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "tags",
          style: Theme.of(context).textTheme.labelMedium,
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
      children: [
        Flexible(
          child: Wrap(
            spacing: 2.0,
            runSpacing: 4.0,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.start,
            children: tagWidgets,
          ),
        ),
      ],
    );
  }

  // TODO: Temporary
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

  Widget _createDeadlineSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "deadline",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        TextButton(
          style: Themes.datePickerButtonStyle(ref),
          child: Text(task.deadline != null
              ? Jiffy(task.deadline!).format("dd/MM/yyyy")
              : "click to pick a date..."),
          onPressed: () => _getDate(),
        ),
      ],
    );
  }

  void _getDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: task.deadline != null ? task.deadline! : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 730)));
    if (null == pickedDate) return;

    setState(() {
      task.deadline = pickedDate;
    });
  }

  Widget _createAssignedSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "assigned",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        _createAssignedList(context, ref),
      ],
    );
  }

  Widget _createAssignedList(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ...task.assigned
            .map(
              (e) => UserListItem(
                handler: () => {setState(() => task.assigned.remove(e))},
                userId: e,
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
                            // UserListItem(
                            //   handler: () =>
                            //       Navigator.of(context, rootNavigator: true)
                            //           .pop(ExampleData.user1),
                            //   userId: ExampleData.user1.userId,
                            // ),
                            // UserListItem(
                            //   handler: () =>
                            //       Navigator.of(context, rootNavigator: true)
                            //           .pop(ExampleData.user2),
                            //   userId: ExampleData.user2.userId,
                            // ),
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
                  "assets/images/profile_placeholder.png",
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "add collaborator...",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Themes.textColor(ref),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _createDescriptionSection(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: descriptionController,
          onChanged: (value) {
            task.description = value;
          },
          maxLines: 8,
          style: Theme.of(context).textTheme.bodySmall,
          decoration: Themes.inputDecoration(ref, "description",
              "detailed description of the task at hand..."),
        ),
      ],
    );
  }
}
