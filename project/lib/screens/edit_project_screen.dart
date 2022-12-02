import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/project_avatar_options.dart';
import 'package:project/models/project.dart';
import 'package:project/models/user.dart';
import 'package:project/providers/auth_provider.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/user_provider.dart';
import 'package:project/screens/collaborators_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/loading_spinner.dart';
import 'package:project/widgets/user_list_item.dart';

enum _EditProjectMode {
  create,
  edit,
}

/// Screen/Scaffold for creating a new project or editing an existing one.
class EditProjectScreen extends ConsumerWidget {
  /// Named route for this screen.
  static const routeName = "/edit-project";

  /// Creates an instance of [EditProjectScreen].
  const EditProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Project? existingProject = ref.read(editProjectProvider);
    final mode = existingProject == null
        ? _EditProjectMode.create
        : _EditProjectMode.edit;
    final Project project = existingProject ?? Project();

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    titleController.text = _EditProjectMode.edit == mode ? project.title : "";
    descriptionController.text =
        _EditProjectMode.edit == mode ? project.description : "";

    /// Saves the project and adds it to the list.
    void saveProject() {
      ref
          .watch(userProvider)
          .getUser(ref.watch(authProvider).currentUser!.uid)
          .first
          .then((user) {
        project.title = titleController.text;
        project.description = descriptionController.text;
        project.owner = ref.watch(authProvider).currentUser!.uid;
        if (!project.collaborators.contains(user!.userId)) {
          project.collaborators.add(user.userId);
        }
        project.lastUpdated = DateTime.now().toIso8601String();

        ref.read(projectProvider).saveProject(project);

        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle(mode),
        leading: _backButton(context),
        backgroundColor: Themes.primaryColor,
        foregroundColor: Colors.white,
        actions: <Widget>[
          _saveButton(saveProject),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              _titleInputField(titleController, ref),
              _verticalPadding,
              _descriptionInputField(descriptionController, ref),
              _verticalPadding,
              _PublicProjectOptions(project),
              _verticalPadding,
              _CollaboratorsList(project),
              _verticalPadding,
              _ProjectAvatarPicker(project),
            ],
          ),
        ),
      ),
    );
  }

  final Widget _verticalPadding = const SizedBox(height: 24);

  /// Saves the project.
  AppBarButton _saveButton(void Function() saveProject) {
    return AppBarButton(
      handler: saveProject,
      tooltip: "Save project",
      icon: PhosphorIcons.floppyDiskLight,
      color: Colors.white,
    );
  }

  /// Input field for adding description of project.
  TextFormField _descriptionInputField(
      TextEditingController descriptionController, WidgetRef ref) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: descriptionController,
      decoration: Themes.inputDecoration(
        ref,
        "description",
        "descrive your project",
      ),
    );
  }

  /// Input field for adding title of project.
  TextFormField _titleInputField(
      TextEditingController titleController, WidgetRef ref) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      controller: titleController,
      decoration: Themes.inputDecoration(
        ref,
        "title",
        "a concise description of your project",
      ),
    );
  }

  /// The title of the screen, depending on which mode it is.
  Text _appBarTitle(mode) {
    return Text(
      mode == _EditProjectMode.create ? "create project" : "edit project",
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }

  /// Goes back to previoud screen without saving.
  AppBarButton _backButton(BuildContext context) {
    return AppBarButton(
      handler: () => Navigator.of(context).pop(),
      tooltip: "Go back",
      icon: PhosphorIcons.caretLeftLight,
      color: Colors.white,
    );
  }
}

/// Displays a list of currently selected collaborators.
class _CollaboratorsList extends ConsumerStatefulWidget {
  /// Creates an instance of [_CollaboratorsList].
  const _CollaboratorsList(this.project);

  /// The project to display current list of collaborators for.
  final Project project;

  @override
  ConsumerState<_CollaboratorsList> createState() => _CollaboratorsListState();
}

class _CollaboratorsListState extends ConsumerState<_CollaboratorsList> {
  @override
  void didChangeDependencies() {
    ref
        .watch(userProvider)
        .getUser(ref.watch(authProvider).currentUser!.uid)
        .first
        .then((user) {
      if (!widget.project.collaborators.contains(user!.userId)) {
        widget.project.collaborators.add(user.userId);
      }
    }).whenComplete(() => setState(() {}));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _collaboratorsLabel(),
        _collaboratorsList(),
        addCollaboratorButton(context, ref, widget.project)
      ],
    );
  }

  /// Returns a listview displaying the collaborators for this project.
  ListView _collaboratorsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.project.collaborators.length,
      itemBuilder: (context, index) => StreamBuilder<User?>(
          stream: ref.watch(userProvider).getUser(
                widget.project.collaborators[index],
              ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User user = snapshot.data!;
              return UserListItem(
                user: user,
                handler: () {},
                size: UserListItemSize.small,
                widget: _userListItemMenu(user),
              );
            }
            return const LoadingSpinner();
          }),
    );
  }

  /// Returns a [Text] displaying the collaborators label for this section.
  Text _collaboratorsLabel() {
    return const Text(
      "collaborators",
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  /// If the given user is not the owner a [PopUpMenuButton] is returned, if not
  /// [null] is returned.
  Widget? _userListItemMenu(User user) {
    return user.userId != widget.project.owner
        ? PopupMenuButton(
            padding: EdgeInsets.zero,
            onSelected: (value) {
              switch (value) {
                case 1:
                  widget.project.collaborators.remove(user.userId);
                  ref.read(projectProvider).saveProject(widget.project);
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
                  "remove collaborator",
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ),
            ],
          )
        : null;
  }

  /// Button for opening a new screen where new collaborators can be added.
  TextButton addCollaboratorButton(
      BuildContext context, WidgetRef ref, Project project) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      onPressed: () => Navigator.of(context).pushNamed(
        CollaboratorsScreen.routeName,
        arguments: [
          project.collaborators,
          CollaboratorsSearchType.collaborators,
          project.projectId,
        ],
      ).then((value) => setState(() {})),
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
            "add collaborator...",
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

/// Radio buttons for choosing whether the project is to be private or public.
class _PublicProjectOptions extends StatefulWidget {
  /// Creates an instance of public project options.
  const _PublicProjectOptions(this.project);

  final Project? project;

  @override
  State<_PublicProjectOptions> createState() => _RadioButtonsOptionState();
}

class _RadioButtonsOptionState extends State<_PublicProjectOptions> {
  /// Current value for whether the project is to be public.
  bool? isPublic;
  @override
  void initState() {
    if (widget.project != null) {
      isPublic = widget.project?.isPublic;
    } else {
      isPublic = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Text(
          "public or private project",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Row(
          children: <Widget>[
            Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: true,
              groupValue: isPublic,
              onChanged: (value) => setState(() {
                isPublic = value as bool;
                widget.project!.isPublic = value;
              }),
            ),
            const Text("public")
          ],
        ),
        Row(
          children: [
            Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: false,
              groupValue: isPublic,
              onChanged: (value) => setState(() {
                isPublic = value as bool;
                widget.project!.isPublic = value;
              }),
            ),
            const Text("private")
          ],
        ),
      ],
    );
  }
}

/// [GridView] showing the project avatar options and lets a user pick one.
class _ProjectAvatarPicker extends StatefulWidget {
  /// Creates an instance of [ProjectAvatarPicker].
  const _ProjectAvatarPicker(this.project);

  final Project? project;

  @override
  State<_ProjectAvatarPicker> createState() => __ProjectAvatarPickerState();
}

class __ProjectAvatarPickerState extends State<_ProjectAvatarPicker> {
  /// Index of the currently chosen image, defaults to 0.
  late int chosenIndex;

  @override
  void initState() {
    chosenIndex = widget.project != null
        ? projectAvatars.indexOf(projectAvatars
            .firstWhere((element) => element == widget.project?.imageUrl))
        : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "choose a project avatar",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: projectAvatars.length,
          physics:
              const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
          shrinkWrap: true,
          itemBuilder: (context, index) => _projectAvatarItem(index),
        ),
      ],
    );
  }

  GestureDetector _projectAvatarItem(int index) {
    return GestureDetector(
      onTap: () => setState(() {
        chosenIndex = index;
        widget.project!.imageUrl = projectAvatars[chosenIndex];
      }),
      child: Stack(
        children: [
          Image.asset(projectAvatars[index]),
          index == chosenIndex
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    PhosphorIcons.check,
                    color: Themes.primaryColor,
                    size: 36,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
