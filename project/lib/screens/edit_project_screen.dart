import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/example_data.dart';
import 'package:project/data/project_avatar_options.dart';
import 'package:project/models/project.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/input_field.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/widgets/user_list_item.dart';

enum _EditProjectMode {
  create,
  edit,
}

/// Screen/Scaffold for creating a new project or editing an existing one.
class EditProjectScreen extends StatelessWidget {
  static const routeName = "/edit-project";
  const EditProjectScreen({super.key});

  final Widget _verticalPadding = const SizedBox(height: 24);

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();

    final descriptionController = TextEditingController();

    final Project? existingProject =
        (ModalRoute.of(context)?.settings.arguments as Project?);

    final mode = existingProject == null
        ? _EditProjectMode.create
        : _EditProjectMode.edit;

    final Project project =
        existingProject ?? Project(owner: ExampleData.user1);

    titleController.text = _EditProjectMode.edit == mode ? project.title : "";

    descriptionController.text =
        _EditProjectMode.edit == mode ? project.description : "";

    /// Saves the project and adds it to the list.
    void saveProject() {
      project.title = titleController.text;
      project.description = descriptionController.text;

      if (mode == _EditProjectMode.edit && existingProject != null) {
        ExampleData.projects[ExampleData.projects.indexOf(existingProject)] =
            project;
      } else {
        ExampleData.projects.add(project);
      }
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: appBarTitle(mode),
        centerTitle: true,
        leading: backButton(context),
        backgroundColor: Themes.primaryColor,
        foregroundColor: Colors.white,
        actions: <Widget>[
          AppBarButton(
            handler: saveProject,
            tooltip: "Save project",
            icon: PhosphorIcons.floppyDiskLight,
            color: Colors.white,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              InputField(
                label: "title",
                placeholderText: "a concise description of your project",
                keyboardAction: TextInputAction.next,
                textEditingController: titleController,
              ),
              _verticalPadding,
              InputField(
                label: "description",
                placeholderText: "describe your project",
                keyboardAction: TextInputAction.next,
                textEditingController: descriptionController,
              ),
              _verticalPadding,
              _PublicProjectOptions(project),
              _verticalPadding,
              const Text(
                "collaborators",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              addCollaboratorButton(context),
              _verticalPadding,
              const Text("choose a project avatar"),
              _ProjectAvatarPicker(project),
              ElevatedButton(
                onPressed: saveProject,
                style: Themes.primaryElevatedButtonStyle,
                child: const Text("create project"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text appBarTitle(mode) {
    return Text(
      mode == _EditProjectMode.create ? "create project" : "edit project",
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  AppBarButton backButton(BuildContext context) {
    return AppBarButton(
      handler: () => Navigator.of(context).pop(),
      tooltip: "Go back",
      icon: PhosphorIcons.caretLeftLight,
      color: Colors.white,
    );
  }

  TextButton addCollaboratorButton(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => const _CollaboratorsDialog(),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundColor: Themes.primaryColor.shade100,
            backgroundImage:
                const AssetImage("assets/images/empty_profile_pic_large.png"),
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
    );
  }
}

/// A dialog showing some dummy data.
class _CollaboratorsDialog extends StatelessWidget {
  /// Creates content for a dialog which shows some dummy data users.
  const _CollaboratorsDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: double.infinity - 20,
        height: 350,
        child: Column(
          children: [
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
                      handler: () => Navigator.of(context)
                          .pushNamed(ProfileScreen.routeName),
                      user: ExampleData.user1,
                    ),
                    UserListItem(
                      handler: () => Navigator.of(context)
                          .pushNamed(ProfileScreen.routeName),
                      user: ExampleData.user2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: projectAvatars.length,
      physics:
          const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
      shrinkWrap: true,
      itemBuilder: (context, index) => GestureDetector(
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
      ),
    );
  }
}
