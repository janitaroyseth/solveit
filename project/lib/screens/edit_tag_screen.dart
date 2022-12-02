import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:project/models/project.dart';
import 'package:project/models/tag.dart';
import 'package:project/providers/project_provider.dart';
import 'package:project/providers/tag_provider.dart';
import 'package:project/styles/theme.dart';
import 'package:project/utilities/color_utility.dart';
import 'package:project/widgets/appbar_button.dart';
import 'package:project/widgets/color_picker_dialog.dart';
import 'package:project/widgets/tag_widget.dart';

enum _EditTagMode {
  edit,
  create,
}

/// Screen/Scaffold for editing and creating tags.
class EditTagScreen extends ConsumerStatefulWidget {
  /// Named route for this screen.
  static const String routeName = "/edit-task";

  /// Creates an instance of [EditTagScreen].
  const EditTagScreen({super.key});

  @override
  ConsumerState<EditTagScreen> createState() => _EditTagScreenState();
}

class _EditTagScreenState extends ConsumerState<EditTagScreen> {
  TextEditingController textController = TextEditingController();
  late Color? pickedColor;
  bool showColorError = false;
  final formKey = GlobalKey<FormState>();
  late Tag? existingTag;
  late Tag tag;
  late Project project;
  _EditTagMode mode = _EditTagMode.create;

  @override
  void didChangeDependencies() {
    existingTag =
        (ModalRoute.of(context)?.settings.arguments as List)[0] as Tag?;
    project = ref.read(editProjectProvider)!;
    mode = existingTag == null ? _EditTagMode.create : _EditTagMode.edit;
    tag = existingTag ?? Tag();
    textController.text = tag.text;
    pickedColor = colorFromString(tag.color);
    setState(() {});
    super.didChangeDependencies();
  }

  void saveTag() async {
    bool isValid = formKey.currentState!.validate();

    if (isValid && pickedColor != null && pickedColor != Colors.transparent) {
      tag.text = textController.text;
      tag.color = stringFromColor(pickedColor!);
      ref
          .read(tagProvider)
          .saveTag(
              tag: tag, projectId: ref.read(editProjectProvider)!.projectId)
          .then((value) {
        project.tags.add(value!);
        Navigator.of(context).pop();
      });
    } else {
      if (pickedColor == null) showColorError = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: _appBarTitle(mode),
          leading: _backButton(context),
          actions: [
            _saveButton(),
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _tagTextInputField(tag),
                _verticalPadding(),
                _tagColorField(tag),
                _verticalPadding(),
                _previewTag(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _verticalPadding() => const SizedBox(height: 24);

  /// Goes back to previous screen.
  AppBarButton _backButton(BuildContext context) {
    return AppBarButton(
      handler: () => Navigator.of(context).pop(),
      tooltip: "Go back",
      icon: PhosphorIcons.caretLeftLight,
    );
  }

  /// Button for saving the tag.
  AppBarButton _saveButton() {
    return AppBarButton(
      handler: () => saveTag(),
      tooltip: "Save tag",
      icon: PhosphorIcons.floppyDiskLight,
    );
  }

  /// Shows a preview of the tag in creation.
  Widget _previewTag() {
    return Visibility(
      visible: pickedColor != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "preview",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          if (pickedColor != null)
            TagWidget(
              size: TagSize.large,
              color: pickedColor!,
              tagText: textController.text,
            ),
        ],
      ),
    );
  }

  /// Returns the section for choosing a color for the
  /// tag in creation.
  Column _tagColorField(Tag tag) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "color",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        TextButton(
          style: Themes.formButtonStyle(ref),
          onPressed: () {
            showColorError = false;
            showDialog(
              context: context,
              builder: (context) => ColorPickerDialog(
                colorPickerFunction: (Color color) {
                  pickedColor = color;
                  setState(() {});
                },
                initialColor: pickedColor!,
              ),
            );
          },
          child: Row(
            children: [
              Visibility(
                visible: pickedColor != null,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: pickedColor,
                ),
              ),
              const SizedBox(width: 8.0),
              const Text("pick a color"),
            ],
          ),
        ),
        Visibility(
          visible: showColorError,
          child: Text(
            "color must be chosen",
            style: TextStyle(color: Theme.of(context).errorColor),
          ),
        ),
      ],
    );
  }

  /// Input field for the text of the tag in creation.
  TextFormField _tagTextInputField(Tag tag) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Tag text cannot be empty";
        }
        return null;
      },
      controller: textController,
      decoration: Themes.inputDecoration(
        ref,
        "text",
        "text the tag should display",
      ),
      onChanged: (value) => setState(() {}),
    );
  }

  /// Title for the appbr, depending on the [_EditTagMode] mode.
  Text _appBarTitle(_EditTagMode mode) {
    return Text(
      mode == _EditTagMode.create ? "create tag" : "edit tag",
    );
  }
}
