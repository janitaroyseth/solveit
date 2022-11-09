import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/data/project_avatar_options.dart';
import 'package:project/screens/profile_screen.dart';
import 'package:project/styles/theme.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/input_field.dart';
import 'package:project/widgets/search_bar.dart';
import 'package:project/widgets/user_list_item.dart';

/// Screen/Scaffold for creating a new project.
class CreateProjectScreen extends StatelessWidget {
  static const routeName = "/new-project";
  const CreateProjectScreen({super.key});

  final Widget _verticalPadding = const SizedBox(height: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("create project"),
        centerTitle: false,
        titleSpacing: -4,
        leading: AppBarButton(
          handler: () => Navigator.of(context).pop(),
          tooltip: "Add new task",
          icon: PhosphorIcons.caretLeftLight,
          color: Colors.white,
        ),
        backgroundColor: Themes.primaryColor,
        foregroundColor: Colors.white,
        actions: <Widget>[
          AppBarButton(
            handler: () => Navigator.of(context).pop(),
            tooltip: "Create new project",
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
              const InputField(
                label: "title",
                placeholderText: "a concise description of your project",
                keyboardAction: TextInputAction.next,
              ),
              _verticalPadding,
              const InputField(
                label: "description",
                placeholderText: "describe your project",
                keyboardAction: TextInputAction.next,
              ),
              _verticalPadding,
              const _PublicProjectOptions(),
              _verticalPadding,
              const Text(
                "collaborators",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => Dialog(
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
                                    name: "Jane Cooper",
                                    imageUrl: "assets/images/jane_cooper.png",
                                  ),
                                  UserListItem(
                                    handler: () => Navigator.of(context)
                                        .pushNamed(ProfileScreen.routeName),
                                    name: "Leslie Alexander",
                                    imageUrl:
                                        "assets/images/leslie_alexander.png",
                                  ),
                                  UserListItem(
                                    handler: () => Navigator.of(context)
                                        .pushNamed(ProfileScreen.routeName),
                                    name: "Guy Hawkins",
                                    imageUrl: "assets/images/guy_hawkins.png",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
              _verticalPadding,
              const Text("choose a project avatar"),
              const _ProjectAvatarPicker(),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: Themes.primaryElevatedButtonStyle,
                child: const Text("create project"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Radio buttons for choosing whether the project is to be private or public.
class _PublicProjectOptions extends StatefulWidget {
  /// Creates an instance of public project options.
  const _PublicProjectOptions();

  @override
  State<_PublicProjectOptions> createState() => _RadioButtonsOptionState();
}

class _RadioButtonsOptionState extends State<_PublicProjectOptions> {
  /// Current value for whether the project is to be public.
  bool? isPublic;
  @override
  void initState() {
    isPublic = false;
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
  const _ProjectAvatarPicker();

  @override
  State<_ProjectAvatarPicker> createState() => __ProjectAvatarPickerState();
}

class __ProjectAvatarPickerState extends State<_ProjectAvatarPicker> {
  /// Index of the currently chosen image, defaults to 0.
  int chosenIndex = 0;

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
