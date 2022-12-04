import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/models/tag.dart';
import 'package:project/models/task.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/calendar_provider.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/task_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/collaborators_screen.dart';
import 'package:project/screens/tags_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/utilities/date_formatting.dart';
import 'package:project/widgets/buttons/app_bar_button.dart';
import 'package:project/widgets/general/loading_spinner.dart';
import 'package:project/widgets/items/tag_list_item.dart';
import 'package:project/widgets/items/user_list_item.dart';

enum _EditTaskMode {
  create,
  edit,
}

/// Screen/Scaffold for creating and editing tasks.
class EditTaskScreen extends ConsumerWidget {
  /// Named route for this screen.
  static const routeName = "/configure-task";

  /// Creates an instance of [EditTaskScreen].
  const EditTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Existing task to edit, if null a new task is created.
    Task? existingTask = ref.read(editTaskProvider);

    /// What mode to cater the screen for.
    final _EditTaskMode mode =
        existingTask == null ? _EditTaskMode.create : _EditTaskMode.edit;

    /// The task to edit, set to existing task unless null, then a new task
    /// is created.
    Task task = existingTask ??
        ModalRoute.of(context)!.settings.arguments as Task? ??
        Task();

    /// The project to save the task to.
    task.projectId = ref.read(editProjectProvider)!.projectId;

    /// Saves the task.
    void saveTask() async {
      task.updatedBy = ref.watch(authProvider).currentUser!.uid;

      ref
          .read(taskProvider)
          .saveTask(task)
          .then(
            (value) => ref.read(calendarProvider).addTaskToCalendar(
                task: value, email: ref.read(authProvider).currentUser!.email!),
          )
          .then(
            (value) => Navigator.of(context).pop(),
          );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          mode == _EditTaskMode.create ? "create task" : "edit task",
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AppBarButton(
          handler: () {
            Navigator.of(context).pop();
          },
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
            child: _TaskScreenBody(task, ref.read(editProjectProvider)!)),
      ),
    );
  }
}

class _TaskScreenBody extends ConsumerStatefulWidget {
  final Task task;
  final Project project;
  const _TaskScreenBody(this.task, this.project);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditTaskForm();
}

class _EditTaskForm extends ConsumerState<_TaskScreenBody> {
  /// Unique key for the form.
  final _formKey = GlobalKey<FormState>();

  /// The task to edit.
  late Task _task;

  late List<Tag> allTags;
  List<User> selectedUsers = [];

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    allTags = widget.project.tags;
    _task = widget.task;
    titleController.text = _task.title;
    descriptionController.text = _task.description;
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
              _task.title = value;
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
      ],
    );
  }

  Widget _createTagsList(WidgetRef ref) {
    List<Widget> tagWidgets = [];

    for (Tag tag in _task.tags) {
      tagWidgets.add(
        InkWell(
          onTap: () => {
            setState(() {
              _task.tags.remove(tag);
            })
          },
          borderRadius: BorderRadius.circular(50),
          child: TagListItem.fromTag(tag),
        ),
      );
    }

    tagWidgets.add(
      InkWell(
        onTap: () {
          ref.read(currentProjectProvider.notifier).setProject(
              ref.watch(projectProvider).getProject(_task.projectId));
          ref.watch(currentProjectProvider).first.then((value) {
            ref.read(editProjectProvider.notifier).setProject(value);
            ref.read(editTaskProvider.notifier).setTask(_task);
            Navigator.of(context)
                .pushNamed(TagsScreen.routeName, arguments: [value, _task])
                .then(
                  (value) => setState(() {}),
                )
                .whenComplete(() => setState(() {}));
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
          child: Text(_task.deadline != null
              ? DateFormatting.shortDate(ref, _task.deadline!)
              : "click to pick a date..."),
          onPressed: () => _getDate(),
        ),
      ],
    );
  }

  void _getDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      helpText: "",
      initialDate: _task.deadline != null ? _task.deadline! : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            onPrimary: Colors.white, // header background color
            primary: Themes.primaryColor, // header text color
            onSurface: Themes.textColor(ref), // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Themes.textColor(ref),
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (null == pickedDate) return;

    setState(() {
      _task.deadline = pickedDate;
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
        _AssigneesList(_task),
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
            _task.description = value;
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
                            ref.read(taskProvider).saveTask(widget.task);
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
        ref.read(editTaskProvider.notifier).setTask(task);
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
