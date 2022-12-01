import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/collaborators_screen.dart';
import 'package:project/screens/tags_screen.dart';
import 'package:project/widgets/loading_spinner.dart';
import 'package:project/widgets/tag_widget.dart';

import '../models/project.dart';
import '../models/tag.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../styles/theme.dart';
import '../widgets/appbar_button.dart';
import '../widgets/user_list_item.dart';

enum _EditTaskMode {
  create,
  edit,
}

/// Screen/Scaffold for creating and editing tasks.
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
      ref.read(taskProvider).saveTask(task.projectId, task);

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
                  child: _TaskScreenBody(task, project)),
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
  final Project project;
  const _TaskScreenBody(this.task, this.project);
  @override
  State<StatefulWidget> createState() => _TaskScreenBodyState();
}

class _TaskScreenBodyState extends State<_TaskScreenBody> {
  late Task task;
  final _formKey = GlobalKey<FormState>();
  bool isTagPickerShown = false;
  late List<Tag> allTags;
  List<User> selectedUsers = [];

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    allTags = widget.project.tags;
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
            _createTagsSection(ref),
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

  Widget _createTagsSection(WidgetRef ref) {
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
        _createTagsList(ref),
        _createAddTagList(),
      ],
    );
  }

  Widget _createTagsList(WidgetRef ref) {
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
          ref.read(currentProjectProvider.notifier).setProject(
              ref.watch(projectProvider).getProject(task.projectId));
          ref
              .watch(currentProjectProvider)
              .first
              .then((value) => Navigator.of(context)
                  .pushNamed(TagsScreen.routeName, arguments: [value, task])
                  .then(
                    (value) => setState(() {}),
                  )
                  .whenComplete(() => setState(() {})));
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
          style: Themes.formButtonStyle(ref),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "assigned",
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        _AssigneesList(task),
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

/// Displays a list of currently selected assignees.
class _AssigneesList extends ConsumerStatefulWidget {
  /// Creates an instance of [_AssigneesList].
  const _AssigneesList(this.task);

  /// The task to display current list of assignees for.
  final Task task;

  @override
  ConsumerState<_AssigneesList> createState() => _AssigneesListState();
}

class _AssigneesListState extends ConsumerState<_AssigneesList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.task.assigned.length,
          itemBuilder: (context, index) => StreamBuilder<User?>(
              stream:
                  ref.watch(userProvider).getUser(widget.task.assigned[index]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  User user = snapshot.data!;
                  return UserListItem(
                    user: user,
                    handler: () {},
                    size: UserListItemSize.small,
                    widget: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            widget.task.assigned.remove(user.userId);
                            ref
                                .read(taskProvider)
                                .saveTask(widget.task.projectId, widget.task);
                            setState(() {});
                            break;
                          default:
                        }
                      },
                      icon: Icon(
                        PhosphorIcons.dotsThreeVerticalBold,
                        color: Themes.textColor(ref),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          height: 40,
                          value: 1,
                          child: Text(
                            "remove assignee",
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const LoadingSpinner();
              }),
        ),
        addAssigneeButton(context, ref, widget.task)
      ],
    );
  }

  /// Button for opening a new screen where new assignees can be added.
  TextButton addAssigneeButton(BuildContext context, WidgetRef ref, Task task) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      onPressed: () {
        ref.read(currentTaskProvider.notifier).setTask(
            ref.watch(taskProvider).getTask(task.projectId, task.taskId));
        Navigator.of(context).pushNamed(
          CollaboratorsScreen.routeName,
          arguments: [
            task.assigned,
            CollaboratorsSearchType.assignees,
            task.projectId,
          ],
        ).then((value) => setState(() {}));
      },
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundColor: Themes.primaryColor.shade100,
            backgroundImage:
                const AssetImage("assets/images/profile_placeholder.png"),
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            "add assignee...",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Themes.textColor(ref),
            ),
          )
        ],
      ),
    );
  }
}
